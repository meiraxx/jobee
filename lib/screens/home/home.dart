import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobee/models/app_user.dart';
import 'package:jobee/models/profile.dart';
import 'package:jobee/screens/profile/profile_screen.dart';
import 'package:jobee/services/database.dart';
import 'package:jobee/services/image_upload.dart';
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
  final List<Color> logoRandomColorList = [
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
    AppUser appUser = Provider.of<AppUser?>(context)!;
    AppUserData appUserData = Provider.of<AppUserData>(context);

    // - FUNCTIONS
    void logoInteractions(Color defaultLogoColor, int interaction, List<Color> logoColorList) {
      if (interaction == 1) {
        // - INTERACTION 1: toggle between logo's default and a random color

        setState(() {
          if (_currentLogoColor == defaultLogoColor) {
            _currentLogoColor = logoColorList[generateRandomInteger(0, logoColorList.length - 1)];
          } else {
            _currentLogoColor = defaultLogoColor;
          }
        });
      } else if (interaction == 2) {
        // - INTERACTION 2: toggle between logo's random colors
        setState(() {
          _currentLogoColor = logoColorList[generateRandomInteger(0, logoColorList.length - 1)];
        });
      } else if (interaction == 3) {
        // - INTERACTION 3: make the whole logo disappear!
        setState(() {
          if (_currentLogoColor == defaultLogoColor) {
            _currentLogoColor = Colors.transparent;
          } else {
            _currentLogoColor = defaultLogoColor;
          }
        });
      }
    }

    // - WIDGETS
    GestureDetector logoPlusText = GestureDetector(
      onTap: () {
        logoInteractions(Colors.black, 1, logoRandomColorList);
      },
      onDoubleTap: () {
        logoInteractions(Colors.black, 2, logoRandomColorList);
      },
      onHorizontalDragStart: (dragStartDetails) {
        logoInteractions(Colors.black, 3, logoRandomColorList);
      },
      child: Tooltip(
        message: 'jobee logo!',
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Image.asset(
                "images/bee-logo-07.png",
                semanticLabel: "Jobee logo",
                width: 32.0, // default icon width
                height: 32.0, // default icon height
                color: _currentLogoColor
            ),
            SizedBox(width: 4.0),
            Text(
              "jobee",
              style: GoogleFonts.museoModerno().copyWith(
                // COOL logo font families:
                // - MuseoModerno
                // - Srisakdi
                color: _currentLogoColor,
                fontSize: 18,
                fontWeight: FontWeight.w700
              ),
            ),
          ],
        ),
      ),
    );

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
        backgroundColor: paletteColors["cream"],
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
                  child: logoPlusText
                ),
                Divider(height: 0.0),
                Divider(height: 0.0),
                // - SUMMARIZED PROFILE
                SizedBox(height: 6.0),
                Center(
                  child: Container(
                    child: CircleAvatar(
                      backgroundColor: paletteColors["orange"],
                      radius: 40.0,
                      child: Center(
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: (_imageFile != null)
                          ? ClipOval(child: Image.file(_imageFile!))
                          : IconButton(
                            icon: Icon(
                                Icons.upload_rounded,
                                color: Colors.white,
                                size: 40.0
                            ),
                            onPressed: () async {
                              print("Hello?");
                              _imageFile = await getImage();
                              setState( (){} ); // update image
                            },
                          ),
                        ),
                      ),
                    ),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      border: new Border.all(
                        color: paletteColors["orange"]!,
                        width: 3.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6.0),
                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 4.0),
                      Text(
                        appUserData.name!,
                        style: GoogleFonts.pangolin().copyWith(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.0
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6.0),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    SizedBox(width: maxDrawerWidth/8),
                    Icon(
                      Icons.email,
                      color: Colors.black,
                      size: 14.0
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      appUserData.email,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.0),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    SizedBox(width: maxDrawerWidth/8),
                    Icon(
                        Icons.phone_android_rounded,
                        color: Colors.black,
                        size: 14.0
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      appUserData.phoneNumber!,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.0),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    SizedBox(width: maxDrawerWidth/8),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.circle,
                          color: Colors.redAccent[700],
                          size: 13.0,
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
                SizedBox(height: 12.0),
                Divider(height: 0.0),
                Divider(height: 0.0),
                // - ACCOUNT
                appBarButton(text: "Account", iconData: Icons.account_circle_outlined, color: Colors.black, onPressedFunction: () async {
                  // pop the drawer menu
                  Navigator.pop(context);
                  // push the profile page
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => ProfileScreen(appUserData: appUserData), fullscreenDialog: false));
                }, splashColor: appbarDefaultButtonSplashColor),
                Divider(height: 0.0),
                Divider(height: 0.0),
                // - SERVICES
                appBarButton(text: "Services", iconData: Icons.pages_outlined, color: Colors.black, onPressedFunction: () async {
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
          title: logoPlusText,
          backgroundColor: Colors.white,
          elevation: 1.0,
          actions: <Widget>[
            appBarButton(iconData: Icons.notifications_none, color: Colors.black, onPressedFunction: () async {
              // TODO : show notifications
            }, splashColor: appbarDefaultButtonSplashColor,
            tooltip: "Notifications"),
            appBarButton(iconData: Icons.search_rounded, color: Colors.black, onPressedFunction: () async {
              // TODO : search through jobs (not job types)
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
        activeColor: paletteColors["orange"]!),
      ),
    );
  }
}

