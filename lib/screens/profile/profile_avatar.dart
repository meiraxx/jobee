import 'dart:async' show Timer;
import 'dart:io' show File;
import 'dart:typed_data' show Uint8List;
import 'package:firebase_storage/firebase_storage.dart' show UploadTask;
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:image_picker/image_picker.dart' show PickedFile;
import 'package:jobee/models/app_user.dart' show AppUserData;
import 'package:jobee/screens/profile/profile_detailed.dart' show ProfileDetailedScreen;
import 'package:jobee/services/storage/storage.dart' show StorageService;
import 'package:jobee/shared/global_constants.dart' show appBarButton;
import 'package:jobee/shared/global_variables.dart' as global_variables;
import 'package:jobee/widgets/ink_splash/custom_icon_button_ink_splash.dart' show CustomIconButtonInkSplash;
import 'package:jobee/widgets/loaders.dart' show InPlaceLoader;
import 'package:jobee/widgets/media_files.dart' show showImageSourceActionSheet;

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
  late StorageService? _storageService;
  final double _circleAvatarRadius = 40.0;
  bool _uploadingReDownloadingFlag = false;

  // Auxiliary functions
  Future<void> _downloadAndUpdateProfileAvatar() async {
    // if global_variables.updateUserProfileAvatar is false, we do nothing
    if (!global_variables.updateUserProfileAvatar) return;

    // else ...
    // Turn off further downloads and updates
    global_variables.updateUserProfileAvatar = false;

    // [1] Downloading image
    // Download the image file and halt thread execution until we have a File object
    final File? downloadedFile = await StorageService.downloadUserFile(
      remoteFileRef: _storageService!.userDirRemoteRef!.child('remote-profile-picture.jpg'),
      localFileName: 'local-profile-picture.jpg',
      localBytes: global_variables.userProfileAvatarBytes,
    );
    // after download attempt ...
    // turn _uploadingReDownloadingFlag to false
    _uploadingReDownloadingFlag = false;

    // if the file was not downloaded
    if (downloadedFile==null) return;

    // else...
    // [2] Image downloaded
    // Set _profileAvatarBytes as the downloaded file's bytes
    final Uint8List _profileAvatarBytes = downloadedFile.readAsBytesSync();

    // Update the global variable global_variables.userProfileAvatarBytes to the recently downloaded file (_profileAvatarBytes)
    global_variables.userProfileAvatarBytes = _profileAvatarBytes;
    // turn global_variables.updateUserProfileAvatar to false
    global_variables.updateUserProfileAvatar = false;

    // Asynchronously update UI with new profile avatar
    if (this.mounted) setState(() {});
  }

  Future<void> _handleProfileAvatarUploadIntent(BuildContext context) async {
    final PickedFile? pickedImageFile = await showImageSourceActionSheet(context);
    // [1] Uploading image
    final List<UploadTask>? userFileUploadTasks = await _storageService!.uploadUserFile(context: context, pickedFile: pickedImageFile, remoteFileName: 'remote-profile-picture.jpg');
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
        global_variables.updateUserProfileAvatar = true;
        if (this.mounted) setState(() {});
      });
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

    // TODO-MAYBE: instead, create listener to update global_variables.updateUserProfileAvatar, when the stored image changes on the back-end
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

    // check if image changed
    final bool imageBytesChanged = !listEquals( global_variables.userProfileAvatarBytes, Uint8List.fromList(<int>[]) );

    // if (!File('local-profile-picture.jpg').existsSync()) {
    if (!imageBytesChanged) {
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
      // TODO: use Image.network for any platform
      final Widget profileAvatarImage = SizedBox(
        width: 200, // circle avatar image width
        height: 200, // circle avatar image height
        child: Image.memory(
          global_variables.userProfileAvatarBytes,
          fit: BoxFit.cover,
        ),
      );

      /*final Widget profileAvatarImage = SizedBox(
        width: 200, // circle avatar image width
        height: 200, // circle avatar image height
        child: Image.file(
          File('local-profile-picture.jpg'),
          fit: BoxFit.cover,
        ),
      );*/

      // Avatar Clip-Oval
      heroChild = ClipOval(
        child: _uploadingReDownloadingFlag ? Stack(
          children: <Widget>[
            Positioned(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
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
                  child: (!imageBytesChanged)
                  ? GestureDetector(
                    onTap: () async {
                      // if no image was uploaded, the click on the profile avatar
                      // widget will assume the user wants to upload an image
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
                    // handle click on the camera icon
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


/// Class for the full screen profile avatar
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
                        global_variables.userProfileAvatarBytes,
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

