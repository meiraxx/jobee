import 'package:flutter/material.dart';
import 'package:jobee/external-libs/intl_phone_field-2.0.0/intl_phone_field.dart';
import 'package:jobee/external-libs/intl_phone_field-2.0.0/phone_number.dart';
import 'package:jobee/models/app_user.dart';
import 'package:jobee/screens/home/home.dart';
import 'package:jobee/screens/screens-shared/logo.dart';
import 'package:jobee/screens/wrapper.dart';
import 'package:jobee/services/auth.dart';
import 'package:jobee/services/database.dart';
import 'package:jobee/services/network.dart';
import 'package:jobee/utils/input_field_utils.dart';
import 'package:jobee/widgets/loaders.dart';
import 'package:provider/provider.dart';

class SubmitPersonalProfileData extends StatefulWidget {
  const SubmitPersonalProfileData({Key? key}) : super(key: key);

  @override
  _SubmitPersonalProfileDataState createState() => _SubmitPersonalProfileDataState();
}

class _SubmitPersonalProfileDataState extends State<SubmitPersonalProfileData> {

  // Form constants
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _formNotSubmitted = true;
  String? _currentlyFocusedField;

  // text field state
  String _phoneCountryDialCode = "+351";
  String? _phoneNumber;

  // field error state
  double _errorSizedBoxSizePhoneNumber = 0.0;

  // back-end error state
  String _submissionError = '';
  double _submissionErrorSizedBoxHeight = 0.0;

  // error state - field padding correction
  final bool _spacedFormFields = false;

  // user info
  Future<Map<String, dynamic>> _infoByIP = NetworkService.getInfoByIP() as Future<Map<String, dynamic>>;

  @override
  void initState() {
    super.initState();
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

    // app user data
    AppUserData? appUserData = Provider.of<AppUserData?>(context);
    if (appUserData==null) return TextLoader(text: "Fetching user data...");

    return appUserData.hasRegisteredPersonalData
    ?Home()
    :FutureBuilder<Map<String, dynamic>>(
      future: _infoByIP,
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> futureSnapshot) {
        switch (futureSnapshot.connectionState) {
          case ConnectionState.none: return Text('ConnectionState.none is not reached.');
          case ConnectionState.waiting: return TextLoader(text: "Personal information page loading");
          default:
            if (futureSnapshot.hasError)
              return Text('Error: ${futureSnapshot.error}');

            // else, condition to validate that we received the expected data from the external API
            if ( futureSnapshot.data==null || !(futureSnapshot.data!.containsKey("countryCode")) ) {
              // return to wrapper to retry connection
              return Wrapper();
            }

            // else, return the personal information page
            return GestureDetector(
              onTap: () {
                /* removes focus from focused node when
                  * the AppBar or Scaffold are touched */
                FocusManager.instance.primaryFocus?.unfocus();
                _currentlyFocusedField = null;
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
                        "|   Personal information",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                body: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: formVerticalPadding, horizontal: formHorizontalPadding),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 20.0),
                            // - phoneNumber row
                            Row(
                              children: <Widget>[
                                Container(
                                  width: formWidth,
                                  //height: defaultFormFieldSpacing*6,
                                  child: IntlPhoneField(
                                    decoration: InputDecoration(
                                      labelText: 'Phone Number',
                                    ),
                                    textAlignVertical: TextAlignVertical.center,
                                    // initialCountryCode obtained using _infoByIP
                                    initialCountryCode: futureSnapshot.data!["countryCode"],
                                    onChanged: (PhoneNumber phone) {
                                      _phoneNumber = phone.number;
                                    },
                                    onCountryChanged: (PhoneNumber phone) {
                                      _phoneCountryDialCode = phone.countryCode!;
                                    },
                                    validator: (String? phoneNumber){
                                      String? emptyMessage = validateNotEmpty(
                                        text: phoneNumber??'',
                                        field: 'phoneNumber',
                                        errorMessage: "Enter your phone number",
                                        formNotSubmitted: _formNotSubmitted,
                                        currentlyFocusedField: _currentlyFocusedField,
                                        successFunction: () {
                                          _errorSizedBoxSizePhoneNumber = defaultFormFieldSpacing;
                                        },
                                        errorFunction: () {
                                          _errorSizedBoxSizePhoneNumber = 0.0;
                                        },
                                      );

                                      if (emptyMessage != null) {
                                        // empty validation error
                                        return emptyMessage;
                                      }

                                      // else, logically validate phone number
                                      List<Object> phoneNumberValidationInfo = validatePhoneNumber(
                                        phoneCountryDialCode: _phoneCountryDialCode,
                                        phoneNumber: phoneNumber??'',
                                      );
                                      bool phoneNumberValidated = phoneNumberValidationInfo[0] as bool;
                                      String validationMessage = phoneNumberValidationInfo[1] as String;

                                      if (!phoneNumberValidated) {
                                        // phone validation error
                                        _errorSizedBoxSizePhoneNumber = 0.0;
                                        return validationMessage;
                                      }

                                      // success
                                      _errorSizedBoxSizePhoneNumber = defaultFormFieldSpacing;
                                      return null;
                                    },
                                    autoValidate: false,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: _errorSizedBoxSizePhoneNumber),
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
                                    if (_formKey.currentState!.validate()) {
                                      // while submitting data, set loading to true
                                      _loading = true;
                                      _submissionErrorSizedBoxHeight = defaultFormFieldSpacing;
                                      if (this.mounted) setState(() {});

                                      await InPlaceLoader.minimumLoadingSleep(const Duration(seconds: 1));
                                      try {
                                        await DatabaseService(uid: appUserData.uid).updatePersonalUserData(
                                          hasRegisteredPersonalData: true,
                                          phoneCountryDialCode: _phoneCountryDialCode,
                                          phoneNumber: _phoneNumber,
                                        );
                                      } on Exception catch(e) {
                                        // grab the exception message and remove
                                        // the "Exception: " extra text
                                        _submissionError = e.toString().replaceFirst("Exception: ", '');
                                        _submissionErrorSizedBoxHeight = defaultSubmissionErrorHeight;
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
                                      Icon(Icons.lock),
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
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
