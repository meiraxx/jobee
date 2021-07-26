import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:jobee/models/app_user.dart' show AppUserData;
import 'package:jobee/screens/package5_profile/5.0_profile_detailed.dart' show ProfileDetailedScreen;
import 'package:jobee/screens/package5_profile/5.1_profile_summarized.dart' show ProfileSummarized;
import 'package:jobee/screens/package6_jobee_services/jobee_service_list.dart' show JobeeServiceList;
import 'package:jobee/widgets/jobee/logo.dart' show Logo;
import 'package:jobee/widgets/widget_utils/app_bar_button.dart' show appBarButton;
import 'package:provider/provider.dart' show Provider;

class CustomDrawer extends StatefulWidget {

  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final double _drawerMenuWidthRatio = 0.739;

  void _showServicePanel(BuildContext context) {
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
        child: Container(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    final double maxDrawerWidth = queryData.size.width*_drawerMenuWidthRatio;

    // database service - app user data
    final AppUserData appUserData = Provider.of<AppUserData>(context);

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
              children: <Widget>[
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
                    child: const Logo(),
                  ),
                ),
              ],
            ),
            //Divider(height: 0.0),
            //Divider(height: 0.0),
            // - SUMMARIZED PROFILE
            ProfileSummarized(appUserData: appUserData),
            const Divider(height: 0.0),
            const Divider(height: 0.0),
            // - ACCOUNT
            appBarButton(context: context, text: "View profile", iconData: Icons.account_circle_outlined, onPressedFunction: () async {
              // pop the drawer menu
              Navigator.pop(context);
              // push the profile page
              Navigator.push(context, CupertinoPageRoute<dynamic>(builder: (BuildContext context) => ProfileDetailedScreen(appUserData: appUserData)));
            }),
            const Divider(height: 0.0),
            const Divider(height: 0.0),
            // - SERVICES
            appBarButton(context: context, text: "Services", iconData: Icons.pages_outlined, onPressedFunction: () async {
              // pop the drawer menu
              Navigator.pop(context);
              // push the about us page
              Navigator.push(context, CupertinoPageRoute<dynamic>(builder: (BuildContext context) => const JobeeServiceList()));
            }),
            // - SERVICES
            appBarButton(context: context, text: "Settings", iconData: Icons.settings_outlined, onPressedFunction: () async {
              // pop the drawer menu
              Navigator.pop(context);
              // show the service panel widget
              _showServicePanel(context);
            }),
            const Divider(height: 0.0),
            const Divider(height: 0.0)
          ],
        ),
      ),
    );
  }
}

