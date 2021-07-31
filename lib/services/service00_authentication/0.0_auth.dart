import 'package:firebase_auth/firebase_auth.dart';
import 'package:jobee/services/service00_authentication/aux_app_user.dart' show AppUser;

import '0.2_google_auth.dart' show GoogleAuthService;

class AuthService {

  /// Create User object based on UserCredential
  static AppUser appUserFromFirebaseUser(User user) {
    return AppUser(uid: user.uid, email: user.email!);
  }

  /// Auth change user stream
  static Stream<AppUser?> get user {
    return FirebaseAuth.instance.authStateChanges().map( (User? user) {

      if (user == null) {
        return null;
      }

      return appUserFromFirebaseUser(user);
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
      return appUserFromFirebaseUser(user!);
    } catch (e) {
      rethrow;
    }
  }

  /// Sign Out
  static Future<bool> signOut() async {
    /// Signs out any user, independently of its Auth provider.
    ///
    /// @returns Boolean defining the success of the logout action.

    try {
      // attempt to use google logout
      if ( await GoogleAuthService.handleGoogleLogout() ) return true;

      // else, use default sign out
      await FirebaseAuth.instance.signOut();
      return true;
    } catch(e) {
      // an error occurred, could not sign out
      return false;
    }
  }
}
