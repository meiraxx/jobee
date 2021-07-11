import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/services.dart' show TextInput;
import 'package:jobee/screens/screens-shared/logo.dart' show Logo;
import 'package:jobee/services/auth.dart' show AuthService;
import 'package:jobee/shared/global_constants.dart' show appBarButton;
import 'package:jobee/widgets/loaders.dart' show InPlaceLoader;
import 'package:jobee/utils/input_field_utils.dart' show validateNotEmpty;

class AuthMailPassword extends StatefulWidget {
  final Function toggleView;

  AuthMailPassword({ required this.toggleView });

  @override
  _AuthMailPasswordState createState() => _AuthMailPasswordState();
}

class _AuthMailPasswordState extends State<AuthMailPassword> {
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

  @override
  Widget build(BuildContext context) {
    // form info
    final double defaultFormFieldSpacing = Theme.of(context).textTheme.caption!.fontSize!;
    final double defaultSubmissionErrorHeight = defaultFormFieldSpacing/2;

    return GestureDetector(
      onTap: () {
        /* removes focus from focused node when
            * the AppBar or Scaffold are touched */
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: appBarButton(context: context, iconData: Icons.arrow_back, onPressedFunction: () {
            Navigator.pushReplacementNamed(context, '/');
          }),
          title: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Logo(),
              SizedBox(width: 16.0),
              Text(
                "|   Sign in",
              )
            ],
          )
        ),
        body: AutofillGroup(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email",
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        autofillHints: [AutofillHints.email],
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
                        autofillHints: [AutofillHints.password],
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
                          return _loading ? InPlaceLoader(replacedWidgetSize: Size(48.0, 48.0), submissionErrorHeight: defaultSubmissionErrorHeight)
                          : ElevatedButton(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Icon(Icons.login),
                                SizedBox(width: 4.0),
                                Text("Sign in"),
                              ],
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // while logging in, set _loading to true
                                _loading = true;
                                _submissionErrorSizedBoxHeight = defaultFormFieldSpacing;
                                if (this.mounted) setState(() {});

                                await InPlaceLoader.minimumLoadingSleep(const Duration(seconds: 1));
                                try {
                                  await AuthService.loginWithEmailAndPassword(_email, _password);
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
                          );
                        }
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text("Still don't have an account?"),
                  TextButton(
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      widget.toggleView();
                    },
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


