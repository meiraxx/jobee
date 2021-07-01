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
    if (ds.exists) return null;

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

    if (userName!=null) {
      bool userNameAvailable = await _isUserNameAvailable(userName);
      if (!userNameAvailable) throw Exception("The username '$userName' has already been taken. Please choose another one.");
    }

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

    if (phoneCountryDialCode!=null && phoneNumber!=null) {
      bool phoneCompleteNumberAvailable = await _isPhoneCompleteNumberAvailable(phoneCountryDialCode, phoneNumber);
      if (!phoneCompleteNumberAvailable)
        throw Exception("The phone number '$phoneCountryDialCode $phoneNumber' has already been registered. "
          "Please register another number.");
    }

    await profileCollection.doc(uid).update(updatesMap);
  }

  /* STATIC METHODS */
  static Future<bool> _isUserNameAvailable(String userName) async {
    // TODO-BackEnd: Firestore must throw an error on duplicate username creation
    return (await FirebaseFirestore.instance.collection("profiles").where("userName", isEqualTo: userName).get()).docs.length == 0;
  }

  static Future<bool> _isPhoneCompleteNumberAvailable(String phoneCountryDialCode, String phoneNumber) async {
    // TODO-BackEnd: Firestore must throw an error on duplicate phone number creation
    return (await FirebaseFirestore.instance.collection("profiles")
      .where("phoneCountryDialCode", isEqualTo: phoneCountryDialCode)
      .where("phoneNumber", isEqualTo: phoneNumber).get())
      .docs.length == 0;
  }

  /* PRIVATE METHODS */
  // profile list from snapshot
  List<Profile> _profileListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Map docDataMap = doc.data() as Map;
      return Profile(
        userName: docDataMap['userName'] ?? ''
      );
    }).toList();
  }

  // userData from snapshot
  AppUserData? _appUserDataFromSnapshot(DocumentSnapshot snapshot) {
    Map? snapshotDataMap = snapshot.data() as Map?;
    if (snapshotDataMap==null) {
      return null;
    } else {
      return AppUserData(
        uid: uid!,
        email: snapshotDataMap['email'],
        hasRegisteredPublicData: snapshotDataMap['hasRegisteredPublicData'],
        hasRegisteredPersonalData: snapshotDataMap['hasRegisteredPersonalData'],
        userName: snapshotDataMap['userName'],
        firstName: snapshotDataMap['firstName'],
        lastName: snapshotDataMap['lastName'],
        gender: snapshotDataMap['gender'],
        birthDay: snapshotDataMap['birthDay'],
        phoneCountryDialCode: snapshotDataMap['phoneCountryDialCode'],
        phoneNumber: snapshotDataMap['phoneNumber'],
      );
    }
    /*return (snapshotDataMap==null)
      ?null
      :AppUserData(
        uid: uid!,
        email: snapshotDataMap['email'],
        hasRegisteredPublicData: snapshotDataMap['hasRegisteredPublicData'],
        hasRegisteredPersonalData: snapshotDataMap['hasRegisteredPersonalData'],
        userName: snapshotDataMap['userName'],
        firstName: snapshotDataMap['firstName'],
        lastName: snapshotDataMap['lastName'],
        gender: snapshotDataMap['gender'],
        birthDay: snapshotDataMap['birthDay'],
        phoneCountryDialCode: snapshotDataMap['phoneCountryDialCode'],
        phoneNumber: snapshotDataMap['phoneNumber'],
      )
    ;*/
  }

  /* GETTERS */
  // get profiles stream
  Stream<List<Profile>> get profiles {
    return profileCollection.snapshots().map(_profileListFromSnapshot);
  }

  // get user doc stream
  Stream<AppUserData?> get appUserData {
    return profileCollection.doc(uid).snapshots().map( (snapshot) {
      return _appUserDataFromSnapshot(snapshot);
    });
  }

}