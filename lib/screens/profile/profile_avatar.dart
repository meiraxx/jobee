import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jobee/models/app_user.dart' show AppUserData;
import 'package:jobee/services/storage/storage.dart' show StorageService;
import 'package:firebase_storage/firebase_storage.dart' show UploadTask;
import 'package:jobee/widgets/media_files.dart' show showImageSourceActionSheet;
import 'package:image_picker/image_picker.dart' show PickedFile;
import 'dart:io' show File;
import 'dart:typed_data' show Uint8List;
import 'package:jobee/shared/globals.dart' as globals;

class ProfileAvatar extends StatefulWidget {
  final AppUserData appUserData;

  const ProfileAvatar({Key? key, required this.appUserData}) : super(key: key);

  @override
  _ProfileAvatarState createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  Uint8List? _profileAvatarBytes;
  bool _forceProfileAvatarDownloadAndUpdate = true;
  StorageService? _storageService;

  // Auxiliary functions
  Future<void> _downloadAndUpdateProfileAvatar() async {
    // if the _forceProfileAvatarDownloadAndUpdate is false, we do nothing
    if (!_forceProfileAvatarDownloadAndUpdate) return null;

    // else ...

    // Turn off further downloads and updates
    _forceProfileAvatarDownloadAndUpdate = false;
    // Download the image file and halt thread execution until we have a File object
    File? downloadedFile = await StorageService.downloadFile(
      remoteFileRef: _storageService!.userDirRemoteRef!.child('remote-profile-picture.jpg'),
      localFileName: 'local-profile-picture.jpg',
    );

    // if the user hasn't yet uploaded a picture, simply return null
    if (downloadedFile==null) return null;

    // else...
    // Set _profileAvatarBytes as the downloaded file's bytes
    _profileAvatarBytes = downloadedFile.readAsBytesSync();

    // Asynchronously update UI with new profile avatar only if the
    // downloaded profile avatar is different than the already stored
    // one !listEquals(_profileAvatarBytes, globals.userProfileAvatarBytes)
    if (this.mounted && !listEquals(_profileAvatarBytes, globals.userProfileAvatarBytes)) {
      setState(() {});
    }

    // Update the global variable globals.userProfileAvatarBytes to the recently downloaded file (_profileAvatarBytes)
    globals.userProfileAvatarBytes = _profileAvatarBytes;
  }

  Future<void> _handleProfileAvatarClick(BuildContext context) async {
    PickedFile? pickedImageFile = await showImageSourceActionSheet(context);
    UploadTask? uploadTask = await _storageService!.uploadUserFile(context: context, pickedFile: pickedImageFile, remoteFileName: 'remote-profile-picture.jpg');
    if (uploadTask == null) return null;

    // when avatar upload is complete
    uploadTask.whenComplete(() {
      // Force re-download and update UI
      _forceProfileAvatarDownloadAndUpdate = true;
      if (this.mounted) setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize _storageService based on uid
    _storageService = StorageService(uid: widget.appUserData.uid);
    // Download the profile avatar
    //_downloadAndUpdateProfileAvatar();
  }

  @override
  Widget build(BuildContext context) {
    // Download the profile avatar

    _downloadAndUpdateProfileAvatar();
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 3.0,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        radius: 40.0,
        child: Center(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: (globals.userProfileAvatarBytes != null)
            ? GestureDetector(
              onTap: () async {
                _handleProfileAvatarClick(context);
              },
              child: ClipOval(
                child: Image.memory(
                  globals.userProfileAvatarBytes!,
                  fit: BoxFit.cover,
                ),
              ),
            )
            : IconButton(
              icon: Icon(
                Icons.add_a_photo_outlined,
                color: Colors.white,
                size: 40.0,
              ),
              onPressed: () async {
                _handleProfileAvatarClick(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
