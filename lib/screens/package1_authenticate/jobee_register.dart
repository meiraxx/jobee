import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/services.dart' show TextInput;
import 'package:jobee/screens/shared_screens/logo.dart' show Logo;
import 'package:jobee/services/auth.dart' show AuthService;
import 'package:jobee/widgets/widget_utils/app_bar_button.dart' show appBarButton;
import 'package:jobee/widgets/loaders/in_place_loader.dart' show InPlaceLoader;
import 'package:jobee/utils/input_field_validation.dart' show validateNotEmpty, validatePassword;

class RegMailPassword extends StatefulWidget {
  final Function toggleView;

  const RegMailPassword({ required this.toggleView });

  @override
  _RegMailPasswordState createState() => _RegMailPasswordState();
}

class _RegMailPasswordState extends State<RegMailPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  // text field state
  String _email = '';
  String _password = '';
  final int _passwordMinLength = 8;

  // error state
  double _errorSizedBoxHeightEmail = 0.0;
  double _errorSizedBoxHeightPassword = 0.0;
  double _errorSizedBoxHeightConfirmPassword = 0.0;

  String _submissionError = '';
  double _submissionErrorSizedBoxHeight = 0.0;

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
          leading: appBarButton(context: context, iconData: Icons.arrow_back, onPressedFunction: () {
            Navigator.pushReplacementNamed(context, '/');
          }),
          title: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: const <Widget>[
              Logo(),
              SizedBox(width: 16.0),
              Text(
                "|   Register",
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
                        decoration: const InputDecoration(labelText: 'Email'),
                        textAlignVertical: TextAlignVertical.center,
                        autofillHints: const <String>[AutofillHints.email],
                        keyboardType: TextInputType.emailAddress,
                        validator: (String? emailVal) {
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
                        // cleanse errors by rebuilding widget on... :
                        onTap: () {
                          setState(() {});
                        },
                        onChanged: (String emailVal) {
                          setState(() => _email = emailVal);
                        },
                      ),
                      SizedBox(height: _errorSizedBoxHeightEmail),
                      SizedBox(height: defaultFormFieldSpacing),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          counterText: (_password.length<_passwordMinLength) ? "${_password.length} / $_passwordMinLength characters required minimum" : '',
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
                        textAlignVertical: TextAlignVertical.center,
                        autofillHints: const <String>[AutofillHints.password],
                        keyboardType: TextInputType.text,
                        onEditingComplete: () => TextInput.finishAutofillContext(),
                        obscureText: !_passwordVisible,
                        validator: (String? passwordVal) {
                          final String? passwordCheck = validatePassword(
                            password: passwordVal!,
                            minLength: _passwordMinLength,
                            successFunction: () {
                              setState(() => _errorSizedBoxHeightPassword = defaultFormFieldSpacing);
                            },
                            errorFunction: () {
                              setState(() => _errorSizedBoxHeightPassword = 0.0);
                            },
                          );

                          // if the password does not check the requirements
                          if (passwordCheck!=null) return passwordCheck;
                        },
                        // cleanse errors by rebuilding widget on... :
                        onTap: () {
                          setState(() {});
                        },
                        onChanged: (String passwordVal) {
                          setState(() => _password = passwordVal);
                        },
                      ),
                      SizedBox(height: _errorSizedBoxHeightPassword),
                      SizedBox(height: defaultFormFieldSpacing),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              _confirmPasswordVisible?Icons.visibility:Icons.visibility_off,
                            ),
                            onPressed: () {
                              // Update the state, i.e., toggle the state of _confirmPasswordVisible variable
                              setState(() => _confirmPasswordVisible = !_confirmPasswordVisible);
                            },
                          ),
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        autofillHints: const <String>[AutofillHints.password],
                        keyboardType: TextInputType.text,
                        obscureText: !_confirmPasswordVisible,
                        validator: (String? confirmPasswordVal) {
                          /* simply need to check if it's equal to the password */
                          if (_password!=confirmPasswordVal) {
                            setState(() => _errorSizedBoxHeightConfirmPassword = defaultFormFieldSpacing);
                            return "Passwords do not match";
                          } else {
                            setState(() => _errorSizedBoxHeightConfirmPassword = 0.0);
                            return null;
                          }
                        },
                        // cleanse errors by rebuilding widget on... :
                        onTap: () {
                          setState(() {});
                        },
                        onChanged: (String confirmPasswordVal) {
                          setState(() {});
                        },
                      ),
                      SizedBox(height: _errorSizedBoxHeightConfirmPassword),
                      SizedBox(height: defaultFormFieldSpacing),
                      Builder(builder: (BuildContext context) {
                        return _loading ? InPlaceLoader(
                            baseSize: const Size(48.0, 48.0),
                            correctionSize: Size(defaultSubmissionErrorHeight*2, defaultSubmissionErrorHeight*2),
                            padding: EdgeInsets.only(top: defaultSubmissionErrorHeight),
                          )
                        : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // while registering, set _loading to true
                              _loading = true;
                              _submissionErrorSizedBoxHeight = defaultFormFieldSpacing;
                              if (this.mounted) setState(() {});

                              await InPlaceLoader.extendLoadingDuration(const Duration(seconds: 1));
                              try {
                                await AuthService.registerWithEmailAndPassword(_email, _password);
                              } on FirebaseAuthException catch (e) {
                                _submissionError = e.message!;
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
                              Icon(Icons.person),
                              SizedBox(width: 4.0),
                              Text('Register'),
                            ],
                          ),
                        );
                      }),
                      SizedBox(height: _submissionErrorSizedBoxHeight),
                      Text(
                        _submissionError,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      )
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
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      widget.toggleView();
                    },
                    child: const Text(
                      "Sign in",
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
