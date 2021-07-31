import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart' show GoogleSignIn, GoogleSignInAccount, GoogleSignInAuthentication;
import 'package:jobee/services/service00_authentication/aux_app_user.dart' show AppUser;

import '0.0_auth.dart' show AuthService;

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      //'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  /// Sign In with Google
  static Future<AppUser?> signInWithGoogle() async {
    /// Signs in user with Google. If user already has a Jobee account with the same
    /// e-mail registered, it signs them in normally on their account. If user does
    /// not have an account
    ///
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

    return (user!=null)?AuthService.appUserFromFirebaseUser(user):null;
  }

  static Future<bool> handleGoogleLogout() async {
    // if user is not signed-in with google, ignore
    if ( !(await _googleSignIn.isSignedIn()) ) {
      return false;
    }

    try {
      // if it isn't the web platform, use google sign-out
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
      // else, use normal sign out
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      /*
      const SnackBar signOutSnackBar = SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          'Error signing out. Try again.',
          style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        signOutSnackBar,
      );
      */
    }

    return true;
  }
}