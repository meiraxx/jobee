import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
//import 'package:jobee/screens/theme/navigation.dart' show slideFromLeftNavigatorPush;
import 'package:jobee/services/service01_database/aux_app_user_data.dart' show AppUserData;
import 'package:jobee/screens/screen05_profile/aux_profile_summarized.dart' show ProfileSummarized;
import 'package:jobee/screens/screen07_jobee_services/7.0_jobee_service_list.dart'
    show JobeeServiceList;
import 'package:jobee/screens/widgets/jobee/logo.dart' show Logo;
import 'package:jobee/screens/widgets/buttons/app_bar_button.dart' show appBarButton;
import 'package:provider/provider.dart' show Provider;

class HomeDrawer extends StatefulWidget {
  final void Function()? goToProfileCallback;

  const HomeDrawer({Key? key, this.goToProfileCallback}) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  final double _drawerMenuWidthRatio = 0.739;

  void _showSettingsPanel(BuildContext context) {
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
        child: Container(),
      );
    });
  }

  // Out-callable setState function
  void updateWidgetState() {
    if (this.mounted) setState(() {});
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
                    child: Logo(updateWidgetStateCallback: this.updateWidgetState, defaultLogoColor: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
            // - SUMMARIZED PROFILE
            ProfileSummarized(appUserData: appUserData, goToProfileCallback: widget.goToProfileCallback),
            const Divider(height: 0.0),
            const Divider(height: 0.0),
            // - SERVICES
            appBarButton(context: context, text: "Services", iconData: Icons.pages_outlined, onClicked: () async {
              // push the service list page
              Navigator.push(context, CupertinoPageRoute<dynamic>(builder: (_) => const JobeeServiceList()));
              //await slideFromLeftNavigatorPush(context, const JobeeServiceList());
              // rather than popping the drawer menu, close it without pop AFTER the requested action has completed
              Scaffold.of(context).openEndDrawer();
            }),
            const Divider(height: 0.0),
            const Divider(height: 0.0),
            // - SETTINGS
            appBarButton(context: context, text: "Settings", iconData: Icons.settings_outlined, onClicked: () {
              // pop the drawer menu
              Navigator.pop(context);
              // show the settings panel widget
              _showSettingsPanel(context);
            }),
            const Divider(height: 0.0),
            const Divider(height: 0.0)
          ],
        ),
      ),
    );
  }
}

