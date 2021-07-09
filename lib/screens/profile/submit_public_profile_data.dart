import 'package:flutter/material.dart';
import 'package:jobee/models/app_user.dart';
import 'package:jobee/screens/profile/submit_personal_profile_data.dart';
import 'package:jobee/screens/screens-shared/logo.dart';
import 'package:jobee/services/auth.dart';
import 'package:jobee/services/database.dart';
import 'package:jobee/utils/input_field_utils.dart';
import 'package:jobee/widgets/loaders.dart';
import 'package:provider/provider.dart';

class SubmitPublicProfileData extends StatefulWidget {
  const SubmitPublicProfileData({Key? key}) : super(key: key);

  @override
  _SubmitPublicProfileDataState createState() => _SubmitPublicProfileDataState();
}

class _SubmitPublicProfileDataState extends State<SubmitPublicProfileData> {
  // Form constants
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _formNotSubmitted = true;

  // text field state
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _birthDayController = TextEditingController();
  String? _gender;
  List<String> _genders = ['Male', 'Female', 'Other', "I'd rather not say"];
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
  GlobalKey _dropdownButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance!
    //    .addPostFrameCallback((_) => build(context));
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    // form info
    final double defaultFormFieldSpacing = Theme.of(context).textTheme.caption!.fontSize!;
    final double defaultSubmissionErrorHeight = defaultFormFieldSpacing/2;
    const double formVerticalPadding = 20.0;
    const double formHorizontalPadding = 30.0;
    double formWidth = (queryData.size.width - formHorizontalPadding*2);

    // form validation
    Map <String, String? Function()> validateFieldFunctionMap = {
      'userName': () => validateNotEmpty(
        text: _userNameController.text,
        field: 'userName',
        errorMessage: "Enter your username",
        formNotSubmitted: _formNotSubmitted,
        successFunction: () {
          _errorSizedBoxSizeUserName = defaultFormFieldSpacing;
        },
        errorFunction: () {
          _errorSizedBoxSizeUserName = 0.0;
        },
      ),
      'firstName': () => validateNotEmpty(
        text: _firstNameController.text,
        field: 'firstName',
        errorMessage: "Enter your first name",
        formNotSubmitted: _formNotSubmitted,
        successFunction: () {
          _errorSizedBoxSizeFirstName = defaultFormFieldSpacing;
        },
        errorFunction: () {
          _errorSizedBoxSizeFirstName = 0.0;
        },
      ),
      'lastName': () => validateNotEmpty(
        text: _lastNameController.text,
        field: 'lastName',
        errorMessage: "Enter your last name",
        formNotSubmitted: _formNotSubmitted,
        successFunction: () {
          _errorSizedBoxSizeLastName = defaultFormFieldSpacing;
        },
        errorFunction: () {
          _errorSizedBoxSizeLastName = 0.0;
        },
      ),
      'gender': () => validateNotEmpty(
        text: _gender??'',
        field: 'gender',
        errorMessage: "Enter your gender",
        formNotSubmitted: _formNotSubmitted,
        successFunction: () {
          _errorSizedBoxSizeGender = defaultFormFieldSpacing;
        },
        errorFunction: () {
          _errorSizedBoxSizeGender = 0.0;
        },
      ),
      'birthDay': () => validateNotEmpty(
        text: _birthDayController.text,
        field: 'birthDay',
        errorMessage: "Enter your birthday",
        formNotSubmitted: _formNotSubmitted,
        successFunction: () {
          _errorSizedBoxSizeBirthday = 0.0;
        },
        errorFunction: () {
          _errorSizedBoxSizeBirthday = 0.0;
        },
      ),
    };

    bool allFormFieldsValidated() {
      // run every field validation function,
      // if every function returns null, then every field is validated
      return validateFieldFunctionMap.values.every((fieldValidationFunction) => fieldValidationFunction()==null);
    }

    // etc.
    DateTime today = DateTime.now();
    Locale userLocale = Localizations.localeOf(context);

    // app user data
    AppUserData? appUserData = Provider.of<AppUserData?>(context);
    if (appUserData==null) return TextLoader(text: "Fetching user data...");

    return appUserData.hasRegisteredPublicData
    ?SubmitPersonalProfileData()
    :GestureDetector(
      onTap: () {
        /* removes focus from focused node when
            * the AppBar or Scaffold are touched */
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Logo(),
                SizedBox(width: 16.0),
                Text(
                  "|   Public information",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )
              ],
            )
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: formVerticalPadding, horizontal: formHorizontalPadding),
              child: Form(
                key: _formKey,
                child: AutofillGroup(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      // - userName row
                      Row(
                        children: <Widget>[
                          // - userName form field
                          Container(
                            width: formWidth,
                            height: defaultFormFieldSpacing*6,
                            child: TextFormField(
                              controller: _userNameController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: "Username",
                                errorText: validateFieldFunctionMap['userName']!(),
                              ),
                              textAlignVertical: TextAlignVertical.center,
                              // cleanse errors by rebuilding widget on... :
                              onTap: () {
                                setState(() {});
                              },
                              onChanged: (String usernameVal) {
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(height: _errorSizedBoxSizeUserName),
                        ],
                      ),
                      if (_spacedFormFields) ...[
                        SizedBox(height: defaultFormFieldSpacing)
                      ] else ...[
                        SizedBox(height: 0.0)
                      ],
                      // - firstName+lastName row
                      Row(
                        children: <Widget>[
                          // - First name
                          Container(
                            width: formWidth/2 - defaultFormFieldSpacing/2,
                            height: defaultFormFieldSpacing*6,
                            child: TextFormField(
                              controller: _firstNameController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: "First name",
                                errorText: validateFieldFunctionMap['firstName']!(),
                              ),
                              textAlignVertical: TextAlignVertical.center,
                              autofillHints: [AutofillHints.givenName],
                              // cleanse errors by rebuilding widget on... :
                              onTap: () {
                                setState(() {});
                              },
                              onChanged: (String firstNameVal) {
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(height: _errorSizedBoxSizeFirstName),
                          SizedBox(width: defaultFormFieldSpacing),
                          // - Last name
                          Container(
                            width: formWidth/2 - defaultFormFieldSpacing/2,
                            height: defaultFormFieldSpacing*6,
                            child: TextFormField(
                              controller: _lastNameController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: "Last name",
                                errorText: validateFieldFunctionMap['lastName']!(),
                              ),
                              textAlignVertical: TextAlignVertical.center,
                              autofillHints: [AutofillHints.familyName],
                              // cleanse errors by rebuilding widget on... :
                              onTap: () {
                                setState(() {});
                              },
                              onChanged: (String lastNameVal) {
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(height: _errorSizedBoxSizeLastName),
                        ],
                      ),
                      if (_spacedFormFields) ...[
                        SizedBox(height: defaultFormFieldSpacing)
                      ] else ...[
                        SizedBox(height: 0.0)
                      ],
                      // - gender+birthDay row
                      Row(
                        children: [
                          // - Gender
                          GestureDetector(
                            onTap: () {
                              // print("Manually activate dropdown button");
                              openDropdownMethod2(_dropdownButtonKey); // manually activate dropdown button
                            },
                            child: Container(
                              width: formWidth/2 - defaultFormFieldSpacing/2,
                              height: defaultFormFieldSpacing*6,
                              child: DropdownButtonFormField(
                                key: _dropdownButtonKey,
                                iconSize: 0.0,
                                value: _gender,
                                decoration: InputDecoration(
                                  labelText: 'Gender',
                                  errorText: validateFieldFunctionMap['gender']!(),
                                ),
                                onChanged: (String? genderVal) {
                                  setState((){
                                    _gender = genderVal;
                                  });
                                },
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                items: _genders.map((String gender) {
                                  return DropdownMenuItem(
                                    value: gender,
                                    child: Text(gender),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(height: _errorSizedBoxSizeGender),
                          SizedBox(width: defaultFormFieldSpacing),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: formWidth/2 - defaultFormFieldSpacing/2,
                                height: defaultFormFieldSpacing*6 + _birthDayTopPadding,
                                padding: EdgeInsets.only(top: _birthDayTopPadding),
                                child: GestureDetector(
                                  onTap: () async {
                                    // await for user to pick the date
                                    DateTime? picked = await showDatePicker(
                                      context: context,
                                      // initialDate is set to
                                      initialDate: _birthDay??DateTime(today.year-18, today.month, today.day),
                                      // assumption: no person above 120
                                      // years-old will be using this app
                                      // TODO-BackEnd: force age between below 120
                                      firstDate: DateTime(today.year-120, today.month, today.day),
                                      // assumption: it should be a requirement to be
                                      // at least 18 years-old to be using this app
                                      // TODO-BackEnd: force age between above 16
                                      lastDate: DateTime(today.year-18, today.month, today.day),
                                      locale: userLocale,
                                    );
                                    /* if date isn't null and isn't the same picked before,
                                        * build the page again with the picked value */
                                    if(picked != null && picked != _birthDay) {
                                      _birthDay = picked;
                                      _birthDayController.value = TextEditingValue(
                                        text: "${picked.year}"
                                          "/${picked.month>=10?picked.month:('0'+picked.month.toString())}"
                                          "/${picked.day>=10?picked.day:('0'+picked.day.toString())}"
                                      );
                                      if (this.mounted) setState(() {});
                                    }
                                    // remove focus
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  },
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller: _birthDayController,
                                      keyboardType: TextInputType.datetime,
                                      decoration: InputDecoration(
                                        labelText: "Birthday",
                                        errorText: validateFieldFunctionMap['birthDay']!(),
                                      ),
                                      textAlignVertical: TextAlignVertical.center,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: _errorSizedBoxSizeBirthday),
                            ],
                          )
                        ],
                      ),
                      if (_spacedFormFields) ...[
                        SizedBox(height: defaultFormFieldSpacing)
                      ] else ...[
                        SizedBox(height: 0.0)
                      ],
                      Center(
                        child: Builder(builder: (BuildContext context) {
                          return _loading
                          ? InPlaceLoader(replacedWidgetSize: Size(48.0, 48.0), submissionErrorHeight: defaultSubmissionErrorHeight)
                          : ElevatedButton(
                            onPressed: () async {
                              _formNotSubmitted = false;
                              if (allFormFieldsValidated()) {
                                // while submitting data, set loading to true
                                _loading = true;
                                _submissionErrorSizedBoxHeight = defaultFormFieldSpacing;
                                if (this.mounted) setState(() {});

                                await InPlaceLoader.minimumLoadingSleep(const Duration(seconds: 1));
                                try {
                                  await DatabaseService(uid: appUserData.uid).updatePublicUserData(
                                    hasRegisteredPublicData: true,
                                    userName: _userNameController.text,
                                    firstName: _firstNameController.text,
                                    lastName: _lastNameController.text,
                                    gender: _gender,
                                    birthDay: _birthDayController.text,
                                  );
                                } on Exception catch (e) {
                                  // grab the exception message and remove
                                  // the "Exception: " extra text
                                  _submissionError = e.toString().replaceFirst("Exception: ", '');
                                  _submissionErrorSizedBoxHeight = defaultSubmissionErrorHeight;
                                  if (this.mounted) setState(() {});
                                }
                                // after everything is done, set _loading back to false
                                _loading = false;
                                if (this.mounted) setState(() {});
                              }
                              // rebuild page on submit
                              if (this.mounted) setState(() {});
                            },
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Icon(Icons.public),
                                SizedBox(width: 4.0),
                                Text(
                                  "Submit data",
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: _submissionErrorSizedBoxHeight),
                      Text(
                        _submissionError,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            // - End Row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("Want to switch account?"),
                TextButton(
                  child: Text(
                    "Sign out",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () async {
                    await AuthService.signOut(context: context);
                    Navigator.pushReplacementNamed(context, '/');
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    //_userNameController.dispose();
    //_firstNameController.dispose();
    //_lastNameController.dispose();
    //_birthDayController.dispose();
    super.dispose();
  }
}
