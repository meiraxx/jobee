import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobee/models/app_user.dart' show AppUserData;
import 'package:jobee/models/profile.dart' show Profile;

class DatabaseService {
  // uid
  final String? uid;
  // collection reference
  final CollectionReference<Map<String, dynamic>> userCollection = FirebaseFirestore.instance.collection('users');

  DatabaseService({ this.uid });

  // TODO-BackEnd: Firestore must throw an error when a document not owned by the user is write-accessed
  Future<void> createUserData(String email, String authProvider) async {
    final DocumentSnapshot<Map<String, dynamic>> ds = await userCollection.doc(uid).get();
    if (ds.exists) return;

    // TODO-BackEnd: Firestore must expect these same exact fields, along with two false values upfront ('hasRegisteredPublicData' and 'hasRegisteredPersonalData')
    // TODO-BackEnd: Firestore must keep track of the values of 'hasRegisteredPublicData' and 'hasRegisteredPersonalData' to enforce that they change only once to true,
    //  and only with the expected set fields, as explained in the updatePublicUserData() and updatePersonalUserData() back-end to do list
    await userCollection.doc(uid).set(<String, dynamic>{
      'email': email,
      'authProvider': authProvider,
      'hasRegisteredPublicData': false,
      'hasRegisteredPersonalData': false,
    });
  }

  // TODO-BackEnd: Firestore must throw an error when a document not owned by the user is write-accessed
  Future<void> updatePublicUserData({required bool hasRegisteredPublicData, String? userName, String? firstName, String? lastName,
      String? gender, String? birthDay}) async {

    // TODO-BackEnd: Firestore must expect these same exact fields, with the 'hasRegisteredPublicData' true value
    final Map<String, dynamic> updatesMap = <String, dynamic>{
      'hasRegisteredPublicData': hasRegisteredPublicData,
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'birthDay': birthDay,
    };

    // eliminate null values
    updatesMap.removeWhere((String key, dynamic value) => value==null);

    // TODO-BackEnd: Firestore must disallow the creation of a non-unique username
    if (userName!=null) {
      final bool userNameAvailable = await _isUserNameAvailable(userName);
      if (!userNameAvailable) throw Exception('The username "$userName" has already been taken. Please choose another one.');
    }

    await userCollection.doc(uid).update(updatesMap);
  }

  // TODO-BackEnd: Firestore must throw an error when a document not owned by the user is write-accessed
  Future<void> updatePersonalUserData({required bool hasRegisteredPersonalData, String? phoneCountryDialCode, String? phoneNumber}) async {

    // TODO-BackEnd: Firestore must expect these same exact fields, with the 'hasRegisteredPersonalData' true value
    final Map<String, dynamic> updatesMap = <String, dynamic>{
      'hasRegisteredPersonalData': hasRegisteredPersonalData,
      'phoneCountryDialCode': phoneCountryDialCode,
      'phoneNumber': phoneNumber
    };

    // eliminate null values
    updatesMap.removeWhere((String key, dynamic value) => value==null);

    // TODO-BackEnd: Firestore must disallow the creation of a non-unique phone complete number (phone country dial code + phone number)
    if (phoneCountryDialCode!=null && phoneNumber!=null) {
      final bool phoneCompleteNumberAvailable = await _isPhoneCompleteNumberAvailable(phoneCountryDialCode, phoneNumber);
      if (!phoneCompleteNumberAvailable) {
        throw Exception("The phone number '$phoneCountryDialCode $phoneNumber' has already been registered. "
          "Please register another number.");
      }
    }

    await userCollection.doc(uid).update(updatesMap);
  }

  /* STATIC METHODS */
  static Future<bool> _isUserNameAvailable(String userName) async {
    return (await FirebaseFirestore.instance.collection('users').where('userName', isEqualTo: userName).get()).docs.isEmpty;
  }

  static Future<bool> _isPhoneCompleteNumberAvailable(String phoneCountryDialCode, String phoneNumber) async {
    return (await FirebaseFirestore.instance.collection('users')
      .where('phoneCountryDialCode', isEqualTo: phoneCountryDialCode)
      .where('phoneNumber', isEqualTo: phoneNumber).get())
      .docs.isEmpty;
  }

  /* PRIVATE METHODS */
  // profile list from snapshot
  List<Profile> _profileListFromSnapshot(QuerySnapshot<dynamic> snapshot) {
    return snapshot.docs.map((QueryDocumentSnapshot<dynamic> doc) {
      final Map<dynamic, dynamic> docDataMap = doc.data()! as Map<dynamic, dynamic>;
      return Profile(
        userName: (docDataMap['userName'] as String?) ?? '',
      );
    }).toList();
  }

  // userData from snapshot
  AppUserData? _appUserDataFromSnapshot(DocumentSnapshot<dynamic> snapshot) {
    final Map<String, dynamic>? snapshotDataMap = snapshot.data() as Map<String, dynamic>?;
    if (snapshotDataMap==null) {
      return null;
    }

    return AppUserData(
      uid: uid!,
      email: snapshotDataMap['email'] as String,
      hasRegisteredPublicData: snapshotDataMap['hasRegisteredPublicData'] as bool,
      hasRegisteredPersonalData: snapshotDataMap['hasRegisteredPersonalData'] as bool,
      userName: snapshotDataMap['userName'] as String,
      firstName: snapshotDataMap['firstName'] as String,
      lastName: snapshotDataMap['lastName'] as String,
      gender: snapshotDataMap['gender'] as String,
      birthDay: snapshotDataMap['birthDay'] as String,
      phoneCountryDialCode: snapshotDataMap['phoneCountryDialCode'] as String,
      phoneNumber: snapshotDataMap['phoneNumber'] as String,
    );
  }

  /* GETTERS */
  // get profiles stream
  Stream<List<Profile>> get profiles {
    return userCollection.snapshots().map(_profileListFromSnapshot);
  }

  // get user doc stream
  Stream<AppUserData?> get appUserData {
    return userCollection.doc(uid).snapshots().map( (DocumentSnapshot<Map<String, dynamic>> snapshot) {
      return _appUserDataFromSnapshot(snapshot);
    });
  }

}