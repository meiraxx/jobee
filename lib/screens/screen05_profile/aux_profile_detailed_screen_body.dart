import 'package:flutter/material.dart';
import 'package:jobee/screens/widgets/buttons/elevated_button_widget.dart' show ElevatedButtonWidget;
import 'package:jobee/screens/widgets/logout.dart' show handleLogout;
import 'package:jobee/services/service01_database/aux_app_user_data.dart' show AppUserData;

import 'aux_profile_avatar.dart' show ProfileAvatar;

class ProfileDetailedScreenBody extends StatefulWidget {
  final AppUserData appUserData;
  final bool hasLogoutButton;
  final String heroTag;

  const ProfileDetailedScreenBody({Key? key, required this.appUserData, required this.hasLogoutButton, required this.heroTag}) : super(key: key);

  @override
  _ProfileDetailedScreenBodyState createState() => _ProfileDetailedScreenBodyState();
}

class _ProfileDetailedScreenBodyState extends State<ProfileDetailedScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildProfileAvatar(),
              const SizedBox(height: 6.0),
              buildName(),
              const SizedBox(height: 1.0),
              buildEmail(),
              const SizedBox(height: 6.0),
              buildUpgradeButton(),
              const Divider(
                color: Colors.black,
                height: 50.0,
              ),
            ],
          ),
        ),
        const Expanded(child: SizedBox()),
        buildLogoutButton(),
      ],
    );
  }

  Widget buildProfileAvatar() => Center(
    child: ProfileAvatar(
      appUserData: widget.appUserData,
      borderColor: Colors.transparent,
      isHero: true,
      heroTag: widget.heroTag,
      isProfileDetailedAvatar: true,
    ),
  );

  Widget buildName() => Center(
    child: Text(
      "${widget.appUserData.firstName!} ${widget.appUserData.lastName!}",
      style: Theme.of(context).textTheme.subtitle1!.copyWith(
        fontSize: 20.0,
      ),
    ),
  );

  Widget buildEmail() => Center(
    child: Text(
      widget.appUserData.email,
      style: Theme.of(context).textTheme.bodyText2!.copyWith(
        color: Colors.grey,
      ),
    ),
  );

  Widget buildUpgradeButton() => Center(
    child: ElevatedButtonWidget(
      text: 'Upgrade To PRO',
      onClicked: () {},
    ),
  );

  Widget buildLogoutButton() {
    // if widget is not supposed to have a logout button
    if (!widget.hasLogoutButton) {
      // return "nothing" (a.k.a., a sized box)
      return const SizedBox();
    }

    // else, return the logout button
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: Builder(builder: (BuildContext context) {
              return OutlinedButton(
                onPressed: () async {
                  await handleLogout(context);
                  Navigator.pop(context);
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
    );
  }

}
