import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobee/services/service01_database/aux_app_user_data.dart' show AppUserData;
import 'package:jobee/models/profile.dart' show Profile;

class DatabaseService {
  // AppUser essential parameters
  final String uid;
  final String email;

  // collection reference
  static final CollectionReference<Map<String, dynamic>> userCollection = FirebaseFirestore.instance.collection('users');

  DatabaseService({ required this.uid, required this.email });

  // TODO-BackEnd: Firestore must throw an error when a document not owned by the user is write-accessed
  Future<void> createUserData(String authProvider) async {
    final DocumentSnapshot<Map<String, dynamic>> ds = await userCollection.doc(uid).get();
    if (ds.exists) return;

    // TODO-BackEnd: Firestore must expect these same exact fields, along with two false values upfront ('hasRegisteredPublicData' and 'hasRegisteredPersonalData')
    // TODO-BackEnd: Firestore must keep track of the values of 'hasRegisteredPublicData' and 'hasRegisteredPersonalData' to enforce that they change only once to true,
    //  and only with the expected set fields, as explained in the submitPublicUserData() and submitPersonalUserData() back-end to do list
    await userCollection.doc(uid).set(<String, dynamic>{
      'email': this.email,
      'authProvider': authProvider,
      'hasRegisteredPublicData': false,
      'hasRegisteredPersonalData': false,
    });
  }

  // TODO-BackEnd: Firestore must throw an error when a document not owned by the user is write-accessed
  Future<void> submitUserPublicData({required bool hasRegisteredPublicData, required String userName, required String firstName, required String lastName,
      required String gender, required String birthDay}) async {

    // TODO-BackEnd: Firestore must expect these same exact fields, with the 'hasRegisteredPublicData' true value
    final Map<String, dynamic> updatesMap = <String, dynamic>{
      'hasRegisteredPublicData': hasRegisteredPublicData,
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'birthDay': birthDay,
    };

    // TODO-BackEnd: Firestore must disallow the creation of a non-unique username
    final bool userNameAvailable = await _isUserNameAvailable(userName);
    if (!userNameAvailable) throw Exception('The username "$userName" has already been taken. Please choose another one.');

    await userCollection.doc(uid).update(updatesMap);
  }

  // TODO-BackEnd: Firestore must throw an error when a document not owned by the user is write-accessed
  Future<void> submitUserPersonalData({required bool hasRegisteredPersonalData, required String phoneCountryDialCode, required String phoneNumber}) async {

    // TODO-BackEnd: Firestore must expect these same exact fields, with the 'hasRegisteredPersonalData' true value
    final Map<String, dynamic> updatesMap = <String, dynamic>{
      'hasRegisteredPersonalData': hasRegisteredPersonalData,
      'phoneCountryDialCode': phoneCountryDialCode,
      'phoneNumber': phoneNumber
    };

    // TODO-BackEnd: Firestore must disallow the creation of a non-unique phone complete number (phone country dial code + phone number)
    final bool phoneCompleteNumberAvailable = await _isPhoneCompleteNumberAvailable(phoneCountryDialCode, phoneNumber);
    if (!phoneCompleteNumberAvailable) {
      throw Exception("The phone number '$phoneCountryDialCode $phoneNumber' has already been registered. "
        "Please register another number.");
    }

    await userCollection.doc(uid).update(updatesMap);
  }

  // TODO-BackEnd: Firestore must throw an error when a document not owned by the user is write-accessed
  Future<void> updateUserProfileData({required String firstName, required String lastName,
    required String gender, required String birthDay, required String about}) async {

    // TODO-BackEnd: Firestore must expect these same exact fields
    final Map<String, dynamic> updatesMap = <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'birthDay': birthDay,
      'about': about,
    };

    // eliminate null values
    //updatesMap.removeWhere((String key, dynamic value) => value==null);

    await userCollection.doc(uid).update(updatesMap);
  }

  /* STATIC METHODS */
  static Future<bool> _isUserNameAvailable(String userName) async {
    return (await FirebaseFirestore.instance.collection('users').where('userName', isEqualTo: userName.toLowerCase()).get()).docs.isEmpty;
  }

  static Future<bool> _isPhoneCompleteNumberAvailable(String phoneCountryDialCode, String phoneNumber) async {
    return (await FirebaseFirestore.instance.collection('users')
      .where('phoneCountryDialCode', isEqualTo: phoneCountryDialCode)
      .where('phoneNumber', isEqualTo: phoneNumber).get())
      .docs.isEmpty;
  }

  /* PRIVATE METHODS */
  // profile list from snapshot
  static List<Profile> _profileListFromSnapshot(QuerySnapshot<dynamic> snapshot) {
    return snapshot.docs.map((QueryDocumentSnapshot<dynamic> doc) {
      final Map<dynamic, dynamic> docDataMap = doc.data()! as Map<dynamic, dynamic>;
      return Profile(
        userName: (docDataMap['userName'] as String?) ?? '',
      );
    }).toList();
  }

  // userData from snapshot
  AppUserData _appUserDataFromDocumentSnapshot(DocumentSnapshot<dynamic> documentSnapshot) {
    final Map<String, dynamic>? snapshotDataMap = documentSnapshot.data() as Map<String, dynamic>?;
    if (snapshotDataMap==null) {
      return AppUserData(
        uid: this.uid,
        email: this.email,
      );
    }

    return AppUserData(
      uid: this.uid,
      email: snapshotDataMap['email']! as String,
      hasRegisteredPublicData: snapshotDataMap['hasRegisteredPublicData']! as bool,
      hasRegisteredPersonalData: snapshotDataMap['hasRegisteredPersonalData']! as bool,
      userName: snapshotDataMap['userName'] as String?,
      firstName: snapshotDataMap['firstName'] as String?,
      lastName: snapshotDataMap['lastName'] as String?,
      gender: snapshotDataMap['gender'] as String?,
      birthDay: snapshotDataMap['birthDay'] as String?,
      phoneCountryDialCode: snapshotDataMap['phoneCountryDialCode'] as String?,
      phoneNumber: snapshotDataMap['phoneNumber'] as String?,
    );
  }

  /* GETTERS */
  // get profiles stream
  static Stream<List<Profile>> get profiles {
    return userCollection.snapshots().map(_profileListFromSnapshot);
  }

  // get user doc stream as AppUserData
  Stream<AppUserData> get appUserData {
    return userCollection.doc(uid).snapshots().map( (DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
      final AppUserData appUserData = _appUserDataFromDocumentSnapshot(documentSnapshot);
      return appUserData;
    });
  }

  // get initial AppUserData
  Future<AppUserData> getInitialAppUserDataFuture() async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await userCollection.doc(uid).get();
    // while the user document doesn't exist (in case of a user registry)
    while (!documentSnapshot.exists) {
      // continuously ask for the user document until we get it
      documentSnapshot = await userCollection.doc(uid).get();
      // cap network requests per second to 5 (200 ms)
      if (!documentSnapshot.exists) await Future<void>.delayed(const Duration(milliseconds: 200));
    }

    return _appUserDataFromDocumentSnapshot(documentSnapshot);
  }

}