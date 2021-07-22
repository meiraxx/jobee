import 'dart:io' show Directory, File;
import 'dart:typed_data' show Uint8List;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import 'package:path/path.dart' show join;

class ProfileAsyncGlobals {
  static Future<File?> getLocalUserProfileFile() async {
    final Directory applicationDocumentDirectory = await getApplicationDocumentsDirectory();
    final String localUserProfilePicturePath = join(applicationDocumentDirectory.path, 'local-profile-picture.jpg');
    return File(localUserProfilePicturePath).existsSync()
        ? File(localUserProfilePicturePath)
        : null;
  }

  /// get bytes of the user's current profile avatar
  static Future<Uint8List> getLocalUserProfileAvatarBytes() async {
    final File? userProfileFile = await getLocalUserProfileFile();
    return userProfileFile==null
        ? Uint8List.fromList(<int>[])
        : userProfileFile.readAsBytesSync();
  }
}

class ProfileSyncGlobals {
  /// boolean describing if the user's current profile avatar should be updated with its remote counter-part
  static bool updateUserProfileAvatar = true;

  /// bytes of the user's current profile avatar
  static Uint8List? userProfileAvatarBytes;
}

