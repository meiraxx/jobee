import 'package:flutter/material.dart';
import 'package:jobee/widgets/widget_utils/app_bar_button.dart' show appBarButton;
import 'package:jobee/screens/screen05_profile/global_variables_profile.dart' show ProfileSyncGlobals;

import 'aux_profile_avatar.dart' show ProfileAvatar;

/// Class for the full screen profile avatar
class ProfileAvatarFullScreen extends StatefulWidget {
  final ProfileAvatar profileAvatar;

  const ProfileAvatarFullScreen({Key? key, required this.profileAvatar}) : super(key: key);

  @override
  _ProfileAvatarFullScreenState createState() => _ProfileAvatarFullScreenState();
}

class _ProfileAvatarFullScreenState extends State<ProfileAvatarFullScreen> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: appBarButton(context: context, iconData: Icons.arrow_back, onPressedFunction: () {
          Navigator.pop(context);
        }, color: Colors.white),
        title: const Text("Profile picture", style: TextStyle(color: Colors.white)),
        elevation: 0.0,
        actions: <Widget>[
          appBarButton(context: context, iconData: Icons.edit, onPressedFunction: () async {
            // TODO: call _handleProfileAvatarUploadIntent(context) here somehow
          }, color: Colors.white),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(color: Colors.black),
          ),
          Container(
            color: Colors.black,
            child: Hero(
              tag: 'profileAvatarHero',
              child: AspectRatio(
                aspectRatio: 3 / 3,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      image: DecorationImage(
                        image: MemoryImage(
                          ProfileSyncGlobals.userProfileAvatarBytes!,
                        ),
                        fit: BoxFit.cover,
                      )
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(color: Colors.black),
          ),
        ],
      ),
    );
  }
}