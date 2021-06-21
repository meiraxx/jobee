import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobee/models/app_user.dart';
import 'package:jobee/services/auth.dart';
import 'package:jobee/services/image_upload.dart';
import 'package:jobee/shared/constants.dart';
import 'package:jobee/shared/loading.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  final AppUserData? appUserData;

  const ProfileScreen({Key? key, required this.appUserData}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState(appUserData: appUserData);
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AppUserData? appUserData;
  AppUser? appUser;

  _ProfileScreenState({required this.appUserData}) : super();

  int jobeeLevel = 0;
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    appUser = Provider.of<AppUser?>(context);
    if (appUser == null) {
      // this condition is reached in case of logout
      return Loading();
    }

    return Scaffold(
      appBar: AppBar(
        leading: appBarButton(iconData: Icons.arrow_back, color: Theme.of(context).colorScheme.onBackground, onPressedFunction: () {
          Navigator.pop(context);
        }, splashColor: appbarDefaultButtonSplashColor,
        tooltip: "Back"),
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.black
          ),
        ),
        //titleSpacing: 8.0,
        centerTitle: false,
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
                    backgroundColor: lightPaletteColors["crispYellow"],
                    radius: 40.0,
                    child: Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: (_imageFile != null)
                            ? GestureDetector(
                          onTap: () async {
                            _imageFile = await getImage();
                            setState( (){} ); // update image
                          },
                          child: ClipOval(
                              child: Image.file(
                                _imageFile!,
                                fit: BoxFit.cover,
                              )
                          ),
                        )
                            : IconButton(
                          icon: Icon(
                              Icons.upload_rounded,
                              color: Colors.white,
                              size: 40.0
                          ),
                          onPressed: () async {
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
                      color: lightPaletteColors["crispYellow"]!,
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
                      appUserData!.name!,
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
              SizedBox(height: 4.0),
              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 4.0),
                    Icon(
                      Icons.email,
                      color: Colors.black87,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      appUserData!.email,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.black,
                height: 50.0,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Builder(builder: (BuildContext context) {
                  return ElevatedButton(
                    style: orangeElevatedButtonStyle,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 2.0),
                        Text(
                          'Logout',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    onPressed: () async {
                      await AuthService.signOut(context: context);
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  );
                }),
              )
            ],
          ),
        ),
      ),
      //bottomNavigationBar: bottomNavigationBar,
    );
  }
}
