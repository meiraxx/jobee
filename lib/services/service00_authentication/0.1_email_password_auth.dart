import 'package:firebase_auth/firebase_auth.dart';

import '../service01_database/1.0_database.dart' show DatabaseService;
import '0.0_auth.dart' show AuthService;
import 'aux_app_user.dart' show AppUser;

class EmailPasswordAuthService {
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
      return AuthService.appUserFromFirebaseUser(user!);
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
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      final User? user = userCredential.user;

      // the user is registering for the first time if this is ever reached,
      // so we need to create a new document for the user with the uid
      await DatabaseService(uid: user!.uid, email: user.email!).createUserData('Jobee');
      return AuthService.appUserFromFirebaseUser(user);
    } on FirebaseAuthException {
      rethrow;
    }
  }
}