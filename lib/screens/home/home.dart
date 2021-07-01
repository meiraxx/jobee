import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobee/models/app_user.dart';
import 'package:jobee/models/profile.dart';
import 'package:jobee/screens/profile/profile.dart';
import 'package:jobee/screens/screens-shared/logo.dart';
import 'package:jobee/services/database.dart';
import 'package:jobee/services/image_upload.dart';
import 'package:jobee/shared/loader.dart';
import 'package:jobee/utils/math_utils.dart';
import 'package:provider/provider.dart';
import 'package:jobee/shared/constants.dart';
import 'dart:io';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final double _drawerMenuWidthRatio = 0.739;
  final List<Color> _logoRandomColorList = [
    // - RGB
    Colors.red,
    Colors.green,
    Colors.blue,
    // - Others, ordered on material.io/design/color
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];
  File? _imageFile;
  int _bottomNavigationCurrentIndex = 0;
  Color _currentLogoColor = Colors.black;

  // BUILD
  @override
  Widget build(BuildContext context) {
    // - VARIABLES
    MediaQueryData queryData = MediaQuery.of(context);
    double maxDrawerWidth = queryData.size.width*_drawerMenuWidthRatio;

    // app user data
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


    void _showServicePanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: Container(),
        );
      });
    }

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
                        color: lightPaletteColors["crispYellow"]!,
                        width: 3.0,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: lightPaletteColors["crispYellow"],
                      radius: 40.0,
                      child: Center(
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: (_imageFile != null)
                          ? GestureDetector(
                            onTap: () async {
                              _imageFile = await getImage();
                              setState( (){} ); // update image
                            },
                            child: ClipOval(
                              child: Image.file(
                                _imageFile!,
                                fit: BoxFit.cover,
                              )
                            ),
                          )
                          : IconButton(
                            icon: Icon(
                              Icons.upload_rounded,
                              color: Colors.white,
                              size: 40.0
                            ),
                            onPressed: () async {
                              _imageFile = await getImage();
                              setState( (){} ); // update image
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
                                  appUserData.phoneCountryDialCode! + " " + appUserData.phoneNumber!,
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
                appBarButton(text: "Account", iconData: Icons.account_circle_outlined, color: Theme.of(context).colorScheme.onBackground, onPressedFunction: () async {
                  // pop the drawer menu
                  Navigator.pop(context);
                  // push the profile page
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => ProfileScreen(appUserData: appUserData), fullscreenDialog: false));
                }, splashColor: appbarDefaultButtonSplashColor),
                Divider(height: 0.0),
                Divider(height: 0.0),
                // - SERVICES
                appBarButton(text: "Services", iconData: Icons.pages_outlined, color: Theme.of(context).colorScheme.onBackground, onPressedFunction: () async {
                  // pop the drawer menu
                  Navigator.pop(context);
                  // show the service panel widget
                  _showServicePanel();
                }, splashColor: appbarDefaultButtonSplashColor),
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
                tooltip: "Menu",
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                splashRadius: Material.defaultSplashRadius - 5.0,
              );
            },
          ),
          title: Logo(),
          backgroundColor: Colors.white,
          elevation: 1.0,
          actions: <Widget>[
            appBarButton(iconData: Icons.notifications_none, color: Theme.of(context).colorScheme.onBackground, onPressedFunction: () async {
              // TODO: show notifications
            }, splashColor: appbarDefaultButtonSplashColor,
            tooltip: "Notifications"),
            appBarButton(iconData: Icons.search_rounded, color: Theme.of(context).colorScheme.onBackground, onPressedFunction: () async {
              // TODO: search through jobs (not job types)
            }, splashColor: appbarDefaultButtonSplashColor,
            tooltip: "Search"),
          ],
        ),
        body: Container(
          child: Container(
            // TODO: HOME BODY
          ),
        ),
        bottomNavigationBar: bottomNavigationBarGenerator(context: context, onTap: (int newIndex) {
          setState(() {
            _bottomNavigationCurrentIndex = newIndex;
          });
        }, bottomNavigationCurrentIndex: _bottomNavigationCurrentIndex,
        iconDataList: [
          Icons.home,
          Icons.person,
          Icons.chat
        ],
        activeColor: lightPaletteColors["crispYellow"]!),
      ),
    );
  }
}

