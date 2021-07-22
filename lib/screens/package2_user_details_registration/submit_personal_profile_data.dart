import 'package:flutter/material.dart';
import 'package:jobee/external-libs/intl_phone_field-2.0.0/intl_phone_field.dart' show IntlPhoneField;
import 'package:jobee/external-libs/intl_phone_field-2.0.0/phone_number.dart' show PhoneNumber;
//import 'package:intl_phone_field/intl_phone_field.dart' show IntlPhoneField;
//import 'package:intl_phone_field/phone_number.dart' show PhoneNumber;
import 'package:jobee/models/app_user.dart' show AppUserData;
import 'package:jobee/screens/package3_home/home.dart' show Home;
import 'package:jobee/screens/shared_screens/logo.dart' show Logo;
import 'package:jobee/screens/wrapper.dart' show Wrapper;
import 'package:jobee/services/auth.dart' show AuthService;
import 'package:jobee/services/database.dart' show DatabaseService;
import 'package:jobee/services/network.dart' show NetworkService;
import 'package:jobee/utils/input_field_validation.dart' show validateNotEmpty, validatePhoneNumber;
import 'package:jobee/widgets/loaders/text_loader.dart' show TextLoader;
import 'package:jobee/widgets/loaders/in_place_loader.dart' show InPlaceLoader;
import 'package:provider/provider.dart' show Provider;

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
  final Future<Map<String, dynamic>> _infoByIP = NetworkService.getInfoByIP()!;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    // form info
    final double defaultFormFieldSpacing = Theme.of(context).textTheme.caption!.fontSize!;
    final double defaultSubmissionErrorHeight = defaultFormFieldSpacing/2;

    const double formVerticalPadding = 20.0;
    const double formHorizontalPadding = 30.0;
    final double formWidth = queryData.size.width - formHorizontalPadding*2;

    // app user data
    final AppUserData? appUserData = Provider.of<AppUserData?>(context);

    return appUserData!.hasRegisteredPersonalData
    ? const Home()
    : FutureBuilder<Map<String, dynamic>>(
      future: _infoByIP,
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> futureSnapshot) {
        switch (futureSnapshot.connectionState) {
          case ConnectionState.none: return const Text('ConnectionState.none is not reached.');
          case ConnectionState.waiting: return const TextLoader(text: "Personal information page loading");
          default:
            if (futureSnapshot.hasError) {
              return Text('Error: ${futureSnapshot.error}');
            }

            // else, condition to validate that we received the expected data from the external API
            if ( futureSnapshot.data==null || !futureSnapshot.data!.containsKey("countryCode") ) {
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
                    children: const <Widget>[
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
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: formVerticalPadding, horizontal: formHorizontalPadding),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 20.0),
                            // - phoneNumber row
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: formWidth,
                                  child: IntlPhoneField(
                                    decoration: const InputDecoration(
                                      labelText: 'Phone Number',
                                    ),
                                    textAlignVertical: TextAlignVertical.center,
                                    // initialCountryCode obtained using _infoByIP
                                    initialCountryCode: futureSnapshot.data!["countryCode"] as String?,
                                    onChanged: (PhoneNumber phone) {
                                      _phoneNumber = phone.number;
                                    },
                                    onCountryChanged: (PhoneNumber phone) {
                                      _phoneCountryDialCode = phone.countryCode!;
                                    },
                                    validator: (String? phoneNumber){
                                      final String? emptyMessage = validateNotEmpty(
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
                                      final List<dynamic> phoneNumberValidationInfo = validatePhoneNumber(
                                        phoneCountryDialCode: _phoneCountryDialCode,
                                        phoneNumber: phoneNumber??'',
                                      );
                                      final bool phoneNumberValidated = phoneNumberValidationInfo[0] as bool;
                                      final String validationMessage = phoneNumberValidationInfo[1] as String;

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
                            if (_spacedFormFields) ... <Widget>[
                              SizedBox(height: defaultFormFieldSpacing)
                            ] else ... const <Widget>[
                              SizedBox(height: 0.0)
                            ],
                            Center(
                              child: Builder(builder: (BuildContext context) {
                                return _loading
                                ? InPlaceLoader(
                                  baseSize: const Size(48.0, 48.0),
                                  correctionSize: Size(defaultSubmissionErrorHeight*2, defaultSubmissionErrorHeight*2),
                                  padding: EdgeInsets.only(top: defaultSubmissionErrorHeight),
                                )
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
                                    children: const <Widget>[
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
                              style: const TextStyle(
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
                        const Text("Want to switch account?"),
                        TextButton(
                          onPressed: () async {
                            await AuthService.signOut(context: context);
                            Navigator.pushReplacementNamed(context, '/');
                          },
                          child: const Text(
                            "Sign out",
                            style: TextStyle(color: Colors.blue),
                          ),
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
}
