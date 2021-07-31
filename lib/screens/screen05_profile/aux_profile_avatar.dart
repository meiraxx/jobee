import 'dart:async' show Timer;
import 'dart:io' show File;
import 'dart:typed_data' show Uint8List;

import 'package:firebase_storage/firebase_storage.dart' show UploadTask;
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:image_picker/image_picker.dart' show PickedFile;
import 'package:jobee/services/service01_database/aux_app_user_data.dart' show AppUserData;
import 'package:jobee/services/service03_storage/3.0_storage.dart' show StorageService;
import 'package:jobee/widgets/ink_splash/custom_icon_button_ink_splash.dart' show CustomIconButtonInkSplash;
import 'package:jobee/widgets/loaders/in_place_loader.dart' show InPlaceLoader;
import 'package:jobee/widgets/media_files.dart' show showImageSourceActionSheet;

import '5.0_profile_detailed.dart' show ProfileDetailedScreen;
import '5.2_profile_avatar_fullscreen.dart' show ProfileAvatarFullScreen;
import 'global_variables_profile.dart' show ProfileAsyncGlobals, ProfileSyncGlobals;

/// Class for the profile avatar shown inside an outer widget
class ProfileAvatar extends StatefulWidget {
  final AppUserData appUserData;
  final Color borderColor;
  final bool isHero;
  final bool isProfileScreenAvatar;
  final double avatarTextFontSize;

  const ProfileAvatar({Key? key, required this.appUserData, required this.borderColor,
    required this.isHero, this.isProfileScreenAvatar = false, this.avatarTextFontSize = 28.0}) : super(key: key);

  @override
  _ProfileAvatarState createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> with TickerProviderStateMixin {
  // TODO: use only one instance of ProfileAvatar everywhere (or practically everywhere)

  late StorageService? _storageService;
  final double _circleAvatarRadius = 40.0;
  bool _uploadingReDownloadingFlag = false;
  late Timer reloadTimer;

  // Auxiliary functions
  Future<void> _downloadAndUpdateProfileAvatar() async {
    // if ProfileSyncGlobals.updateUserProfileAvatar is false, we do nothing
    if (!ProfileSyncGlobals.updateUserProfileAvatar) return;

    // else ...
    // Turn off further downloads and updates
    ProfileSyncGlobals.updateUserProfileAvatar = false;

    // [1] Downloading image
    final File localFile = await ProfileAsyncGlobals.getLocalUserProfileAvatarFile(widget.appUserData.uid);
    // Download the image file and halt thread execution until we have a File object
    final File? downloadedFile = await StorageService.downloadUserFile(
      remoteFileRef: _storageService!.userDirRemoteRef!.child('remote-profile-picture.jpg'),
      localFile: localFile,
      localBytes: ProfileSyncGlobals.userProfileAvatarBytes!,
    );

    // after download attempt ...
    // Turn _uploadingReDownloadingFlag to false
    _uploadingReDownloadingFlag = false;

    // if the file was not downloaded
    if (downloadedFile==null) return;

    // else...
    // [2] Image downloaded
    // Update the global variable ProfileSyncGlobals.userProfileAvatarBytes to the recently downloaded file bytes
    ProfileSyncGlobals.userProfileAvatarBytes = downloadedFile.readAsBytesSync();
    // Turn ProfileSyncGlobals.updateUserProfileAvatar to false
    ProfileSyncGlobals.updateUserProfileAvatar = false;

    // Asynchronously update UI with new profile avatar
    if (this.mounted) setState(() {});
  }

  Future<void> _handleProfileAvatarUploadIntent() async {
    final PickedFile? pickedImageFile = await showImageSourceActionSheet(context);
    // [1] Uploading image
    final List<UploadTask>? userFileUploadTasks = await _storageService!.uploadUserFile(pickedFile: pickedImageFile, remoteFileName: 'remote-profile-picture.jpg');
    if (userFileUploadTasks == null) return;

    // else...
    // on upload start:
    // turn _uploadingReDownloadingFlag to true
    _uploadingReDownloadingFlag = true;

    // get both upload tasks (image and sha256)
    final UploadTask imageUploadTask = userFileUploadTasks[0];
    final UploadTask imageSHA256UploadTask = userFileUploadTasks[1];

    // when avatar sha256 upload is complete
    imageSHA256UploadTask.whenComplete(() {
      // [2] Image SHA256 uploaded
      // when avatar upload is complete
      imageUploadTask.whenComplete(() {
        // [3] Image downloaded
        // Force re-download and update UI
        ProfileSyncGlobals.updateUserProfileAvatar = true;
        if (this.mounted) setState(() {});
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize _storageService based on uid
    _storageService = StorageService(uid: widget.appUserData.uid);

    //debugPrint("Started timer");
    // each second, update const UI with changes (e.g., bottom navbar)
    reloadTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (this.mounted) setState(() {});
    });

    // TODO-MAYBE: instead, create listener to update ProfileSyncGlobals.updateUserProfileAvatar, when the stored image changes on the back-end
    // TODO-BackEnd-MAYBE: notify this listener when stored image changes
  }

  @override
  Widget build(BuildContext context) {
    // - WIDGETS
    Widget? defaultHeroChild;
    Widget? defaultProfileAvatarHero;
    Widget? heroChild;
    Widget? profileAvatarHero;

    // Download the profile avatar
    _downloadAndUpdateProfileAvatar();

    // check if image does not exist yet (empty if no avatar was sent to the server)
    final bool imageEmpty = listEquals( ProfileSyncGlobals.userProfileAvatarBytes, Uint8List.fromList(<int>[]) );
    if (imageEmpty) {
      defaultHeroChild = Material(
        color: Colors.transparent,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            "${widget.appUserData.firstName![0]}${widget.appUserData.lastName![0]}",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: widget.avatarTextFontSize,
              color: Colors.white,
            ),
          ),
        ),
      );
      defaultProfileAvatarHero = widget.isHero ? Hero(
        tag: 'profileAvatarHero',
        child: defaultHeroChild,
      ) : defaultHeroChild;
    } else {
      final Widget profileAvatarImage = SizedBox(
        width: 200, // circle avatar image width
        height: 200, // circle avatar image height
        child: Image.memory(
          ProfileSyncGlobals.userProfileAvatarBytes!,
          fit: BoxFit.cover,
        ),
      );

      // Avatar Clip-Oval
      heroChild = ClipOval(
        child: _uploadingReDownloadingFlag ? Stack(
          children: <Widget>[
            Positioned(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
                child: profileAvatarImage,
              ),
            ),
            const Positioned(
              child: InPlaceLoader(
                baseSize: Size(40.0, 40.0),
                padding: EdgeInsets.only(top: 20.0, left: 20.0),
              ),
            ),
          ],
        ) : profileAvatarImage,
      );
      // Avatar
      profileAvatarHero = widget.isHero ? Hero(
        tag: 'profileAvatarHero',
        child: heroChild,
      ) : heroChild;
    }

    return Container(
      decoration: BoxDecoration(
        color: widget.borderColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.borderColor,
          width: 3.0,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              radius: _circleAvatarRadius,
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: imageEmpty
                  ? GestureDetector(
                    onTap: () async {
                      // if no image was uploaded, the click on the profile avatar
                      // widget will assume the user wants to upload an image
                      _handleProfileAvatarUploadIntent();
                    },
                    child: defaultProfileAvatarHero,
                  )
                  : GestureDetector(
                    onTap: () async {
                      // if we're in the profile view:
                      if (widget.isProfileScreenAvatar) {
                        // navigate to a widget with a full-screen image
                        Navigator.push(
                          context,
                          PageRouteBuilder<dynamic>(
                            pageBuilder: (BuildContext context, Animation<double> a, Animation<double> b) => ProfileAvatarFullScreen(profileAvatar: widget),
                            transitionDuration: const Duration(milliseconds: 500),
                          ),
                        );
                        return;
                      }

                      // else, we assume the user wants to navigate to the profile screen
                      Navigator.push(
                        context,
                        CupertinoPageRoute<dynamic>(builder: (BuildContext context) => ProfileDetailedScreen(appUserData: widget.appUserData)),
                      );
                    },
                    child: profileAvatarHero,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: _circleAvatarRadius + 17,
            left: _circleAvatarRadius + 17,
            child: Material(
              color: Colors.transparent,
              child: Ink(
                width: 23,
                height: 23,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  //color: const Color(0xFF128C7E), // Teal Green
                  //color: const Color(0xFF34B7F1), // Blue
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: InkResponse(
                  splashFactory: CustomIconButtonInkSplash.splashFactory,
                  overlayColor: MaterialStateProperty.all( Theme.of(context).colorScheme.primary ),
                  highlightColor: Theme.of(context).colorScheme.primary,
                  splashColor: Theme.of(context).colorScheme.primary,
                  customBorder: const CircleBorder(),
                  containedInkWell: true,
                  onTap: () async {
                    // handle click on the camera icon
                    _handleProfileAvatarUploadIntent();
                  },
                  child: const InkWell(
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    //debugPrint("Canceled timer");
    reloadTimer.cancel();
    super.dispose();
  }
}

