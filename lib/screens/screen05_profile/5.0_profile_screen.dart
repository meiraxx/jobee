import 'package:flutter/material.dart';
import 'package:jobee/services/service01_database/aux_app_user_data.dart';

import '5.1_view_profile_detailed_screen.dart';
import '5.2_edit_profile_detailed_screen.dart';

class ProfileScreen extends StatefulWidget {
  final AppUserData appUserData;

  const ProfileScreen({Key? key, required this.appUserData}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool showView = true;

  void toggleProfileView() {
    setState( () => showView = !showView );
  }

  @override
  Widget build(BuildContext context) => showView
    ? ViewProfileDetailedScreen(appUserData: widget.appUserData, heroTag: 'profileAvatarHeroTag', scrollHeightCorrection: 0.0, toggleProfileViewCallback: toggleProfileView)
    : EditProfileDetailedScreen(appUserData: widget.appUserData, heroTag: 'profileAvatarHeroTag', scrollHeightCorrection: 0.0, toggleProfileViewCallback: toggleProfileView);
}
