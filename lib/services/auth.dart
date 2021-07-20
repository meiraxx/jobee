import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart' show GoogleSignIn, GoogleSignInAccount, GoogleSignInAuthentication;
import 'package:jobee/models/app_user.dart' show AppUser;

import 'database.dart' show DatabaseService;

class AuthService {

  /// Create User object based on UserCredential
  static AppUser _appUserFromFirebaseUser(User user) {
    return AppUser(uid: user.uid, email: user.email!);
  }

  /// Auth change user stream
  static Stream<AppUser?> get user {
    return FirebaseAuth.instance.authStateChanges().map( (User? user) {

      if (user == null) {
        return null;
      }

      return _appUserFromFirebaseUser(user);
    });
  }

  /// Sign In anonymously
  static Future<AppUser> signInAnon() async {
    /// Signs-in a guest.
    /// @returns AppUser object.
    /// @throws FireBaseAuthException If there is an error with
    ///   firebase authentication.
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
      final User? user = userCredential.user;
      return _appUserFromFirebaseUser(user!);
    } catch (e) {
      rethrow;
    }
  }

  /// Sign In with e-mail and password
  static Future<AppUser> loginWithEmailAndPassword(String email, String password) async {
    /// Signs-in a user using the default email-password Firebase Authentication.
    ///
    /// @param String email Email of the user.
    /// @param String password Password of the user.
    /// @returns AppUser object.
    /// @throws FireBaseAuthException If there is an error with
    ///   firebase authentication.
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword
        (email: email, password: password);
      final User? user = userCredential.user;
      return _appUserFromFirebaseUser(user!);
    } catch(e){
      rethrow;
    }
  }

  /// Register with e-mail and password
  static Future<AppUser> registerWithEmailAndPassword(String email, String password) async {
    /// Registers a user using the default email-password Firebase Authentication.
    ///
    /// @param String email Email of the user.
    /// @param String password Password of the user.
    /// @returns AppUser object.
    /// @throws FireBaseAuthException If there is an error with
    ///   firebase authentication.
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.
      createUserWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;

      // the user is registering for the first time if this is ever reached,
      // so we need to create a new document for the user with the uid
      await DatabaseService(uid: user!.uid).createUserData(user.email!, 'Jobee');
      return _appUserFromFirebaseUser(user);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  /// Sign Out
  static Future<bool> signOut({required BuildContext context}) async {
    /// Signs out any user, independently of its Auth provider.
    ///
    /// @param BuildContext context The current flutter widget context..
    /// @returns Boolean defining the success of the logout action.

    try {
      if ( await handleGoogleLogout(context: context) ) {
        return true;
      }
      await FirebaseAuth.instance.signOut();
      return true;
    } catch(e) {
      // an error occurred, could not sign out
      return false;
    }
  }





  // --------------
  // Google Sign In
  // --------------

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      //'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  /// Sign In with Google
  static Future<AppUser?> signInWithGoogle({required BuildContext context}) async {
    /// Signs in user with Google. If user already has a Jobee account with the same
    /// e-mail registered, it signs them in normally on their account. If user does
    /// not have an account
    ///
    /// @param BuildContext context The current flutter widget context.
    /// @returns Boolean defining the success of the logout action.
    ///
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      final GoogleAuthProvider authProvider = GoogleAuthProvider();

      final UserCredential userCredential = await auth.signInWithPopup(authProvider);
      user = userCredential.user;
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

    return (user!=null)?_appUserFromFirebaseUser(user):null;
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
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