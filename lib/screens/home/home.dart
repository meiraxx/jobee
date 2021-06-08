import 'package:flutter/material.dart';
import 'package:jobee/models/profile.dart';
import 'package:jobee/services/database.dart';
import 'package:provider/provider.dart';
import 'package:jobee/shared/constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final double drawerMenuWidth = 0.739;
  final Color splashColor = paletteColors["brown"]!.withAlpha(0x1F);

  // SOME WIDGETS
  final Wrap logoWrap = Wrap(
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      Image.asset(
        "images/bee-logo-07.png",
        semanticLabel: "Cute bee logo",
        width: 32.0, // default icon width
        height: 32.0, // default icon height
      ),
      SizedBox(width: 4.0),
      Text(
        "Jobee",
        style: TextStyle(color: Colors.black),
      ),
    ],
  );

  // INIT STATE
  @override
  void initState() {
    super.initState();
  }

  // BUILD
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double statusBarHeight = queryData.padding.top;

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
          width: queryData.size.width*drawerMenuWidth,
          child: Drawer(
            semanticLabel: "Home drawer button",
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: kToolbarHeight + statusBarHeight),
                Divider(),
                appBarButton(text: "Profile", iconData: Icons.person, color: Colors.black, onPressedFunction: () async {
                  // pop the drawer menu
                  Navigator.pop(context);
                  // push the profile page
                  Navigator.pushNamed(context, "/profile");
                }, splashColor: splashColor),
                appBarButton(text: "Services", iconData: Icons.pages_outlined, color: Colors.black, onPressedFunction: () async {
                  // pop the drawer menu
                  Navigator.pop(context);
                  // show the service panel widget
                  _showServicePanel();
                }, splashColor: splashColor),
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
                tooltip: null,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                splashRadius: Material.defaultSplashRadius - 5.0,
              );
            },
          ),
          title: logoWrap,
          backgroundColor: Colors.white,
          elevation: 1.0,
          actions: <Widget>[
            appBarButton(text: "Search", iconData: Icons.search_rounded, color: Colors.black, onPressedFunction: () async {
              // TODO : search through jobs (not job types)
            }),
          ],
        ),
        body: Container(
          child: Container(
            // TODO: HOME BODY
          ),
        ),
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}

