import 'package:jobee/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create User object based on UserCredential
  AppUser _appUserFromFirebaseUser(User user) {
    return user!=null ? AppUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<AppUser> get user {
    return _auth.authStateChanges()
      .map((User user) => _appUserFromFirebaseUser(user));
  }

  // sign-in anonymously
  Future signInAnon() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User user = userCredential.user;
      return _appUserFromFirebaseUser(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // sign-in with e-mail and password
  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword
        (email: email, password: password);
      User user = userCredential.user;
      return _appUserFromFirebaseUser(user);
    } catch(e){
      print(e);
      return null;
    }
  }

  // register with e-mail and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword
        (email: email, password: password);
      User user = userCredential.user;

      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData('0', 'new crew member', 100);
      return _appUserFromFirebaseUser(user);
    } catch(e){
      print(e);
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e);
      return null;
    }
  }
}