import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jobee/models/app_user.dart';
import 'database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {

  static Future<FirebaseApp> initializeFirebaseApp() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    // TODO: Add auto login logic

    return firebaseApp;
  }

  // Create User object based on UserCredential
  static AppUser _appUserFromFirebaseUser(User? user) {
    return AppUser(uid: user!.uid, email: user.email!);
  }

  // Auth change user stream
  static Stream<AppUser?> get user {
    return FirebaseAuth.instance.authStateChanges().map( (User? user) {

      if (user == null) {
        return null;
      }

      return _appUserFromFirebaseUser(user);
    });
  }

  /*
  // Sign In anonymously
  static Future<AppUser> signInAnon() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
      User? user = userCredential.user;
      return _appUserFromFirebaseUser(user!);
    } catch (e) {
      throw(e);
    }
  }*/

  // Sign In with e-mail and password
  static Future<AppUser> loginWithEmailAndPassword(String email, String password) async {
    /// Logs-in a normal user with an email and password.
    ///
    /// @param email Email of the user.
    /// @param password Password of the user.
    /// @returns AppUser object.
    /// @throws FireBaseAuthException If there is an error with
    ///   firebase authentication.
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword
        (email: email, password: password);
      User? user = userCredential.user;
      return _appUserFromFirebaseUser(user!);
    } catch(e){
      throw(e);
    }
  }

  // Register with e-mail and password
  static Future<AppUser> registerWithEmailAndPassword(String email, String password) async {
    /// Registers a normal user with an email and password.
    ///
    /// @param email Email of the user.
    /// @param password Password of the user.
    /// @returns AppUser object.
    /// @throws FireBaseAuthException If there is an error with
    ///   firebase authentication.
    try {
      UserCredential userCredential = await FirebaseAuth.instance.
      createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      // the user is registering for the first time if this is ever reached,
      // so we need to create a new document for the user with the uid
      await DatabaseService(uid: user!.uid).createUserData(user.email!, 'Jobee');
      return _appUserFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      throw(e);
    }
  }

  // Sign Out
  static Future<bool> signOut({required BuildContext context}) async {
    /// Signs out any user, independently of its Auth provider.
    ///
    /// @param context BuildContext object.
    /// @returns Boolean defining the success of the logout action.

    try {
      if ( await handleGoogleLogout(context: context) ) {
        return true;
      }
      await FirebaseAuth.instance.signOut();
      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }





  // --------------
  // Google Sign In
  // --------------

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      //'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  // Sign In with Google
  static Future<AppUser?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential = await auth.signInWithPopup(authProvider);
        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential = await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // ...
          } else if (e.code == 'invalid-credential') {
            // ...
          }
        } catch (e) {
          // ...
        }
      }
    }

    return _appUserFromFirebaseUser(user);
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<bool> handleGoogleLogout({required BuildContext context}) async {
    // if user is not signed-in with google, ignore
    if ( !(await _googleSignIn.isSignedIn()) ) {
      return false;
    }

    try {
      // if it's the web platform, do not use google sign-out
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        AuthService.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }

    return true;
  }

}