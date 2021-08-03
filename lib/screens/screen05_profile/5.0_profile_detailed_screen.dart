import 'package:flutter/material.dart';
import 'package:jobee/screens/widgets/buttons/app_bar_button.dart' show appBarButton;
import 'package:jobee/services/service01_database/aux_app_user_data.dart' show AppUserData;

import 'aux_profile_detailed_screen_body.dart';

class ProfileDetailedScreen extends StatefulWidget {
  final AppUserData appUserData;

  const ProfileDetailedScreen({Key? key, required this.appUserData}) : super(key: key);

  @override
  _ProfileDetailedScreenState createState() => _ProfileDetailedScreenState();
}

class _ProfileDetailedScreenState extends State<ProfileDetailedScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: appBarButton(context: context, iconData: Icons.arrow_back, onClicked: () {
          Navigator.pop(context);
        }),
        //backgroundColor: Theme.of(context).backgroundColor,
        title: const Text("Profile"),
      ),
      body: ProfileDetailedScreenBody(appUserData: widget.appUserData, hasLogoutButton: true, heroTag: 'profileDetailedScreenAvatar'),
      //bottomNavigationBar: bottomNavigationBar,
    );
  }
}

