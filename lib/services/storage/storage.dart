import 'dart:io' show File;
import 'dart:typed_data' show Uint8List;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart' show BuildContext;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart' show PickedFile;
import 'package:jobee/utils/file_utils.dart' show createFileRecursivelyAndWriteBytesSync;
import 'package:jobee/utils/crypto_operations.dart' show calculateSHA256FromBytes;

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
  Future<List<UploadTask>?> uploadUserFile({required BuildContext context, PickedFile? pickedFile, required String remoteFileName}) async {
    if (pickedFile == null) return null;
    UploadTask fileUploadTask;
    UploadTask sha256UploadTask;

    // Create a Reference to the file
    final Reference remoteFileRef = FirebaseStorage.instance
        .ref()
        .child(this.uid!)
        .child(remoteFileName);

    // TODO-BackEnd: disallow users with certain uid to write outside of their directory
    final SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: <String, String>{'picked-file-path': pickedFile.path});

    final String sha256Digest = calculateSHA256FromBytes(await pickedFile.readAsBytes());
    final Reference remoteSHA256Ref = FirebaseStorage.instance
      .ref()
      .child(this.uid!)
      .child(remoteFileName.replaceFirst(".jpg", ".sha256"));

    // if/else for web (html) and other platforms
    if (kIsWeb) {
      sha256UploadTask = remoteSHA256Ref.putData(Uint8List.fromList(sha256Digest.codeUnits));
      fileUploadTask = remoteFileRef.putData(await pickedFile.readAsBytes(), metadata);
    } else {
      sha256UploadTask = remoteSHA256Ref.putData(Uint8List.fromList(sha256Digest.codeUnits));
      fileUploadTask = remoteFileRef.putFile(File(pickedFile.path), metadata);
    }

    return <UploadTask>[fileUploadTask, sha256UploadTask];
  }

  static Future<File?> downloadUserFile({required Reference remoteFileRef, required File localFile, required Uint8List localBytes}) async {
    /// Signs in user with Google. If user already has a Jobee account with the same
    /// e-mail registered, it signs them in normally on their account. If user does
    /// not have an account
    ///
    /// @param remoteFileRef Reference Remote file reference on FireBase Storage.
    /// @param localFileName String Local file name on this platform.
    /// @returns null if:
    ///   1. user still has no picture uploaded on the server
    ///   2. user still did not download picture once on this platform
    ///   3. the server picture is the same as the local picture
    ///   4. an error occurred requesting a Get-URL from FireBase
    assert(remoteFileRef.parent!=null, 'downloadFile() error: remoteFileRef needs to be included in a directory');
    final Reference remoteSHA256Ref = remoteFileRef.parent!.child(remoteFileRef.name.replaceFirst(".jpg", ".sha256"));

    /* ------------------------------- */
    /* DOWNLOAD SHA256 AND VALIDATE IT */
    /* ------------------------------- */
    // if the profile avatar file already exists locally
    if (localFile.existsSync()) {
      // we validate server sha256 vs local sha256
      String sha256URL;
      final bool remoteSHA256ExistsInDirectory = await _checkIfRemoteFileExists(remoteSHA256Ref);

      /* if the target remote file reference of the file sha256 digest points
     * to a file that does not exist in its directory, return null */
      if (!remoteSHA256ExistsInDirectory) return null;

      // else, obtain url from firebase (return empty string if there's an error getting profile picture)
      sha256URL = await remoteSHA256Ref.getDownloadURL().onError((Object? error, StackTrace stackTrace) => '');

      // if no sha256 url or file url is returned, return null
      if (sha256URL=='') return null;

      // else...
      // download remote file's sha256 hash digest
      final http.Response sha256Response = await http.get(Uri.parse(sha256URL)); // get http response from url
      final String remoteSHA256Digest = sha256Response.body;

      // get
      final String localSHA256Digest = calculateSHA256FromBytes(localBytes);
      //debugPrint('Remote SHA256 digest: $remoteSHA256Digest');
      //debugPrint('Local SHA256 digest: $localSHA256Digest');

      // validate if the current sha256 stored in the server is the same as the local
      // file's sha256 we already have. If it is, this means we should not request
      // the download of the image, thus saving bandwidth and UI refresh time
      if (remoteSHA256Digest == localSHA256Digest) return null;
    }

    /* -------------------------- */
    /* DOWNLOAD FILE AND WRITE IT */
    /* -------------------------- */
    String fileURL;
    final bool remoteFileExistsInDirectory = await _checkIfRemoteFileExists(remoteFileRef);

    /* if the target remote file reference of the file points to
     * a file that does not exist in its directory, return null */
    if (!remoteFileExistsInDirectory) return null;

    // else, obtain url from firebase (return empty string if there's an error getting profile picture)
    fileURL = await remoteFileRef.getDownloadURL().onError((Object? error, StackTrace stackTrace) => '');

    // if no sha256 url or file url is returned, return null
    if (fileURL=='') return null;

    // else, success, so we go and download the file
    // fetch file from the server
    final http.Response fileResponse = await http.get(Uri.parse(fileURL));
    // write file locally
    createFileRecursivelyAndWriteBytesSync(localFile, fileResponse.bodyBytes);

    return localFile;
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
      if (exists) break;
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