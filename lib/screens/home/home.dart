import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:jobee/models/app_user.dart' show AppUserData;
import 'package:jobee/models/profile.dart' show Profile;
import 'package:jobee/screens/profile/profile.dart' show ProfileScreen;
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
import 'package:jobee/screens/wrapper.dart' show Wrapper;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PickedFile? pickedImageFile;
  File? _userImageFile;
  Uint8List? _userImageBytes;

  final double _drawerMenuWidthRatio = 0.739;
  int _bottomNavigationCurrentIndex = 0;
  
  // resources state
  Future<File?>? _profilePictureDownloadFuture;
  bool _downloadProfilePictureFlag = true;
  bool _updateProfilePictureFlag = true;

  @override
  void initState() {
    super.initState();
    /*
    () async {
      await Future.delayed(Duration.zero);

      // storage service
      StorageService storageService = StorageService(uid: "uNFdGO667AZJY6kNmqdeFlzqveU2");

      // user profile picture download future
      _profilePictureDownloadFuture = StorageService.downloadFile(
        remoteRef: storageService.userDirRemoteRef!.child('remote-profile-picture.jpg'),
        localFileName: 'local-profile-picture.jpg',
      );
    }();
    */
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

    // storage service
    StorageService storageService = StorageService(uid: appUserData.uid);


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

    // AUXILIARY LAMBDAS
    void _showServicePanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: Container(),
        );
      });
    }
    
    void _downloadProfilePicture() {
      // download the image file and store a future
      _profilePictureDownloadFuture = StorageService.downloadFile(
        remoteFileRef: storageService.userDirRemoteRef!.child('remote-profile-picture.jpg'),
        localFileName: 'local-profile-picture.jpg',
      );
    }

    void _updateProfilePicture() {
      _profilePictureDownloadFuture!.then((File? downloadedFile) {
        if (downloadedFile==null) return null;
        // set _userImageFile as the downloaded file
        _userImageFile = downloadedFile;
        _userImageBytes = downloadedFile.readAsBytesSync();
        // update UI
        setState(() {
          // set _updateProfilePictureFlag to false, to turn off further updates
          _updateProfilePictureFlag = false;
          // set _downloadProfilePictureFlag to false, to turn off further downloads
          _downloadProfilePictureFlag = false;
        });
      });
    }

    void _handleProfilePictureClick() async {
      pickedImageFile = await showImageSourceActionSheet(context);
      UploadTask? uploadTask = await storageService.uploadUserFile(context: context, pickedFile: pickedImageFile, remoteFileName: 'remote-profile-picture.jpg');
      // when upload is complete
      uploadTask!.whenComplete(() {
        // Force re-download and update
        _downloadProfilePicture();
        _updateProfilePicture();
        // update UI
        setState( () {
          // stop new downloads
          _downloadProfilePictureFlag = false;
          // stop new updates
          _updateProfilePictureFlag = false;
        } );
      });
    }

    // if the flag _downloadProfilePictureFlag is set (default: true)
    if (_downloadProfilePictureFlag) {
      _downloadProfilePicture();
      // no need to perform a download multiple times, so turn off the flag
      _downloadProfilePictureFlag = false;
    }

    // if the flag _updateProfilePictureFlag is set (default: true)
    if (_updateProfilePictureFlag) _updateProfilePicture();

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
                  child: Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      border: new Border.all(
                        color: Theme.of(context).colorScheme.primaryVariant,
                        width: 3.0,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryVariant,
                      radius: 40.0,
                      child: Center(
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: (_userImageFile != null)
                          ? GestureDetector(
                            onTap: () async {
                              _handleProfilePictureClick();
                            },
                            child: ClipOval(
                              child: Image.memory(
                                _userImageBytes!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                          : IconButton(
                            icon: Icon(
                              Icons.upload_rounded,
                              color: Colors.white,
                              size: 40.0,
                            ),
                            onPressed: () async {
                              _handleProfilePictureClick();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
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
                  _showServicePanel();
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

