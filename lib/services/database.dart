import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobee/models/app_user.dart' show AppUserData;
import 'package:jobee/models/profile.dart' show Profile;

class DatabaseService {
  // uid
  final String? uid;
  // collection reference
  final CollectionReference profileCollection = FirebaseFirestore.instance.collection("profiles");

  DatabaseService({ this.uid });

  // TODO-BackEnd: Firestore must throw an error when a document not owned by the user is write-accessed
  Future<void> createUserData(String email, String authProvider) async {
    DocumentSnapshot ds = await profileCollection.doc(uid).get();
    if (ds.exists) return null;

    // TODO-BackEnd: Firestore must expect these same exact fields, along with two false values upfront ("hasRegisteredPublicData" and "hasRegisteredPersonalData")
    // TODO-BackEnd: Firestore must keep track of the values of "hasRegisteredPublicData" and "hasRegisteredPersonalData" to enforce that they change only once to true,
    //  and only with the expected set fields, as explained in the updatePublicUserData() and updatePersonalUserData() back-end to do list
    await profileCollection.doc(uid).set({
      'email': email,
      'authProvider': authProvider,
      'hasRegisteredPublicData': false,
      'hasRegisteredPersonalData': false,
    });
  }

  // TODO-BackEnd: Firestore must throw an error when a document not owned by the user is write-accessed
  Future<void> updatePublicUserData({required bool hasRegisteredPublicData, String? userName, String? firstName, String? lastName,
      String? gender, String? birthDay}) async {

    // TODO-BackEnd: Firestore must expect these same exact fields, with the "hasRegisteredPublicData" true value
    Map<String, Object?> updatesMap = {
      'hasRegisteredPublicData': hasRegisteredPublicData,
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'birthDay': birthDay,
    };

    // eliminate null values
    updatesMap.removeWhere((key, value) => value==null);

    // TODO-BackEnd: Firestore must disallow the creation of a non-unique username
    if (userName!=null) {
      bool userNameAvailable = await _isUserNameAvailable(userName);
      if (!userNameAvailable) throw Exception("The username '$userName' has already been taken. Please choose another one.");
    }

    await profileCollection.doc(uid).update(updatesMap);
  }

  // TODO-BackEnd: Firestore must throw an error when a document not owned by the user is write-accessed
  Future<void> updatePersonalUserData({required bool hasRegisteredPersonalData, String? phoneCountryDialCode, String? phoneNumber}) async {

    // TODO-BackEnd: Firestore must expect these same exact fields, with the "hasRegisteredPersonalData" true value
    Map<String, Object?> updatesMap = {
      'hasRegisteredPersonalData': hasRegisteredPersonalData,
      'phoneCountryDialCode': phoneCountryDialCode,
      'phoneNumber': phoneNumber
    };

    // eliminate null values
    updatesMap.removeWhere((key, value) => value==null);

    // TODO-BackEnd: Firestore must disallow the creation of a non-unique phone complete number (phone country dial code + phone number)
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
    return (await FirebaseFirestore.instance.collection("profiles").where("userName", isEqualTo: userName).get()).docs.length == 0;
  }

  static Future<bool> _isPhoneCompleteNumberAvailable(String phoneCountryDialCode, String phoneNumber) async {
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
    }

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