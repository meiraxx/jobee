import 'package:flutter/material.dart';
import 'package:jobee/widgets/widget_utils/app_bar_button.dart' show appBarButton;
import 'package:jobee/models/app_user.dart' show AppUserData;

import 'profile_detailed_body.dart';

class ProfileDetailedScreen extends StatefulWidget {
  final AppUserData appUserData;

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

