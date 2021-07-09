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
import 'package:jobee/widgets/drawer.dart';
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
  int _bottomNavigationCurrentIndex = 0;

  // Auxiliary functions
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
    // database service - app user data
    AppUserData? appUserData = Provider.of<AppUserData?>(context);
    if (appUserData==null) return TextLoader(text: "Fetching user data...");


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
        drawer: CustomDrawer(),
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
            appBarButton(context: context, iconData: Icons.notifications_none, onPressedFunction: () async {
              // TODO: show notifications
            }),
            appBarButton(context: context, iconData: Icons.search_rounded, onPressedFunction: () async {
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

