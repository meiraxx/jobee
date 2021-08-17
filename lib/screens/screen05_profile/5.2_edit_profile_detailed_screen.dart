import 'package:flutter/material.dart';
import 'package:jobee/screens/widgets/buttons/app_bar_button.dart' show appBarButton;
import 'package:jobee/screens/widgets/size_provider.dart';
import 'package:jobee/services/service01_database/aux_app_user_data.dart' show AppUserData;
import 'package:jobee/screens/widgets/input/date_picker_form_field_widget.dart' show DatePickerFormFieldWidget;
import 'package:jobee/screens/widgets/input/dropdown_button_form_field_widget.dart' show DropdownButtonFormFieldWidget;
import 'package:jobee/screens/widgets/input/text_form_field_widget.dart' show TextFormFieldWidget;

import 'aux_profile_avatar.dart' show ProfileAvatar;

class EditProfileDetailedScreen extends StatefulWidget {
  final AppUserData appUserData;
  final String heroTag;
  final double scrollHeightCorrection;
  final void Function() toggleProfileViewCallback;

  const EditProfileDetailedScreen({Key? key, required this.appUserData, required this.heroTag, this.scrollHeightCorrection = 0.0, required this.toggleProfileViewCallback}) : super(key: key);

  @override
  _EditProfileDetailedScreenState createState() => _EditProfileDetailedScreenState();
}

class _EditProfileDetailedScreenState extends State<EditProfileDetailedScreen> {

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    const double horizontalPadding = 30.0;
    const double topPadding = 15.0;
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(horizontalPadding, topPadding, horizontalPadding, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildProfileAvatar(), // height: 86.0
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
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 6.0),
                          const SizedBox(height: 6.0),
                          _buildFirstNameEditField(),
                          const SizedBox(height: 6.0),
                          _buildLastNameEditField(),
                          const SizedBox(height: 6.0),
                          _buildGenderEditField(),
                          const SizedBox(height: 6.0),
                          _buildBirthDayEditField(),
                          const SizedBox(height: 18.0),
                          _buildAboutEditField(profilePageWidth),
                        ],
                      ),
                    ],
                  ),
                ),
                const Expanded(child: SizedBox()),
                //const SizedBox(height: 6.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildSaveButton(),
                    const SizedBox(width: 8.0),
                    _buildToggleProfileViewButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleProfileViewButton() => TextButton(
    onPressed: () {
      widget.toggleProfileViewCallback();
    },
    child: Text(
      "Cancel",
      style: TextStyle(color: Theme.of(context).colorScheme.primaryVariant),
    ),
  );

  Widget _buildProfileAvatar() {
    final Widget profileAvatar = ProfileAvatar(
      appUserData: widget.appUserData,
      borderColor: Colors.transparent,
      isHero: true,
      heroTag: 'profileAvatarHeroTag',
    );

    // if the keyboard input is visible on the screen
    if (WidgetsBinding.instance!.window.viewInsets.bottom > 0.0) {
      // do not consider any clicks on the profile avatar
      return AbsorbPointer(child: profileAvatar);
    }

    return profileAvatar;
  }

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

  Widget _buildLocationEditField() => const SizedBox(); // TODO

  Widget _buildFirstNameEditField() => TextFormFieldWidget(
    label: 'First Name',
    text: widget.appUserData.firstName!,
    onChanged: (String firstName) {},
    validate: () {},
  );

  Widget _buildLastNameEditField() => TextFormFieldWidget(
    label: 'Last Name',
    text: widget.appUserData.lastName!,
    onChanged: (String lastName) {},
    validate: () {},
  );

  Widget _buildGenderEditField() => DropdownButtonFormFieldWidget(
    label: 'Gender',
    optionList: const <String>['Male', 'Female', 'Other', "I'd rather not say"],
    initialOption: widget.appUserData.gender,
    onChanged: (String? gender) {},
    validate: () {},
  );

  Widget _buildBirthDayEditField() => DatePickerFormFieldWidget(
    label: 'Birthday',
    text: widget.appUserData.birthDay!,
    validate: () {},
  );

  Widget _buildAboutEditField(double profilePageWidth) => TextFormFieldWidget(
    label: 'About',
    text: widget.appUserData.about ?? '',
    onChanged: (String about) {},
    validate: () {},
    maxLines: 4,
  );

  Widget _buildSaveButton() => Center(
    child: ElevatedButton(
      onPressed: () async {
        // save logic
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all( Theme.of(context).colorScheme.primaryVariant ),
      ),
      child: Text(
        'Save',
        style: TextStyle(
          color: Theme.of(context).colorScheme.background,
        ),
      ),
    ),
  );

}

