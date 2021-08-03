import 'package:flutter/material.dart';
import 'package:jobee/screens/screen06_more_screens/6.0_settings_screen.dart' show SettingsScreen;
import 'package:jobee/screens/screen06_more_screens/6.1_help_screen.dart' show HelpScreen;
import 'package:jobee/screens/widgets/logout.dart' show handleLogout;
import 'package:jobee/screens/widgets/custom_material_widgets/popup_menu/popup_menu.dart';
import 'package:jobee/services/service01_database/aux_app_user_data.dart' show AppUserData;
import 'package:jobee/models/profile.dart' show Profile;
import 'package:jobee/screens/screen05_profile/aux_profile_avatar.dart' show ProfileAvatar;
import 'package:jobee/screens/screen05_profile/aux_profile_detailed_screen_body.dart' show ProfileDetailedScreenBody;
import 'package:jobee/screens/widgets/jobee/logo.dart' show Logo;
import 'package:jobee/screens/widgets/jobee/drawer.dart' show HomeDrawer;
import 'package:jobee/services/service01_database/1.0_database.dart' show DatabaseService;
import 'package:jobee/screens/theme/jobee_theme_data.dart' show JobeeThemeData;
import 'package:provider/provider.dart' show Provider, StreamProvider;
import 'package:jobee/screens/widgets/buttons/app_bar_button.dart' show appBarButton;
import 'package:jobee/screens/widgets/navigation_bar_generator.dart' show bottomNavigationBarGenerator;

import 'aux_home_screen_body.dart' show HomeScreenBody;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomNavigationCurrentIndex = 0;

  // Out-callable setState function
  void updateWidgetState() {
    if (this.mounted) setState(() {});
  }

  // BUILD
  @override
  Widget build(BuildContext context) {
    // database service - app user data
    final AppUserData appUserData = Provider.of<AppUserData>(context);

    // - BOTTOM NAVIGATION BAR WIDGETS
    const Widget homeWidget = HomeScreenBody(page: 'Page 1: Home (client posts for services based on location VS service posts for clients based on location)');
    const Widget serviceWidget = HomeScreenBody(page: 'Page 2: Service (create, Icons.add_circle_outlined VS search, Icons.search_rounded)');
    final Widget profileWidget = ProfileDetailedScreenBody(appUserData: appUserData, hasLogoutButton: false, heroTag: 'homeAvatar');

    final List<Widget> bottomNavigationWidgetList = <Widget>[homeWidget, serviceWidget, profileWidget];

    // TODO: unify all profile avatar widgets

    // else, return all
    return StreamProvider<List<Profile>>.value(
      initialData: const <Profile>[],
      value: DatabaseService.profiles,
      // - THEME OF SCAFFOLD
      child: Scaffold(
        //drawerEnableOpenDragGesture: true,
        onDrawerChanged: (bool drawerChanged) {
          // on drawer changed, update UI
          setState(() {});
        },
        drawer: const HomeDrawer(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return appBarButton(context: context, iconData: Icons.menu, onClicked: () {
                Scaffold.of(context).openDrawer();
              });
            },
          ),
          title: Logo(updateWidgetStateCallback: this.updateWidgetState, defaultLogoColor: Theme.of(context).colorScheme.onPrimary),
          actions: <Widget>[
            appBarButton(context: context, iconData: Icons.notifications_none, onClicked: () {
              // TODO: show notifications
            }),
            appBarButton(context: context, iconData: Icons.search_rounded, onClicked: () {
              // TODO: search through jobs (not job types)
            }),
            CustomPopupMenuButton<int>(
              color: Theme.of(context).colorScheme.primary,
              onSelected: (int item) => onSelected(context, item),
              itemBuilder: (BuildContext context) => [
                const CustomPopupMenuItem<int>(
                  value: 0,
                  child: Text('Settings'),
                ),
                const CustomPopupMenuItem<int>(
                  value: 1,
                  child: Text('Help'),
                ),
                const CustomPopupMenuDivider(),
                CustomPopupMenuItem<int>(
                  value: 2,
                  child: Row(
                    children: const <Widget>[
                      Icon(Icons.logout),
                      SizedBox(width: 8),
                      Text("Sign Out"),
                    ],
                  ),
                ),
              ],
              icon: InkWell(
                splashColor: JobeeThemeData.darkSplashColor,
                highlightColor: JobeeThemeData.darkHighlightColor,
                child: const Icon(Icons.more_horiz),
              ),
            ),
          ],
        ),
        body: IndexedStack(
          index: _bottomNavigationCurrentIndex,
          children: bottomNavigationWidgetList,
        ),
        bottomNavigationBar: bottomNavigationBarGenerator(
          context: context,
          onTap: (int newIndex) => setState(() => _bottomNavigationCurrentIndex = newIndex),
          bottomNavigationCurrentIndex: _bottomNavigationCurrentIndex,
          inactiveIconList: <Widget>[
            const Icon(Icons.home_outlined),
            const Icon(Icons.work_outline),
            //Icon(Icons.people_alt_outlined),
            SizedBox(
              width: 24.0,
              height: 24.0,
              child: AbsorbPointer(
                child: ProfileAvatar(
                  appUserData: appUserData,
                  borderColor: JobeeThemeData.lightInactiveItemColor,
                  borderWidth: 2.0,
                  avatarTextFontSize: 9.0,
                ),
              ),
            ),
          ],
          activeIconList: <Widget>[
            const Icon(Icons.home),
            const Icon(Icons.work),
            //Icon(Icons.people_alt),
            SizedBox(
              width: 24.0,
              height: 24.0,
              child: AbsorbPointer(
                child: ProfileAvatar(
                  appUserData: appUserData,
                  borderColor: Theme.of(context).colorScheme.primary,
                  borderWidth: 2.0,
                  avatarTextFontSize: 9.0,
                ),
              ),
            ),
          ],
          labelList: <String>[
            'Home',
            'Services',
            //'Contacts',
            'Profile',
          ],
          nItems: 3,
          inactiveColor: JobeeThemeData.lightInactiveItemColor,
          activeColor: Theme.of(context).colorScheme.primary,
          navBarType: 1,
        ),
      ),
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context).push( MaterialPageRoute<dynamic>(builder: (BuildContext context) => const SettingsScreen()) );
        break;
      case 1:
        Navigator.of(context).push( MaterialPageRoute<dynamic>(builder: (BuildContext context) => const HelpScreen()) );
        break;
      case 2:
        handleLogout(context);
        break;
      default:
        break;
    }
  }

}