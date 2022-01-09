import 'package:flutter/material.dart';
import 'package:jobee/screens/widgets/buttons/app_bar_button.dart' show appBarButton;
import 'package:jobee/services/service01_database/aux_app_user_data.dart' show AppUserData;
import 'package:jobee/screens/widgets/buttons/elevated_button_widget.dart' show ElevatedButtonWidget;
import 'package:jobee/screens/widgets/logout.dart' show handleLogout;

import 'aux_profile_avatar.dart' show ProfileAvatar;

class ViewProfileDetailedScreen extends StatefulWidget {
  final AppUserData appUserData;
  final String heroTag;
  final double scrollHeightCorrection;
  final void Function() toggleProfileViewCallback;

  const ViewProfileDetailedScreen({Key? key, required this.appUserData, required this.heroTag, this.scrollHeightCorrection = 0.0, required this.toggleProfileViewCallback}) : super(key: key);

  @override
  _ViewProfileDetailedScreenState createState() => _ViewProfileDetailedScreenState();
}

class _ViewProfileDetailedScreenState extends State<ViewProfileDetailedScreen> {

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    const double horizontalPadding = 30.0;
    //const double topPadding = 15.0;
    final double profilePageWidth = queryData.size.width - horizontalPadding*2;
    final double profilePageHeight = queryData.size.height;
    const double profileAvatarDiameter = 40.0*2 + 3.0*2; // profile avatar radius * 2 + avatar border * 2
    const double toggleProfileViewButtonHeight = 48.0;

    return GestureDetector(
      onTap: () {
        // removes focus from focused node when the AppBar or Scaffold are touched
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          reverse: true,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: profilePageHeight - profileAvatarDiameter - toggleProfileViewButtonHeight - widget.scrollHeightCorrection,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: _buildToggleProfileViewButton(), // height: 48.0
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildProfileAvatar(),
                          const SizedBox(width: 4.0),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: profileAvatarDiameter, // ProfileAvatar Height
                              maxWidth: profilePageWidth - profileAvatarDiameter - 4.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
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
                      _buildName(),
                      const Divider(
                        color: Colors.black,
                        height: 35.0,
                      ),
                      const SizedBox(height: 6.0),
                      //buildUpgradeButton(),
                      //const SizedBox(height: 24.0),
                      _buildGender(),
                      const SizedBox(height: 1.0),
                      _buildBirthDay(),
                      const SizedBox(height: 12.0),
                      _buildAbout(profilePageWidth),
                    ],
                  ),
                ),
                const Expanded(child: SizedBox()),
                _buildLogoutButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleProfileViewButton() => TextButton.icon(
    onPressed: () {
      widget.toggleProfileViewCallback();
    },
    // icon and label reversed
    label: Icon(
      Icons.edit,
      color: Theme.of(context).colorScheme.primaryVariant,
    ),
    icon: Text(
      "Edit Profile",
      style: TextStyle(color: Theme.of(context).colorScheme.primaryVariant),
    ),
  );

  Widget _buildProfileAvatar() => ProfileAvatar(
    appUserData: widget.appUserData,
    borderColor: Colors.transparent,
    isHero: true,
    heroTag: widget.heroTag,
  );

  Widget _buildName() => Text(
    "${widget.appUserData.firstName!} ${widget.appUserData.lastName!}",
    style: Theme.of(context).textTheme.subtitle1!.copyWith(
      fontSize: 20.0,
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

  Widget _buildGender() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        "Gender: ",
        style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 16.0),
      ),
      Text(
        widget.appUserData.gender!,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16.0),
      ),
    ],
  );

  Widget _buildBirthDay() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        "Birthday: ",
        style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 16.0),
      ),
      Text(
        widget.appUserData.birthDay!,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16.0),
      ),
    ],
  );

  Widget _buildAbout(double profilePageWidth) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        'About',
        style: Theme.of(context).textTheme.subtitle2!.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 1.0),
      ConstrainedBox(
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
    ],
  );

  Widget _buildUpgradeButton() => Center(
    child: ElevatedButtonWidget(
      text: 'Upgrade To PRO',
      onClicked: () {},
    ),
  );

  Widget _buildLogoutButton() => Padding(
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

