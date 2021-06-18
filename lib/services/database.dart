import 'package:jobee/models/app_user.dart';
import 'package:jobee/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // uid
  final String? uid;
  // collection reference
  final CollectionReference profileCollection = FirebaseFirestore.instance.collection("profiles");

  DatabaseService({ this.uid });

  Future<void> createUserData(String email, String authProvider) async {
    DocumentSnapshot ds = await profileCollection.doc(uid).get();
    if (ds.exists) {
      return null;
    }

    await profileCollection.doc(uid).set({
      'email': email,
      'authProvider': authProvider
    });
  }

  Future<void> updateUserData(String name, String gender) async {
    await profileCollection.doc(uid).update({
      'name': name,
      'gender': gender
    });
  }

  // profile list from snapshot
  List<Profile> _profileListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      print(doc.data()['name']);
      print(doc.data()['']);
      return Profile(
        name: doc.data()['name'] ?? ''
      );
    }).toList();
  }

  // userData from snapshot
  AppUserData _appUserDataFromSnapshot(DocumentSnapshot snapshot) {
    return AppUserData(
      uid: uid!,
      email: snapshot.data()!['email'],
      name: snapshot.data()!['name']??"('name' not yet provided)",
      phoneNumber: snapshot.data()!['phoneNumber']??"('phone number' not yet provided)"
    );
  }


  // get profiles stream
  Stream<List<Profile>> get profiles {
    return profileCollection.snapshots().map(_profileListFromSnapshot);
  }

  // get user doc stream
  Stream<AppUserData> get appUserData {
    return profileCollection.doc(uid).snapshots().map( (snapshot) {
      return _appUserDataFromSnapshot(snapshot);
    });
  }

}