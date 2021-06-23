import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobee/screens/shared/logo.dart';
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
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  // error state
  String submissionError = '';
  double errorSizedBoxHeightEmail = 0.0;
  double errorSizedBoxHeightPassword = 0.0;
  double submissionErrorSizedBoxHeight = 12.0;

  @override
  Widget build(BuildContext context) {
    // form info
    const double defaultFormFieldSpacing = 10.0;
    
    return Scaffold(
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
                          errorSizedBoxHeightEmail = 0.0;
                        });
                        return "Enter your email";
                      } else {
                        setState(() {
                          errorSizedBoxHeightEmail = defaultFormFieldSpacing;
                        });
                        return null;
                      }
                    },
                    onChanged: (val) { setState(() => email = val); },
                  ),
                  SizedBox(height: errorSizedBoxHeightEmail),
                  SizedBox(height: defaultFormFieldSpacing),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    textAlignVertical: TextAlignVertical.bottom,
                    obscureText: true,
                    validator: (val) {
                      if (val!.length < 8) {
                        setState(() {
                          errorSizedBoxHeightPassword = 0.0;
                        });
                        return "Enter a password with at least 8 characters";
                      } else {
                        setState(() {
                          errorSizedBoxHeightEmail = defaultFormFieldSpacing;
                        });
                        return null;
                      }
                    },
                    onChanged: (val) { setState(() => password = val); },
                  ),
                  SizedBox(height: errorSizedBoxHeightPassword),
                  SizedBox(height: defaultFormFieldSpacing),
                  Builder(builder: (BuildContext context) {
                    return loading ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(lightPaletteColors["crispYellow"]!),
                    )
                    : ElevatedButton(
                      style: orangeElevatedButtonStyle,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(Icons.person),
                          SizedBox(width: 4.0),
                          Text(
                            'Register',
                          ),
                        ],
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => loading = true);
                          try {
                            await AuthService.registerWithEmailAndPassword(email, password);
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              submissionError = e.message!;
                              loading = false;
                              submissionErrorSizedBoxHeight = 0.0;
                            });
                          }
                        }
                      },
                    );
                  }),
                  SizedBox(height: submissionErrorSizedBoxHeight),
                  Text(
                    submissionError,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                "Already have an account?",
              ),
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
    );
  }
}
