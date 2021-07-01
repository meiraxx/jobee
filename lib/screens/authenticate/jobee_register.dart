import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobee/screens/screens-shared/logo.dart';
import 'package:jobee/services/auth.dart';
import 'package:jobee/shared/constants.dart';

class RegMailPassword extends StatefulWidget {
  final Function toggleView;

  RegMailPassword({ required this.toggleView });

  @override
  _RegMailPasswordState createState() => _RegMailPasswordState();
}

class _RegMailPasswordState extends State<RegMailPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;

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
          leading: appBarButton(iconData: Icons.arrow_back, color: Theme.of(context).colorScheme.onBackground, onPressedFunction: () {
            Navigator.pushReplacementNamed(context, '/');
          }),
          elevation: 1.0,
          title: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Logo(),
              SizedBox(width: 16.0),
              Text(
                "|   Register",
              )
            ],
          )
        ),
        body: Column(
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
                      decoration: InputDecoration(labelText: 'Email'),
                      textAlignVertical: TextAlignVertical.bottom,
                      validator: (val) {
                        if (val!.isEmpty) {
                          setState(() {
                            _errorSizedBoxHeightEmail = 0.0;
                          });
                          return "Enter your email";
                        } else {
                          setState(() {
                            _errorSizedBoxHeightEmail = defaultFormFieldSpacing;
                          });
                          return null;
                        }
                      },
                      onChanged: (val) { setState(() => _email = val); },
                    ),
                    SizedBox(height: _errorSizedBoxHeightEmail),
                    SizedBox(height: defaultFormFieldSpacing),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      textAlignVertical: TextAlignVertical.bottom,
                      obscureText: true,
                      validator: (val) {
                        if (val!.length < 8) {
                          setState(() {
                            _errorSizedBoxHeightPassword = 0.0;
                          });
                          return "Enter a password with at least 8 characters";
                        } else {
                          setState(() {
                            _errorSizedBoxHeightPassword = defaultFormFieldSpacing;
                          });
                          return null;
                        }
                      },
                      onChanged: (val) { setState(() => _password = val); },
                    ),
                    SizedBox(height: _errorSizedBoxHeightPassword),
                    SizedBox(height: defaultFormFieldSpacing),
                    Builder(builder: (BuildContext context) {
                      return _loading ? InPlaceLoader(replacedWidgetSize: Size(48.0, 48.0), submissionErrorHeight: defaultSubmissionErrorHeight)
                      : ElevatedButton(
                        style: orangeElevatedButtonStyle,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 4.0),
                            Text('Register'),
                          ],
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              // while registering, set _loading to true
                              _loading = true;
                              _submissionErrorSizedBoxHeight = defaultFormFieldSpacing;
                            });
                            await InPlaceLoader.minimumLoadingSleep(const Duration(seconds: 1));
                            try {
                              await AuthService.registerWithEmailAndPassword(_email, _password);
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                _submissionError = e.message!;
                                _submissionErrorSizedBoxHeight = defaultSubmissionErrorHeight;
                                // if there was an error, set _loading back to false
                                _loading = false;
                              });
                            }
                          }
                        },
                      );
                    }),
                    SizedBox(height: _submissionErrorSizedBoxHeight),
                    Text(
                      _submissionError,
                      style: TextStyle(
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
                Text("Already have an account?"),
                TextButton(
                  style: ButtonStyle( overlayColor: MaterialStateProperty.all(Colors.transparent) ),
                  child: Text(
                    "Sign in",
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
    );
  }
}
