import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:jobee/models/app_user.dart' show AppUserData;
import 'package:jobee/services/storage/storage.dart' show StorageService;
import 'package:firebase_storage/firebase_storage.dart' show UploadTask;
import 'package:jobee/shared/constants.dart' show appBarButton;
import 'package:jobee/widgets/media_files.dart' show showImageSourceActionSheet;
import 'package:image_picker/image_picker.dart' show PickedFile;
import 'dart:io' show File;
import 'dart:typed_data' show Uint8List;
import 'package:flutter/foundation.dart' show listEquals;
import 'package:jobee/shared/globals.dart' as globals;

class ProfileAvatar extends StatefulWidget {
  final AppUserData appUserData;

  const ProfileAvatar({Key? key, required this.appUserData}) : super(key: key);

  @override
  _ProfileAvatarState createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  bool _forceProfileAvatarDownloadAndUpdate = true;
  StorageService? _storageService;
  double _circleAvatarRadius = 40.0;

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
    // Set profileAvatarBytes as the downloaded file's bytes
    Uint8List? profileAvatarBytes = downloadedFile.readAsBytesSync();

    // Asynchronously update UI with new profile avatar only if the
    // downloaded profile avatar is different than the already stored
    // one !listEquals(profileAvatarBytes, globals.userProfileAvatarBytes)
    if (this.mounted && !listEquals(profileAvatarBytes, globals.userProfileAvatarBytes)) {
      setState(() {});
    }

    // Update the global variable globals.userProfileAvatarBytes to the recently downloaded file (profileAvatarBytes)
    globals.userProfileAvatarBytes = profileAvatarBytes;
  }

  Future<void> _handleProfileAvatarUploadIntent(BuildContext context) async {
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
  }

  @override
  Widget build(BuildContext context) {
    // Download the profile avatar

    _downloadAndUpdateProfileAvatar();
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 3.0,
        ),
      ),
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            radius: _circleAvatarRadius,
            child: Center(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: (globals.userProfileAvatarBytes == null)
                ? GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "JM",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 28.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onTap: () async {
                    // if no image was uploaded, the click on this widget will
                    // assume the user wants to upload an image
                    _handleProfileAvatarUploadIntent(context);
                  },
                )
                : GestureDetector(
                  child: ClipOval(
                    child: Image.memory(
                      globals.userProfileAvatarBytes!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  onTap: () async {
                    // navigate to a widget with a full-screen image
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (BuildContext context) => ProfileAvatarFullScreen(profileAvatar: widget), fullscreenDialog: false),
                    );
                    //_handleProfileAvatarUploadIntent(context);
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: _circleAvatarRadius + 17,
            left: _circleAvatarRadius + 17,
            child: GestureDetector(
              child: Container(
                width: 23,
                height: 23,
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 15,
                  color: Colors.white,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  //color: const Color(0xFF128C7E), // Teal Green
                  color: const Color(0xFF34B7F1), // Blue
                ),
              ),
              onTap: () async {
                _handleProfileAvatarUploadIntent(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileAvatarFullScreen extends StatefulWidget {
  final ProfileAvatar profileAvatar;

  const ProfileAvatarFullScreen({Key? key, required this.profileAvatar}) : super(key: key);

  @override
  _ProfileAvatarFullScreenState createState() => _ProfileAvatarFullScreenState();
}

class _ProfileAvatarFullScreenState extends State<ProfileAvatarFullScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: appBarButton(context: context, iconData: Icons.arrow_back, onPressedFunction: () {
          Navigator.pop(context);
        }, color: Colors.white),
        title: Text("Profile picture", style: TextStyle(color: Colors.white)),
        elevation: 0.0,
        actions: <Widget>[
          appBarButton(context: context, iconData: Icons.edit, onPressedFunction: () async {
            // TODO: call _handleProfileAvatarUploadIntent(context) here somehow
          }, color: Colors.white),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(color: Colors.black),
          ),
          AspectRatio(
            aspectRatio: 3 / 3,
            child: Image.memory(
              globals.userProfileAvatarBytes!,
              alignment: Alignment.center,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(color: Colors.black),
          ),
        ],
      ),
    );
  }
}

