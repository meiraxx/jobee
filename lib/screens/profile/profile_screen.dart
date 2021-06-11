import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobee/models/app_user.dart';
import 'package:jobee/shared/constants.dart';
import 'package:jobee/shared/loading.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppUser? appUser;
  int jobeeLevel = 0;
  final Map<String, Color> a = {
    "AppBarBackground": Colors.grey[50]!,
    "ScaffoldBackground": paletteColors["cream"]!,
    "ProfileFieldText": Colors.grey[850]!,
    "ProfileValueText": paletteColors["brown"]!,
    "CircleAvatarBorder": paletteColors["brown"]!,
    "MainDivider": Colors.grey[850]!,
  };

  @override
  Widget build(BuildContext context) {
    appUser = Provider.of<AppUser?>(context);
    if (appUser == null) {
      return Loading();
    }

    return Scaffold(
      backgroundColor: paletteColors["cream"],
      appBar: AppBar(
        leading: appBarButton(iconData: Icons.arrow_back, color: Colors.black, onPressedFunction: () {
          Navigator.pop(context);
        }),
        title: Text(
          "Jobee Profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[50],
        elevation: 1.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  child: CircleAvatar(
                    backgroundColor: paletteColors["orange"],
                    radius: 40.0,
                    child: Text(
                      "AH",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    border: new Border.all(
                      color: paletteColors["brown"]!,
                      width: 4.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4.0),
              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.email,
                      color: Colors.grey[850],
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      appUser!.email,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 4.0),
              Center(
                child: Builder(builder: (BuildContext context) {
                  return ElevatedButton(
                    style: orangeElevatedButtonStyle,
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, "/");
                    },
                  );
                })
              ),
              Divider(
                color: Colors.black,
                height: 50.0,
              ),
              Text(
                'NAME',
                style: TextStyle(
                  color: Colors.grey[850],
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'name-placeholder',
                style: TextStyle(
                  color: paletteColors["brown"],
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                'CITY',
                style: TextStyle(
                  color: Colors.grey[850],
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'city-placeholder, country-placeholder',
                style: TextStyle(
                  color: paletteColors["brown"],
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                'CURRENT JOBEE LEVEL',
                style: TextStyle(
                  color: Colors.grey[850],
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                '$jobeeLevel',
                style: TextStyle(
                  color: paletteColors["brown"],
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
