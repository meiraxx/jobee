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
    final MediaQueryData queryData = MediaQuery.of(context);
    const double horizontalPadding = 30.0;
    const double topPadding = 15.0;
    final double profilePageWidth = queryData.size.width - horizontalPadding*2;
    final double profilePageHeight = queryData.size.height;
    final double profileAvatarDiameter = 86.0;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(horizontalPadding, topPadding, horizontalPadding, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _buildProfileAvatar(),
                    const SizedBox(width: 4.0),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: profileAvatarDiameter, // ProfileAvatar Height
                        maxWidth: profilePageWidth - profileAvatarDiameter - 4.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 4.0),
                          _buildUserName(),
                          const SizedBox(height: 6.0),
                          _buildPhoneNumber(),
                          const SizedBox(height: 6.0),
                          _buildEmail(),
                          const SizedBox(height: 6.0),
                          _buildLocation(),
                          const SizedBox(height: 2.0),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6.0),
                buildName(),
                const Divider(
                  color: Colors.black,
                  height: 50.0,
                ),
                const SizedBox(height: 6.0),
                //buildUpgradeButton(),
                //const SizedBox(height: 24.0),
                //buildUserName(),
                //const SizedBox(height: 1.0),
                buildGender(),
                const SizedBox(height: 1.0),
                buildBirthDay(),
                const SizedBox(height: 12.0),
                buildAbout(profilePageWidth),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar() => ProfileAvatar(
    appUserData: widget.appUserData,
    borderColor: Colors.transparent,
    isHero: true,
    heroTag: widget.heroTag,
    isProfileDetailedAvatar: true,
  );

  Widget buildName() => Text(
    "${widget.appUserData.firstName!} ${widget.appUserData.lastName!}",
    style: Theme.of(context).textTheme.subtitle1!.copyWith(
      fontSize: 20.0,
    ),
  );

  Widget buildContactInfo() => Text(
    "${widget.appUserData.email} | (${widget.appUserData.phoneCountryDialCode}) ${widget.appUserData.phoneNumber!}",
    style: Theme.of(context).textTheme.bodyText2!.copyWith(
      color: Colors.grey,
    ),
  );

  Widget _buildUserName() => Row(
    children: <Widget>[
      Text(
        "@",
        style: Theme.of(context).textTheme.bodyText2,
      ),
      const SizedBox(width: 4.0),
      Text(
        widget.appUserData.userName!,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    ],
  );

  Widget _buildPhoneNumber() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Padding(
        padding: EdgeInsets.only(top: 1.0),
        child: Icon(
          Icons.phone_android_rounded,
          size: 13.0,
        ),
      ),
      const SizedBox(width: 4.0),
      Text(
        "(${widget.appUserData.phoneCountryDialCode!}) ${widget.appUserData.phoneNumber!}",
        style: Theme.of(context).textTheme.bodyText2,
      ),
    ],
  );

  Widget _buildEmail() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Padding(
        padding: EdgeInsets.only(top: 1.5),
        child: Icon(
          Icons.email,
          size: 13.0,
        ),
      ),
      const SizedBox(width: 4.0),
      Expanded(
        child: Text(
          widget.appUserData.email,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    ],
  );

  Widget _buildLocation() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Padding(
        padding: EdgeInsets.only(top: 1.5),
        child: Icon(
          Icons.location_on_sharp,
          size: 13.0,
        ),
      ),
      const SizedBox(width: 4.0),
      Expanded(
        child: Text(
          "Lisbon",
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    ],
  );

  Widget buildGender() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        "Gender:  ",
        style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 16.0),
      ),
      Text(
        widget.appUserData.gender!,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16.0),
      ),
    ],
  );

  Widget buildBirthDay() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        "Birthday:  ",
        style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 16.0),
      ),
      Text(
        widget.appUserData.birthDay!,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16.0),
      ),
    ],
  );

  Widget buildAbout(double profilePageWidth) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        'About',
        style: Theme.of(context).textTheme.subtitle2!.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 4),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: profilePageWidth,
              //maxWidth: _kMenuMaxWidth,
            ),
            child: Text(
              "Hello! I am Sonic, the HedgeHog. I'm still not a db field, but I will be soon! Stay tuned ;)",
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontSize: 14,
                  height: 1.4
              ),
            ),
          ),
        ),
      ),
    ],
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
