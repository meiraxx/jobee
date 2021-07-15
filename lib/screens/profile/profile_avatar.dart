import 'dart:async' show Timer;
import 'dart:io' show File;
import 'dart:typed_data' show Uint8List;
import 'package:firebase_storage/firebase_storage.dart' show UploadTask;
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:image_picker/image_picker.dart' show PickedFile;
import 'package:jobee/models/app_user.dart' show AppUserData;
import 'package:jobee/screens/profile/profile_detailed.dart' show ProfileDetailedScreen;
import 'package:jobee/services/storage/storage.dart' show StorageService;
import 'package:jobee/shared/global_constants.dart' show appBarButton;
import 'package:jobee/shared/global_variables.dart' as global_variables;
import 'package:jobee/widgets/ink_splash/custom_icon_button_ink_splash.dart';
import 'package:jobee/widgets/media_files.dart' show showImageSourceActionSheet;

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
  bool _forceProfileAvatarDownloadAndUpdate = global_variables.updateUserProfileAvatar??true;
  late StorageService? _storageService;
  final double _circleAvatarRadius = 40.0;
  Uint8List? _profileAvatarBytes;

  // Auxiliary functions
  Future<Uint8List?> _downloadAndUpdateProfileAvatar() async {
    // if the _forceProfileAvatarDownloadAndUpdate is false, we do nothing
    if (!_forceProfileAvatarDownloadAndUpdate) return null;

    // else ...

    // Turn off further downloads and updates
    _forceProfileAvatarDownloadAndUpdate = false;
    // Download the image file and halt thread execution until we have a File object
    final File? downloadedFile = await StorageService.downloadFile(
      remoteFileRef: _storageService!.userDirRemoteRef!.child('remote-profile-picture.jpg'),
      localFileName: 'local-profile-picture.jpg',
    );

    // if the user hasn't yet uploaded a picture, simply return null
    if (downloadedFile==null) return null;

    // else...
    // Set _profileAvatarBytes as the downloaded file's bytes
    _profileAvatarBytes = downloadedFile.readAsBytesSync();

    // Update the global variable global_variables.userProfileAvatarBytes to the recently downloaded file (_profileAvatarBytes)
    global_variables.userProfileAvatarBytes = _profileAvatarBytes;
    global_variables.updateUserProfileAvatar = false;

    // Asynchronously update UI with new profile avatar only if the
    // downloaded profile avatar is different than the already stored
    // one !listEquals(_profileAvatarBytes, global_variables.userProfileAvatarBytes)
    if (this.mounted && !listEquals(_profileAvatarBytes, global_variables.userProfileAvatarBytes)) {
      setState(() {});
    }

    return _profileAvatarBytes;
  }

  Future<void> _handleProfileAvatarUploadIntent(BuildContext context) async {
    final PickedFile? pickedImageFile = await showImageSourceActionSheet(context);
    final UploadTask? uploadTask = await _storageService!.uploadUserFile(context: context, pickedFile: pickedImageFile, remoteFileName: 'remote-profile-picture.jpg');
    if (uploadTask == null) return;

    // when avatar upload is complete
    uploadTask.whenComplete(() {
      // Force re-download and update UI
      _forceProfileAvatarDownloadAndUpdate = true;
      global_variables.updateUserProfileAvatar = true;

      if (this.mounted) setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize _storageService based on uid
    _storageService = StorageService(uid: widget.appUserData.uid);

    // each second, update const UI with changes (e.g., bottom navbar)
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (this.mounted) setState(() {});
    });

    // (_forceProfileAvatarDownloadAndUpdate and global_variables.updateUserProfileAvatar)
    // TODO-MAYBE: instead, create listener to update the "update avatar" boolean values above, when the stored image changes on the back-end
    // TODO-BackEnd-MAYBE: notify this listener when stored image changes
  }

  @override
  Widget build(BuildContext context) {

    // - WIDGETS
    Widget? defaultHeroChild;
    Widget? defaultProfileAvatarHero;
    Widget? heroChild;
    Widget? profileAvatarHero;

    // TODO: check a FireStore bool to check if the user image needs to be downloaded and updated
    // Download the profile avatar
    _downloadAndUpdateProfileAvatar();

    if (global_variables.userProfileAvatarBytes == null) {
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
      // Avatar Clip-Oval
      heroChild = ClipOval(
        child: Image.memory(
          global_variables.userProfileAvatarBytes!,
          fit: BoxFit.cover,
        ),
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
                  child: (global_variables.userProfileAvatarBytes == null)
                  ? GestureDetector(
                    onTap: () async {
                      // if no image was uploaded, the click on this widget will
                      // assume the user wants to upload an image
                      _handleProfileAvatarUploadIntent(context);
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
                    _handleProfileAvatarUploadIntent(context);
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
}

class ProfileAvatarFullScreen extends StatefulWidget {
  final ProfileAvatar profileAvatar;

  const ProfileAvatarFullScreen({Key? key, required this.profileAvatar}) : super(key: key);

  @override
  _ProfileAvatarFullScreenState createState() => _ProfileAvatarFullScreenState();
}

class _ProfileAvatarFullScreenState extends State<ProfileAvatarFullScreen> with SingleTickerProviderStateMixin {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: appBarButton(context: context, iconData: Icons.arrow_back, onPressedFunction: () {
          Navigator.pop(context);
        }, color: Colors.white),
        title: const Text("Profile picture", style: TextStyle(color: Colors.white)),
        elevation: 0.0,
        actions: <Widget>[
          appBarButton(context: context, iconData: Icons.edit, onPressedFunction: () async {
            // TODO: call _handleProfileAvatarUploadIntent(context) here somehow
          }, color: Colors.white),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(color: Colors.black),
          ),
          Container(
            color: Colors.black,
            child: Hero(
              tag: 'profileAvatarHero',
              child: AspectRatio(
                aspectRatio: 3 / 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      image: MemoryImage(
                        global_variables.userProfileAvatarBytes!,
                      ),
                      fit: BoxFit.cover,
                    )
                  ),
                ),
              ),
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

