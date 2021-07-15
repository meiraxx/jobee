import 'dart:async';
import 'dart:io' show File;
import 'dart:io';
import 'dart:typed_data' show Uint8List;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart' show PickedFile;
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;

import 'save_as/save_as.dart' show saveAsBytes;

class StorageService {
  // uid
  final String? uid;
  // user directory remote reference
  Reference? _userDirRemoteRef;

  StorageService({ this.uid }) {
    if (this.uid != null) {
      _userDirRemoteRef = FirebaseStorage.instance.ref().child(this.uid!);
    }
  }

  /// Getter for user dir remote ref
  Reference? get userDirRemoteRef {
    return _userDirRemoteRef;
  }

  /// Create a directory in Firebase Storage
  /*Future<void> _createUserDirectory(Reference remoteDirRef) async {
    // the only way to create a folder on firebase storage is to put a file there
    remoteDirRef.child('temp.txt').putString(DateTime.now().toString());
    // wait 10 seconds for the previous action to register on the server
    Future<void>.delayed(const Duration(seconds: 10)).then((void onValue) {
      // to delete the file
      remoteDirRef.child('temp.txt').delete();
    });
  }*/

  /// The user selects a file, and the task is added to the list.
  Future<UploadTask?> uploadUserFile({required BuildContext context, PickedFile? pickedFile, required String remoteFileName, bool showError = false}) async {
    if (pickedFile == null) {
      // if showError flag is true
      if (showError) {
        // show error message
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No file was selected'),
        ));
      }
      return null;
    }
    UploadTask uploadTask;

    // Create a Reference to the file
    final Reference remoteFileRef = FirebaseStorage.instance
        .ref()
        .child(this.uid!)
        .child(remoteFileName);

    // TODO-BackEnd: disallow users with certain uid to write outside of their directory
    final SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: <String, String>{'picked-file-path': pickedFile.path});

    if (kIsWeb) {
      uploadTask = remoteFileRef.putData(await pickedFile.readAsBytes(), metadata);
    } else {
      uploadTask = remoteFileRef.putFile(File(pickedFile.path), metadata);
    }

    return Future<UploadTask>.value(uploadTask);
  }

  static Future<File?> downloadFile({required Reference remoteFileRef, required String localFileName}) async {
    assert(remoteFileRef.parent!=null, 'downloadFile() error: remoteFileRef needs to be included in a directory');
    String url;

    final bool remoteFileExistsInDirectory = await _checkIfRemoteFileExists(remoteFileRef);

    /* if the target remote file reference points to a
     * file that does not exist in its directory */
    if (!remoteFileExistsInDirectory) {
      // return null
      return null;
    }

    // else, obtain url from firebase
    url = await remoteFileRef.getDownloadURL().onError((Object? error, StackTrace stackTrace) {
      // error getting profile picture
      return '';
    });

    if (url=='') return null;

    // get http response from url
    final http.Response response = await http.get(Uri.parse(url));


    final Directory documentDirectory = await getApplicationDocumentsDirectory();

    final File file = File(join(documentDirectory.path, localFileName));

    file.writeAsBytesSync(response.bodyBytes);

    return file;
  }

  /// Lists the child references of a remote directory
  static Future<List<Reference>> _listChildRemoteRefs(Reference remoteDirRef) async {
    return (await remoteDirRef.list()).items;
  }

  /// Checks if a remote file reference is valid by validating if a remote file
  /// exists in the specified remote directory
  static Future<bool> _checkIfRemoteFileExists(Reference remoteFileRef) async {
    assert(remoteFileRef.parent!=null, '_checkIfRemoteFileExists() error: remoteFileRef needs to be included in a directory');
    final Reference remoteDirRef = remoteFileRef.parent!;
    final List<Reference> childRemoteRefList = await _listChildRemoteRefs(remoteDirRef);
    bool exists = false;

    for (final Reference childRemoteRef in childRemoteRefList) {
      exists = childRemoteRef.fullPath == remoteFileRef.fullPath;
    }

    return exists;
  }

  static Future<void> downloadBytes({required Reference remoteRef, required String localFileName}) async {
    final Uint8List? bytes = await remoteRef.getData();
    if (bytes==null) return;

    // Download...
    await saveAsBytes(bytes, localFileName);

    // return the local file
    //return File(localFileName);
  }

}