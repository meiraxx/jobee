import 'package:flutter/material.dart';
import 'package:jobee/models/app_user.dart' show AppUserData;
import 'package:jobee/models/profile.dart' show Profile;
import 'package:jobee/screens/profile/profile_avatar.dart';
import 'package:jobee/screens/screens-shared/logo.dart' show Logo;
import 'package:jobee/widgets/drawer.dart' show CustomDrawer;
import 'package:jobee/services/database.dart' show DatabaseService;
import 'package:jobee/theme/jobee_theme_data.dart' show JobeeThemeData;
import 'package:jobee/widgets/loaders.dart' show TextLoader;
import 'package:provider/provider.dart' show Provider, StreamProvider;
import 'package:jobee/shared/global_constants.dart' show appBarButton, iconSplashRadius;
import 'package:jobee/widgets/navigation_bar/navigation_bar_generator.dart' show bottomNavigationBarGenerator;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _bottomNavigationCurrentIndex = 0;
  Widget? _bottomNavigationCurrentItem;

  // BUILD
  @override
  Widget build(BuildContext context) {
    // database service - app user data
    AppUserData? appUserData = Provider.of<AppUserData?>(context);
    if (appUserData==null) return TextLoader(text: "Fetching user data...");


    // - BOTTOM NAVIGATION BAR LOGIC
    switch (_bottomNavigationCurrentIndex) {
      case 0:
        _bottomNavigationCurrentItem = HomeBody(page: 'Page 1: Home (client posts for services based on location VS service posts for clients based on location)');
        break;
      case 1:
        _bottomNavigationCurrentItem = HomeBody(page: 'Page 2: Service (create, Icons.add_circle_outlined VS search, Icons.search_rounded)');
        break;
      case 2:
        _bottomNavigationCurrentItem = HomeBody(page: 'Page 3: Profile');
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
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu),
                splashRadius: iconSplashRadius,
                splashColor: JobeeThemeData.darkSplashColor,
                highlightColor: JobeeThemeData.darkHighlightColor,
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
            appBarButton(context: context, iconData: Icons.more_vert, onPressedFunction: () async {
              // TODO: search through jobs (not job types)
            }),
          ],
        ),
        body: Container(
          child: _bottomNavigationCurrentItem,
        ),
        bottomNavigationBar: bottomNavigationBarGenerator(
          context: context,
          onTap: (int newIndex) {
            setState(() {
              _bottomNavigationCurrentIndex = newIndex;
            });
          },
          bottomNavigationCurrentIndex: _bottomNavigationCurrentIndex,
          inactiveIconList: [
            Icon(Icons.home_outlined),
            Icon(Icons.work_outline),
            //Icon(Icons.people_alt_outlined),
            Container(
              width: 24.0,
              height: 24.0,
              child: AbsorbPointer(
                child: ProfileAvatar(
                  appUserData: appUserData,
                  borderColor: JobeeThemeData.lightInactiveItemColor,
                  isHero: false,
                  avatarTextFontSize: 9.0,
                ),
              ),
            ),
          ],
          activeIconList: [
            Icon(Icons.home),
            Icon(Icons.work),
            //Icon(Icons.people_alt),
            Container(
              width: 24.0,
              height: 24.0,
              child: AbsorbPointer(
                child: ProfileAvatar(
                  appUserData: appUserData,
                  borderColor: Theme.of(context).colorScheme.primary,
                  isHero: false,
                  avatarTextFontSize: 9.0,
                ),
              ),
            ),
          ],
          labelList: [
            'Home',
            'Services',
            //'Contacts',
            'Profile',
          ],
          nItems: 3,
          inactiveColor: JobeeThemeData.lightInactiveItemColor,
        ),
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  final String page;

  const HomeBody({Key? key, required this.page}) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        widget.page,
      ),
    );
  }
}