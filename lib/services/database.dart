import 'package:jobee/models/app_user.dart';
import 'package:jobee/models/job.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // uid
  final String uid;
  // collection reference
  final CollectionReference jobCollection = FirebaseFirestore.instance.collection("jobs");

  DatabaseService({ this.uid });

  Future updateUserData(String sugars, String name, int strength) async {
    return await jobCollection.doc(uid).set({
      'name': name
    });
  }

  // brew list from snapshot
  List<Job> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Job(
          name: doc.data()['name'] ?? ''
      );
    }).toList();
  }

  // userData from snapshot
  AppUserData _appUserDataFromSnapshot(DocumentSnapshot snapshot) {
    return AppUserData(
      uid: uid,
      name: snapshot.data()['name']
    );
  }


  // get brews stream
  Stream<List<Job>> get jobs {
    return jobCollection.snapshots().map(_brewListFromSnapshot);
  }

  // get user doc stream
  Stream<AppUserData> get appUserData {
    return jobCollection.doc(uid).snapshots().map( (snapshot) {
      return _appUserDataFromSnapshot(snapshot);
    });
  }

}