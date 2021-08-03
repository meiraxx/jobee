import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/services.dart' show TextInput;
import 'package:jobee/screens/screen00_wrapper/0.0_auth_wrapper.dart' show AuthWrapper;
import 'package:jobee/screens/theme/navigation.dart' show slideFromRightNavigatorPush;
import 'package:jobee/services/service00_authentication/0.1_email_password_auth.dart' show EmailPasswordAuthService;
import 'package:jobee/screens/widgets/jobee/logo.dart' show Logo;
import 'package:jobee/screens/widgets/buttons/app_bar_button.dart' show appBarButton;
import 'package:jobee/screens/widgets/loaders/in_place_loader.dart' show InPlaceLoader;
import 'package:jobee/utils/input_field_validation.dart' show validateNotEmpty;

class MailPasswordLoginScreen extends StatefulWidget {
  final void Function() toggleAuthViewCallback;

  const MailPasswordLoginScreen({ required this.toggleAuthViewCallback });

  @override
  _MailPasswordLoginScreenState createState() => _MailPasswordLoginScreenState();
}

class _MailPasswordLoginScreenState extends State<MailPasswordLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _passwordVisible = false;

  // text field state
  String _email = '';
  String _password = '';

  // error state
  double _errorSizedBoxHeightEmail = 0.0;
  double _errorSizedBoxHeightPassword = 0.0;
  String _submissionError = '';
  double _submissionErrorSizedBoxHeight = 0.0;

  // Out-callable setState function
  void updateWidgetState() {
    if (this.mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // form info
    final double defaultFormFieldSpacing = Theme.of(context).textTheme.caption!.fontSize!;
    final double defaultSubmissionErrorHeight = defaultFormFieldSpacing/2;

    return GestureDetector(
      onTap: () {
        // removes focus from focused node when the AppBar or Scaffold are touched
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: appBarButton(context: context, iconData: Icons.arrow_back, onClicked: () {
            slideFromRightNavigatorPush(context, const AuthWrapper());
          }),
          title: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Logo(updateWidgetStateCallback: this.updateWidgetState, defaultLogoColor: Theme.of(context).colorScheme.onPrimary),
              const SizedBox(width: 16.0),
              const Text(
                "|   Sign in",
              )
            ],
          )
        ),
        body: AutofillGroup(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Email",
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        autofillHints: const <String>[AutofillHints.email],
                        keyboardType: TextInputType.emailAddress,
                        validator: (String? emailVal) {
                          setState(() => _errorSizedBoxHeightEmail = defaultFormFieldSpacing);
                          return validateNotEmpty(
                            text: emailVal!,
                            field: 'Email',
                            errorMessage: "Enter your email",
                            successFunction: () {
                              setState(() => _errorSizedBoxHeightEmail = defaultFormFieldSpacing);
                            },
                            errorFunction: () {
                              setState(() => _errorSizedBoxHeightEmail = 0.0);
                            },
                          );
                        },
                        onChanged: (String emailVal) { setState(() => _email = emailVal); },
                      ),
                      SizedBox(height: _errorSizedBoxHeightEmail),
                      SizedBox(height: defaultFormFieldSpacing),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible?Icons.visibility:Icons.visibility_off,
                            ),
                            onPressed: () {
                              // Update the state, i.e., toggle the state of _passwordVisible variable
                              setState(() => _passwordVisible = !_passwordVisible);
                            },
                          ),
                        ),
                        obscureText: !_passwordVisible,
                        textAlignVertical: TextAlignVertical.center,
                        autofillHints: const <String>[AutofillHints.password],
                        keyboardType: TextInputType.text,
                        onEditingComplete: () => TextInput.finishAutofillContext(),
                        validator: (String? passwordVal) {
                          return validateNotEmpty(
                            text: passwordVal!,
                            field: 'Password',
                            errorMessage: "Enter your password",
                            successFunction: () {
                              setState(() => _errorSizedBoxHeightPassword = defaultFormFieldSpacing);
                            },
                            errorFunction: () {
                              setState(() => _errorSizedBoxHeightPassword = 0.0);
                            },
                          );
                        },
                        onChanged: (String passwordVal) { setState(() => _password = passwordVal); },
                      ),
                      SizedBox(height: _errorSizedBoxHeightPassword),
                      SizedBox(height: defaultFormFieldSpacing),
                      Builder(
                        builder: (BuildContext context) {
                          return _loading
                          ? InPlaceLoader(
                            baseSize: const Size(48.0, 48.0),
                            correctionSize: Size(defaultSubmissionErrorHeight*2, defaultSubmissionErrorHeight*2),
                            padding: EdgeInsets.only(top: defaultSubmissionErrorHeight),
                          )
                          : ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // while logging in, set _loading to true
                                _loading = true;
                                _submissionErrorSizedBoxHeight = defaultFormFieldSpacing;
                                if (this.mounted) setState(() {});

                                await InPlaceLoader.extendLoadingDuration(const Duration(seconds: 1));
                                try {
                                  await EmailPasswordAuthService.loginWithEmailAndPassword(_email, _password);
                                } on FirebaseAuthException catch (e) {
                                  if (e.message == "The email address is badly formatted.") {
                                    _submissionError = e.message!;
                                  } else {
                                    // This ELSE condition merges two conditions, for security reasons:
                                    // 1 - e.message == "There is no user record corresponding to this identifier. The user may have been deleted."
                                    // 2 - e.message == "The password is invalid or the user does not have a password."
                                    _submissionError = 'The email and/or password provided are incorrect.';
                                  }
                                  _submissionErrorSizedBoxHeight = defaultSubmissionErrorHeight;
                                  // if there was an error, set _loading back to false
                                  _loading = false;
                                  if (this.mounted) setState(() {});
                                }
                              }
                            },
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: const <Widget>[
                                Icon(Icons.login),
                                SizedBox(width: 4.0),
                                Text("Sign in"),
                              ],
                            ),
                          );
                        }
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const Text("Still don't have an account?"),
                  TextButton(
                    onPressed: () {
                      widget.toggleAuthViewCallback();
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


