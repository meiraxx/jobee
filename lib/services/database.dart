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
      'authProvider': authProvider,
      'hasRegisteredPublicData': false,
      'hasRegisteredPersonalData': false,
    });
  }

  Future<void> updatePublicUserData({required bool hasRegisteredPublicData, String? userName, String? firstName, String? lastName,
      String? gender, String? birthDay}) async {

    Map<String, Object?> updatesMap = {
      'hasRegisteredPublicData': hasRegisteredPublicData,
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'birthDay': birthDay
    };

    // eliminate null values
    updatesMap.removeWhere((key, value) => value==null);

    await profileCollection.doc(uid).update(updatesMap);
  }

  Future<void> updatePersonalUserData({required bool hasRegisteredPersonalData, String? phoneCountryDialCode, String? phoneNumber}) async {

    Map<String, Object?> updatesMap = {
      'hasRegisteredPersonalData': hasRegisteredPersonalData,
      'phoneCountryDialCode': phoneCountryDialCode,
      'phoneNumber': phoneNumber
    };

    // eliminate null values
    updatesMap.removeWhere((key, value) => value==null);

    await profileCollection.doc(uid).update(updatesMap);
  }

  // profile list from snapshot
  List<Profile> _profileListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Profile(
        userName: doc.data()['userName'] ?? ''
      );
    }).toList();
  }

  // userData from snapshot
  AppUserData _appUserDataFromSnapshot(DocumentSnapshot snapshot) {
    return AppUserData(
      uid: uid!,
      email: snapshot.data()!['email'],
      hasRegisteredPublicData: snapshot.data()!['hasRegisteredPublicData'],
      hasRegisteredPersonalData: snapshot.data()!['hasRegisteredPersonalData'],
      userName: snapshot.data()!['userName'],
      firstName: snapshot.data()!['firstName'],
      lastName: snapshot.data()!['lastName'],
      gender: snapshot.data()!['gender'],
      birthDay: snapshot.data()!['birthDay'],
      phoneCountryDialCode: snapshot.data()!['phoneCountryDialCode'],
      phoneNumber: snapshot.data()!['phoneNumber'],
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