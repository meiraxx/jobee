import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:jobee/models/app_user.dart' show AppUserData;
import 'package:jobee/models/profile.dart' show Profile;
import 'package:jobee/screens/profile/profile.dart' show ProfileScreen;
import 'package:jobee/screens/profile/profile_avatar.dart';
import 'package:jobee/screens/screens-shared/logo.dart' show Logo;
import 'package:jobee/services/database.dart' show DatabaseService;
import 'package:jobee/services/storage/storage.dart' show StorageService;
import 'package:jobee/widgets/loaders.dart' show TextLoader;
import 'package:jobee/widgets/media_files.dart' show showImageSourceActionSheet;
import 'package:provider/provider.dart' show Provider, StreamProvider;
import 'package:jobee/shared/constants.dart' show appBarButton;
import 'package:jobee/widgets/navigation_bar.dart' show bottomNavigationBarGenerator;
import 'package:image_picker/image_picker.dart' show PickedFile;
import 'dart:io' show File;
import 'dart:typed_data' show Uint8List;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ProfileAvatar? _profileAvatar;
  /*
  Uint8List? _profileAvatarBytes;
  bool _forceProfileAvatarDownloadAndUpdate = true;
  */

  final double _drawerMenuWidthRatio = 0.739;
  int _bottomNavigationCurrentIndex = 0;

  /*
  // Auxiliary functions
  void _downloadAndUpdateProfileAvatar(StorageService storageService) async {
    // download the image file and halt thread execution until we have a File object
    File? downloadedFile = await StorageService.downloadFile(
      remoteFileRef: storageService.userDirRemoteRef!.child('remote-profile-picture.jpg'),
      localFileName: 'local-profile-picture.jpg',
    );

    // if the user hasn't yet uploaded a picture, simply return null
    if (downloadedFile==null) return null;

    // else...
    // set _userImageFile as the downloaded file
    _profileAvatarBytes = downloadedFile.readAsBytesSync();
    // asynchronously update UI with new profile avatar
    setState(() {});
  }

  void _handleProfileAvatarClick(BuildContext context, StorageService storageService) async {
    PickedFile? pickedImageFile = await showImageSourceActionSheet(context);
    UploadTask? uploadTask = await storageService.uploadUserFile(context: context, pickedFile: pickedImageFile, remoteFileName: 'remote-profile-picture.jpg');
    if (uploadTask == null) return null;

    // when upload is complete
    uploadTask.whenComplete(() {
      // Force re-download and update UI
      setState( () => _forceProfileAvatarDownloadAndUpdate = true );
    });
  }
  */

  void _showServicePanel(BuildContext context) {
    showModalBottomSheet(context: context, builder: (context) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
        child: Container(),
      );
    });
  }

  // BUILD
  @override
  Widget build(BuildContext context) {
    // - VARIABLES
    MediaQueryData queryData = MediaQuery.of(context);
    double maxDrawerWidth = queryData.size.width*_drawerMenuWidthRatio;

    // database service - app user data
    AppUserData? appUserData = Provider.of<AppUserData?>(context);
    if (appUserData==null) return TextLoader(text: "Fetching user data...");

    // Profile Avatar
    _profileAvatar = ProfileAvatar(appUserData: appUserData);

    /*
    // storage service
    StorageService storageService = StorageService(uid: appUserData.uid);
    // if the flag _forceProfileAvatarDownloadAndUpdate is set (default: true)
    if (_forceProfileAvatarDownloadAndUpdate) {
      _downloadAndUpdateProfileAvatar(storageService);
      // Turn off further downloads and updates
      _forceProfileAvatarDownloadAndUpdate = false;
    }*/

    // - BOTTOM NAVIGATION BAR LOGIC
    Widget bottomNavigationCurrentItem;
    switch (_bottomNavigationCurrentIndex) {
      case 0:
        bottomNavigationCurrentItem = Home();
        break;
      case 1:
        bottomNavigationCurrentItem = ProfileScreen(appUserData: appUserData);
        break;
      case 2:
        bottomNavigationCurrentItem = FlutterLogo();
        break;
    }

    // else, return all
    return StreamProvider<List<Profile>>.value(
      initialData: [],
      value: DatabaseService().profiles,
      // - THEME OF SCAFFOLD
      child: Scaffold(
        drawerEnableOpenDragGesture: true,
        drawer: Container(
          // based on experiments, 0.739 is the drawer menu default width
          // if intended, simply change the drawer_menu_width value
          width: maxDrawerWidth,
          child: Drawer(
            semanticLabel: "Menu",
            child: ListView(
              children: <Widget>[
                // - LOGO BAR
                Container(
                  padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
                  child: Logo(),
                ),
                Divider(height: 0.0),
                Divider(height: 0.0),
                // - SUMMARIZED PROFILE
                SizedBox(height: 6.0),
                Center(
                  child: _profileAvatar,
                ),
                SizedBox(height: 6.0),
                Center(
                  child: Text(
                    "${appUserData.firstName!} ${appUserData.lastName!}",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      fontSize: 20.0,
                    ),
                  ),
                ),
                SizedBox(height: 6.0),
                Card(
                  margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "@",
                              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                fontSize: 13.0,
                              ),
                            ),
                            SizedBox(width: 4.0),
                            Expanded(
                              child: Text(
                                appUserData.userName!,
                                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: Icon(
                                    Icons.phone_android_rounded,
                                    size: 13.0,
                                  ),
                                ),
                                SizedBox(width: 4.0),
                                Text(
                                  "(${appUserData.phoneCountryDialCode!}) ${appUserData.phoneNumber!}",
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 4.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Icon(
                                Icons.email,
                                size: 13.0,
                              ),
                            ),
                            SizedBox(width: 4.0),
                            Expanded(
                              child: Text(
                                appUserData.email,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 1.5),
                              child: Icon(
                                Icons.circle,
                                color: Colors.redAccent[700],
                                size: 13.0,
                              ),
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              "Busy",
                              style: TextStyle(
                                  color: Colors.redAccent[700],
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.0),
                Divider(height: 0.0),
                Divider(height: 0.0),
                // - ACCOUNT
                appBarButton(text: "Account", iconData: Icons.account_circle_outlined, context: context, onPressedFunction: () async {
                  // pop the drawer menu
                  Navigator.pop(context);
                  // push the profile page
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => ProfileScreen(appUserData: appUserData), fullscreenDialog: false));
                }),
                Divider(height: 0.0),
                Divider(height: 0.0),
                // - SERVICES
                appBarButton(text: "Services", iconData: Icons.pages_outlined, context: context, onPressedFunction: () async {
                  // pop the drawer menu
                  Navigator.pop(context);
                  // show the service panel widget
                  _showServicePanel(context);
                }),
                Divider(height: 0.0),
                Divider(height: 0.0)
              ],
            ),
          ),
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          title: Logo(),
          actions: <Widget>[
            appBarButton(iconData: Icons.notifications_none, onPressedFunction: () async {
              // TODO: show notifications
            }),
            appBarButton(iconData: Icons.search_rounded, onPressedFunction: () async {
              // TODO: search through jobs (not job types)
            }),
          ],
        ),
        body: Container(
          child: Container(
            // TODO: HOME BODY
            child: Container(),
          ),
        ),
        bottomNavigationBar: bottomNavigationBarGenerator(
          context: context,
          onTap: (int newIndex) {
            setState(() {
              _bottomNavigationCurrentIndex = newIndex;
            });
          },
          bottomNavigationCurrentIndex: _bottomNavigationCurrentIndex,
          inactiveIconDataList: [
            Icons.home_outlined,
            Icons.person_outline_sharp,
            Icons.chat_outlined,
          ],
          activeIconDataList: [
            Icons.home,
            Icons.person_sharp,
            Icons.chat,
          ],
        ),
      ),
    );
  }
}

