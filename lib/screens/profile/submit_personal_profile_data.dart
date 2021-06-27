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
import 'package:jobee/shared/constants.dart';
import 'package:jobee/utils/input_field_utils.dart';
import 'package:jobee/shared/loading.dart';
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

  // error state
  String _error = '';
  double _errorSizedBoxSizePhoneNumber = 0.0;

  // error state - field padding correction
  final bool _spacedFormFields = true;

  // user info
  Future<Map<String, dynamic>> _infoByIP = Network.getInfoByIP() as Future<Map<String, dynamic>>;

  /*
    TextFormField(
      controller: _phoneNumberController,
      decoration: InputDecoration(
        labelText: "Phone Number",
        errorText: validateNotEmpty(
            text: _phoneNumberController.text,
            field: 'phoneNumber',
            fieldErrorMap: {'phoneNumber': 'Enter your phone number'},
            formNotSubmitted: _formNotSubmitted,
            successFunction: () {
              _errorSizedBoxSizePhoneNumber = defaultFormFieldSpacing;
            },
            errorFunction: () {
              _errorSizedBoxSizePhoneNumber = 0.0;
            },
            currentlyFocusedField: _currentlyFocusedField
        ),
      ),
      textAlignVertical: TextAlignVertical.bottom,
      onTap: () {
        setState((){
          _currentlyFocusedField = 'phoneNumber';
        });
      },
    )
  */

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    // form info
    final double defaultFormFieldSpacing = Theme.of(context).textTheme.caption!.fontSize!;
    const double formVerticalPadding = 20.0;
    const double formHorizontalPadding = 30.0;
    double formWidth = (queryData.size.width - formHorizontalPadding*2);
    double formHeight = (queryData.size.height - formVerticalPadding*2);

    AppUserData appUserData = Provider.of<AppUserData>(context);

    return appUserData.hasRegisteredPersonalData
    ?Home()
    :StreamBuilder<AppUserData>(
      stream: DatabaseService(
        uid: appUserData.uid,
      ).appUserData,
      builder: (BuildContext context, AsyncSnapshot<AppUserData> streamSnapshot) {
        if (!streamSnapshot.hasData) {
          return Loading();
        }

        return FutureBuilder<Map<String, dynamic>>(
          future: _infoByIP,
          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> futureSnapshot) {
            switch (futureSnapshot.connectionState) {
              case ConnectionState.none: return Text('ConnectionState.none is not reached.');
              case ConnectionState.waiting: return Loading();
              default:
                if (futureSnapshot.hasError)
                  return Text('Error: ${futureSnapshot.error}');
                else {
                  // condition to validate that we received the expected data
                  if ( futureSnapshot.data==null || !(futureSnapshot.data!.containsKey("countryCode")) ) {
                    // return to wrapper to retry connection
                    return Wrapper();
                  }
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
                        elevation: 1.0,
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
                                            // need 3 lines for big error messages in this particular case
                                            errorMaxLines: 3,
                                          ),
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
                                              fieldErrorMap: {'phoneNumber': "Enter a valid phone number"},
                                              formNotSubmitted: _formNotSubmitted,
                                              currentlyFocusedField: _currentlyFocusedField,
                                              successFunction: () {
                                                _errorSizedBoxSizePhoneNumber = defaultFormFieldSpacing;
                                              },
                                              errorFunction: () {
                                                _errorSizedBoxSizePhoneNumber = 0.0;
                                              },
                                            );

                                            if (emptyMessage == "Enter a valid phone number") {
                                              // empty validation error
                                              return "Enter your phone number";
                                            }

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
                                          ? CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(lightPaletteColors["crispYellow"]!),
                                      )
                                          : ElevatedButton(
                                        style: orangeElevatedButtonStyle,
                                        onPressed: () async {
                                          _formNotSubmitted = false;
                                          if (_formKey.currentState!.validate()) {
                                            // while submitting data, set loading to true
                                            setState(() => _loading = true);
                                            await Future.delayed(const Duration(seconds: 2)); // wait 2 seconds just to present the loading widget, looks neater
                                            await DatabaseService(uid: appUserData.uid).updatePersonalUserData(
                                                hasRegisteredPersonalData: true,
                                                phoneCountryDialCode: _phoneCountryDialCode,
                                                phoneNumber: _phoneNumber
                                            );
                                            // after everything is done, set loading back to false
                                            setState(() => _loading = false);
                                          }
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
                                  SizedBox(height: 12.0),
                                  Text(
                                    _error,
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0
                                    ),
                                  )
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
                              Text(
                                  "Want to switch account?"
                              ),
                              TextButton(
                                style: ButtonStyle( overlayColor: MaterialStateProperty.all(Colors.transparent) ),
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
            }
          }
        );
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
