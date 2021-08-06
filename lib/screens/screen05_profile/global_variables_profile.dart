import 'dart:io' show Directory, File;
import 'dart:typed_data' show Uint8List;

import 'package:jobee/utils/file_utils.dart';
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import 'package:path/path.dart' show join;

class ProfileAsyncGlobals {
  static Future<File> getLocalUserProfileAvatarFile(String userId) async {
    final Directory applicationDocumentDirectory = await getApplicationDocumentsDirectory();
    final String localUserProfileAvatarPath = join(userId, 'local-profile-picture.jpg');
    //debugPrint(join(applicationDocumentDirectory.path, localUserProfileAvatarPath));
    final String localUserProfilePicturePath = join(applicationDocumentDirectory.path, localUserProfileAvatarPath);
    return File(localUserProfilePicturePath);
  }

  /// get bytes of the user's current profile avatar
  static Future<Uint8List> getLocalUserProfileAvatarBytes(String userId) async {
    final File userProfileFile = await getLocalUserProfileAvatarFile(userId);

    if (userProfileFile.existsSync()) return userProfileFile.readAsBytesSync();

    return Uint8List.fromList(<int>[]);
  }

  /// reset user's current profile avatar file and bytes
  static Future<void> deleteLocalUserProfileAvatarFileAndBytes(String userId) async {
    // delete local profile avatar bytes
    ProfileSyncGlobals.userProfileAvatarBytes = Uint8List.fromList(<int>[]);
    // delete local profile avatar file
    final File localFile = await ProfileAsyncGlobals.getLocalUserProfileAvatarFile(userId);
    createFileRecursivelyAndWriteBytesSync(localFile, Uint8List.fromList(<int>[]));
  }
}

class ProfileSyncGlobals {
  /// boolean describing if the user's current profile avatar should be updated with its remote counter-part
  static bool updateUserProfileAvatar = true;

  /// bytes of the user's current profile avatar
  static Uint8List? userProfileAvatarBytes;
}

