import 'dart:async' show Timer;
import 'dart:io' show File;
import 'dart:typed_data' show Uint8List;

import 'package:firebase_storage/firebase_storage.dart' show UploadTask;
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:image_picker/image_picker.dart' show PickedFile;
import 'package:jobee/screens/screen05_profile/5.0_profile_screen.dart';
import 'package:jobee/services/service01_database/aux_app_user_data.dart' show AppUserData;
import 'package:jobee/services/service03_storage/3.0_storage.dart' show storageService;
import 'package:jobee/screens/widgets/custom_material_widgets/ink_splash/custom_icon_button_ink_splash.dart' show CustomIconButtonInkSplash;
import 'package:jobee/screens/widgets/dialogs/confirmation_dialog.dart' show showConfirmationDialog;
import 'package:jobee/screens/widgets/loaders/in_place_loader.dart' show InPlaceLoader;
import 'package:jobee/screens/widgets/media_files.dart' show showProfileImageActionSheet;

import 'aux_profile_avatar_fullscreen.dart' show ProfileAvatarFullScreen;
import 'global_variables_profile.dart' show ProfileAsyncGlobals, ProfileSyncGlobals;

/// Class for the profile avatar shown inside an outer widget
class ProfileAvatar extends StatefulWidget {
  final AppUserData appUserData;
  final Color borderColor;
  final bool isHero;
  final String? heroTag;
  final void Function()? goToProfileCallback;

  final double borderWidth;
  final double avatarTextFontSize;

  const ProfileAvatar({Key? key, required this.appUserData, required this.borderColor,
    this.borderWidth = 3.0, this.isHero = false, this.goToProfileCallback,
    this.heroTag, this.avatarTextFontSize = 28.0}) : super(key: key);

  @override
  _ProfileAvatarState createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> with TickerProviderStateMixin {
  // TODO: use only one instance of ProfileAvatar everywhere (or practically everywhere)

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
    final File? downloadedFile = await storageService.downloadUserFile(
      remoteFileName: 'remote-profile-picture.jpg',
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

  Future<bool> _handleProfileAvatarUploadIntent() async {
    bool imageRemoved = false;

    final PickedFile? pickedImageFile = await showProfileImageActionSheet(context, onRemoveImageClicked: () async {
      final bool? removeImageChoice = await showConfirmationDialog(
        context,
        "Are you sure you want to remove your current profile image?",
        "No, do not remove my image",
        "Yes, I want to remove my image",
      );

      // if user chose to remove image, we remove it
      if (removeImageChoice == true) {
        imageRemoved = true;
        await ProfileAsyncGlobals.deleteLocalUserProfileAvatarFileAndBytes(widget.appUserData.uid);
        await storageService.deleteUserFile(remoteFileName: 'remote-profile-picture.jpg');
      }

      // close confirmation dialog
      Navigator.pop(context);
    });

    // if image was deleted, return true (requires update)
    if (imageRemoved == true) return true;
    // else, if no image was picked, return false (does not require update)
    if (pickedImageFile == null) return false;

    // [1] Uploading image
    final List<UploadTask> userFileUploadTasks = await storageService.uploadUserFile(pickedFile: pickedImageFile, remoteFileName: 'remote-profile-picture.jpg');

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

    return true;
  }

  @override
  void initState() {
    super.initState();
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
    // Download the profile avatar
    _downloadAndUpdateProfileAvatar();

    return Container(
      decoration: BoxDecoration(
        color: widget.borderColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.borderColor,
          width: widget.borderWidth,
        ),
      ),
      child: Stack(
        children: <Widget>[
          _buildCircleAvatar(),
          _buildAvatarActionButton(),
        ],
      ),
    );
  }

  Widget _buildCircleAvatar() {
    // check if image does not exist yet (empty if no avatar was sent to the server)
    final bool imageEmpty = listEquals( ProfileSyncGlobals.userProfileAvatarBytes, Uint8List.fromList(<int>[]) );

    return Positioned(
      child: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        radius: _circleAvatarRadius,
        child: Center(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: imageEmpty ? GestureDetector(
              onTap: () async {
                // if no image was uploaded, the click on the profile avatar
                // widget will assume the user wants to upload an image
                _handleProfileAvatarUploadIntent();
              },
              child: _buildDefaultProfileAvatarHero(),
            ) : buildProfileAvatarHero(),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarActionButton() => Positioned(
    top: _circleAvatarRadius + 17,
    left: _circleAvatarRadius + 17,
    child: Material(
      color: Colors.transparent,
      child: Ink(
        width: 23,
        height: 23,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(width: 2, color: Colors.white)
        ),
        child: Ink(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
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
  );

  Widget _buildDefaultProfileAvatarHero() {
    final Widget defaultProfileAvatarImage = Material(
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

    final Widget defaultHeroChild = _uploadingReDownloadingFlag ? ClipOval(
      child: Stack(
        children: <Widget>[
          Positioned(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
              child: defaultProfileAvatarImage,
            ),
          ),
          const Positioned(
            child: InPlaceLoader(
              baseSize: Size(40.0, 40.0),
              padding: EdgeInsets.only(top: 20.0, left: 20.0),
            ),
          ),
        ],
      ),
    ) : ClipOval(child: defaultProfileAvatarImage);

    return widget.isHero ? Hero(
      tag: widget.heroTag!,
      child: defaultHeroChild,
    ) : defaultHeroChild;
  }

  Widget buildProfileAvatarHero() {
    final Widget profileAvatarImage = Material(
      color: Colors.transparent,
      child: Ink.image(
        image: MemoryImage(ProfileSyncGlobals.userProfileAvatarBytes!),
        fit: BoxFit.cover,
        width: 200,
        height: 200,
        child: InkWell(
          onTap: () {
            // if the profile avatar is not hero
            if (!widget.isHero) {
              // call go-to-profile callback action (if provided) and return
              if (widget.goToProfileCallback != null) widget.goToProfileCallback!();
              return;
            }
            // navigate to a widget with a full-screen image
            Navigator.push(
              context,
              PageRouteBuilder<dynamic>(
                pageBuilder: (BuildContext context, Animation<double> a, Animation<double> b) => ProfileAvatarFullScreen(
                  profileAvatar: widget,
                  heroTag: widget.heroTag!,
                  handleProfileAvatarUploadIntent: _handleProfileAvatarUploadIntent,
                ),
                transitionDuration: const Duration(milliseconds: 500),
              ),
            );
          },
        ),
      ),
    );

    // Avatar Clip-Oval
    final Widget heroChild = _uploadingReDownloadingFlag ? ClipOval(
      child: Stack(
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
        ),
    ) : ClipOval(child: profileAvatarImage);

    return widget.isHero ? Hero(
      tag: widget.heroTag!,
      child: heroChild,
    ) : heroChild;
  }

  @override
  void dispose() {
    //debugPrint("Canceled timer");
    reloadTimer.cancel();
    super.dispose();
  }
}

