import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobee/models/app_user.dart';
import 'package:jobee/screens/profile/profile.dart';
import 'package:jobee/screens/profile/profile_avatar.dart';
import 'package:jobee/screens/screens-shared/logo.dart';
import 'package:jobee/shared/constants.dart';
import 'package:provider/provider.dart';

import 'loaders.dart';

/*
class DrawerStateInfo with ChangeNotifier {
  ProfileAvatar? _currentProfileAvatar;
  ProfileAvatar? get currentProfileAvatar => _currentProfileAvatar;

  void setCurrentProfileAvatar(ProfileAvatar? profileAvatar) {
    _currentProfileAvatar = profileAvatar;
    notifyListeners();
  }

}*/

class CustomDrawer extends StatefulWidget {

  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final double _drawerMenuWidthRatio = 0.739;

  @override
  void initState() {
    super.initState();
  }

  void _showServicePanel(BuildContext context) {
    showModalBottomSheet(context: context, builder: (context) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
        child: Container(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double maxDrawerWidth = queryData.size.width*_drawerMenuWidthRatio;

    // database service - app user data
    AppUserData? appUserData = Provider.of<AppUserData?>(context);
    if (appUserData==null) return TextLoader(text: "Fetching user data...");

    return Container(
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
              child: ProfileAvatar(appUserData: appUserData),
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
              Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => ProfileScreen(appUserData: appUserData), fullscreenDialog: false));
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
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

