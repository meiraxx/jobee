import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:jobee/models/app_user.dart' show AppUserData;
import 'package:jobee/screens/profile/profile_avatar.dart' show ProfileAvatar;
import 'package:jobee/services/auth.dart' show AuthService;
import 'package:jobee/shared/global_constants.dart' show appBarButton;

class ProfileDetailedBody extends StatefulWidget {
  final AppUserData? appUserData;
  final bool hasLogoutButton;
  final bool isHero;
  final bool isProfileScreenAvatar;

  const ProfileDetailedBody({Key? key, required this.appUserData, required this.hasLogoutButton, required this.isHero, required this.isProfileScreenAvatar}) : super(key: key);

  @override
  _ProfileDetailedBodyState createState() => _ProfileDetailedBodyState();
}

class _ProfileDetailedBodyState extends State<ProfileDetailedBody> {

  // Auxiliary functions
  /// Logout user when user confirms he wants to logout
  Future<void> _handleLogout(BuildContext context) async {
    final bool? choice = await _showBoolAlertDialog(context);
    if (choice == null || choice == false) return;

    // else, user wants to sign out
    await AuthService.signOut(context: context);
    Navigator.pushReplacementNamed(context, '/');
  }

  /// Show confirmation box for logout
  Future<bool?> _showBoolAlertDialog(BuildContext context) async {
    bool? choice;

    // show the dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Action confirmation'),
          content: const Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                choice = false;
                Navigator.pop(context);
              },
              child: const Text('No, keep me signed in'),
            ),
            TextButton(
              onPressed: () {
                choice = true;
                Navigator.pop(context);
              },
              child: const Text('Yes, sign me out'),
            ),
          ],
        );
      },
    );

    return choice;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: ProfileAvatar(
                  appUserData: widget.appUserData!,
                  borderColor: Theme.of(context).colorScheme.primary,
                  isHero: widget.isHero,
                  isProfileScreenAvatar: widget.isProfileScreenAvatar,
                ),
              ),
              const SizedBox(height: 6.0),
              Center(
                child: Text(
                  widget.appUserData!.userName!,
                  style: GoogleFonts.montserrat().copyWith(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    //letterSpacing: 1.0
                  ),
                ),
              ),
              const SizedBox(height: 4.0),
              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    const SizedBox(width: 4.0),
                    const Icon(
                      Icons.email,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      widget.appUserData!.email,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.black,
                height: 50.0,
              ),
            ],
          ),
        ),
        Expanded(child: Container()),
        if (widget.hasLogoutButton) Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Builder(builder: (BuildContext context) {
                  return OutlinedButton(
                    onPressed: () async {
                      _handleLogout(context);
                    },
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: const <Widget>[
                        Icon(Icons.logout),
                        SizedBox(width: 2.0),
                        Text('Logout'),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ) else const SizedBox(),
      ],
    );
  }
}

class ProfileDetailedScreen extends StatefulWidget {
  final AppUserData? appUserData;

  const ProfileDetailedScreen({Key? key, required this.appUserData}) : super(key: key);

  @override
  _ProfileDetailedScreenState createState() => _ProfileDetailedScreenState();
}

class _ProfileDetailedScreenState extends State<ProfileDetailedScreen> {

  @override
  Widget build(BuildContext context) {

    // Widget
    return Scaffold(
      appBar: AppBar(
        leading: appBarButton(context: context, iconData: Icons.arrow_back, onPressedFunction: () {
          Navigator.pop(context);
        }),
        title: const Text("Profile"),
      ),
      body: ProfileDetailedBody(appUserData: widget.appUserData, isHero: true, hasLogoutButton: true, isProfileScreenAvatar: true),
      //bottomNavigationBar: bottomNavigationBar,
    );
  }
}

