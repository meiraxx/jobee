import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:jobee/models/app_user.dart' show AppUserData;
import 'package:jobee/screens/profile/profile_detailed.dart' show ProfileDetailedScreen;
import 'package:jobee/screens/profile/profile_summarized.dart' show ProfileSummarized;
import 'package:jobee/screens/screens-shared/logo.dart' show Logo;
import 'package:jobee/shared/global_constants.dart' show appBarButton;
import 'package:provider/provider.dart' show Provider;
import 'loaders.dart' show TextLoader;

class CustomDrawer extends StatefulWidget {

  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final double _drawerMenuWidthRatio = 0.739;

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
      color: Theme.of(context).colorScheme.primary,
      width: maxDrawerWidth,
      child: Drawer(
        semanticLabel: "Menu",
        child: Column(
          //padding: const EdgeInsets.all(0.0),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // - LOGO BAR
            Stack(
              children: [
                Positioned(
                  child: Container(
                    height: 80.0,
                    padding: const EdgeInsets.fromLTRB(8.0, 12.0*3, 8.0, 12.0),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Positioned(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8.0, 12.0*3, 8.0, 12.0),
                    child: Logo(),
                  ),
                ),
              ],
            ),
            //Divider(height: 0.0),
            //Divider(height: 0.0),
            // - SUMMARIZED PROFILE
            ProfileSummarized(appUserData: appUserData),
            Divider(height: 0.0),
            Divider(height: 0.0),
            // - ACCOUNT
            appBarButton(context: context, text: "View profile", iconData: Icons.account_circle_outlined, onPressedFunction: () async {
              // pop the drawer menu
              Navigator.pop(context);
              // push the profile page
              Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => ProfileDetailedScreen(appUserData: appUserData), fullscreenDialog: false));
            }),
            Divider(height: 0.0),
            Divider(height: 0.0),
            // - SERVICES
            appBarButton(context: context, text: "Services", iconData: Icons.pages_outlined, onPressedFunction: () async {
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
}

