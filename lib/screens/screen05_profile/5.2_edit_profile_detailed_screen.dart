import 'package:flutter/material.dart';
import 'package:jobee/screens/widgets/buttons/app_bar_button.dart' show appBarButton;
import 'package:jobee/screens/widgets/loaders/in_place_loader.dart';
import 'package:jobee/screens/widgets/size_provider.dart';
import 'package:jobee/services/service01_database/1.0_database.dart';
import 'package:jobee/services/service01_database/aux_app_user_data.dart' show AppUserData;
import 'package:jobee/screens/widgets/input/date_picker_form_field_widget.dart' show DatePickerFormFieldWidget;
import 'package:jobee/screens/widgets/input/dropdown_button_form_field_widget.dart' show DropdownButtonFormFieldWidget;
import 'package:jobee/screens/widgets/input/text_form_field_widget.dart' show TextFormFieldWidget;
import 'package:jobee/utils/input_field_validation.dart';
import 'package:jobee/utils/type_utils.dart' show convertStringToDateTime;

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
  // Form constants
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _formNotSubmitted = true;

  // text field state
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();
  String? _gender;
  final List<String> _genders = <String>['Male', 'Female', 'Other', "I'd rather not say"];
  DateTime? _birthDay;

  // field error state
  double _errorSizedBoxSizeUserName = 0.0;
  double _errorSizedBoxSizeFirstName = 0.0;
  double _errorSizedBoxSizeLastName = 0.0;
  double _errorSizedBoxSizeGender = 0.0;
  double _errorSizedBoxSizeBirthday = 0.0;

  // error state - field padding correction
  final double _birthDayTopPadding = 4.0;
  final bool _spacedFormFields = false;

  // back-end error state
  String _submissionError = '';
  double _submissionErrorSizedBoxHeight = 0.0;

  // Open Dropdown
  final GlobalKey _dropdownButtonKey = GlobalKey();

  genderUpdateCallback(String gender) {
    _gender = gender;
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    const double horizontalPadding = 30.0;
    const double topPadding = 15.0;
    final double profilePageWidth = queryData.size.width - horizontalPadding*2;
    final double profilePageHeight = queryData.size.height;
    const double profileAvatarDiameter = 40.0*2 + 3.0*2; // profile avatar radius * 2 + avatar border * 2
    const double toggleProfileViewButtonHeight = 48.0;

    // etc.
    final DateTime today = DateTime.now();
    final Locale userLocale = Localizations.localeOf(context);

    // app user data
    final AppUserData appUserData = widget.appUserData;

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
                  //padding: const EdgeInsets.fromLTRB(horizontalPadding, topPadding, horizontalPadding, 0.0),
                  padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
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
                    _buildCancelButton(),
                  ],
                ),
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
      Icons.remove_red_eye_sharp,
      color: Theme.of(context).colorScheme.primaryVariant,
    ),
    icon: Text(
      "View Profile",
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
    updateCallback: genderUpdateCallback,
  );

  Widget _buildBirthDayEditField() => DatePickerFormFieldWidget(
    label: 'Birthday',
    text: widget.appUserData.birthDay!,
    initialDate: convertStringToDateTime(widget.appUserData.birthDay!),
    validate: () {},
  );

  Widget _buildAboutEditField(double profilePageWidth) => TextFormFieldWidget(
    label: 'About',
    text: widget.appUserData.about ?? '',
    onChanged: (String about) {},
    validate: () {},
    maxLines: 4,
  );

  Widget _buildCancelButton() => TextButton(
    onPressed: () {
      widget.toggleProfileViewCallback();
    },
    child: Text(
      "Cancel",
      style: TextStyle(color: Theme.of(context).colorScheme.primaryVariant),
    ),
  );

  Widget _buildSaveButton() => Center(
    child: ElevatedButton(
      onPressed: () async {
        // save logic

        _formNotSubmitted = false;
        //if (allFormFieldsValidated()) {
        if (true) {
          // while submitting data, set loading to true
          _loading = true;
          if (this.mounted) setState(() {});

          await InPlaceLoader.extendLoadingDuration(const Duration(seconds: 1));
          try {
            await DatabaseService(uid: widget.appUserData.uid, email: widget.appUserData.email).updateUserProfileData(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              gender: _gender!,
              birthDay: _birthDayController.text,
              about: '',
            );
          } on Exception catch (e) {
            // grab the exception message and remove
            // the "Exception: " extra text
            //_submissionError = e.toString().replaceFirst("Exception: ", '');
            //_submissionErrorSizedBoxHeight = defaultSubmissionErrorHeight;
            if (this.mounted) setState(() {});
          }
          // after everything is done, set _loading back to false
          _loading = false;
          if (this.mounted) setState(() {});
        }
        // rebuild page on submit
        if (this.mounted) setState(() {});
        // after save is done, toggle back to profile view mode
        widget.toggleProfileViewCallback();
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

