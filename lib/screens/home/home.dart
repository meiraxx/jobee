import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobee/models/app_user.dart';
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
  final double drawerMenuWidthRatio = 0.739;
  AppUser? appUser;

  // SOME WIDGETS
  // COOL logo font families:
  // - MuseoModerno
  // - Srisakdi
  final Wrap logoWrap = Wrap(
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      Image.asset(
        "images/bee-logo-07.png",
        semanticLabel: "Jobee logo",
        width: 32.0, // default icon width
        height: 32.0, // default icon height
      ),
      SizedBox(width: 4.0),
      Text(
        "jobee",
          style: GoogleFonts.museoModerno().copyWith(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700
          ),
      ),
    ],
  );

  // BUILD
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double maxDrawerWidth = queryData.size.width*drawerMenuWidthRatio;
    appUser = Provider.of<AppUser?>(context);
    AppUserData appUserData = Provider.of<AppUserData>(context);

    print(appUserData.email);
    print(appUserData.name);
    print(appUserData.uid);

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
        drawer: Drawer(
          semanticLabel: "Menu",
          child: ListView(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
                child: logoWrap
              ),
              Divider(height: 0.0),
              Divider(height: 0.0),
              appBarButton(text: "Profile", iconData: Icons.person, color: Colors.black, onPressedFunction: () async {
                // pop the drawer menu
                Navigator.pop(context);
                // push the profile page
                Navigator.pushNamed(context, "/profile");
              }, splashColor: appbarDefaultButtonSplashColor),
              Divider(height: 0.0),
              Divider(height: 0.0),
              appBarButton(text: "Services", iconData: Icons.pages_outlined, color: Colors.black, onPressedFunction: () async {
                // pop the drawer menu
                Navigator.pop(context);
                // show the service panel widget
                _showServicePanel();
              }, splashColor: appbarDefaultButtonSplashColor),
              Divider(height: 0.0),
              Divider(height: 0.0),
              Container(
                color: Colors.blue,
                height: 30.0,
              ),
              SizedBox(height: 300.0),
              Card(
                elevation: 2.0,
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(height: 6.0),
                    Container(
                      child: CircleAvatar(
                        backgroundColor: paletteColors["orange"],
                        radius: 17.0,
                        child: Text(
                          "AH",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600
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
                    SizedBox(height: 4.0),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.account_circle,
                          color: Colors.black,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          appUserData.name!,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.email,
                          color: Colors.black,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          appUser!.email,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.0)
                  ],
                ),
              )
            ],
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
          title: logoWrap,
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
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}

