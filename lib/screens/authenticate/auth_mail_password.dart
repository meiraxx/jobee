import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobee/services/auth.dart';
import 'package:jobee/shared/constants.dart';

class AuthMailPassword extends StatefulWidget {
  final Function toggleView;

  AuthMailPassword({ required this.toggleView });

  @override
  _AuthMailPasswordState createState() => _AuthMailPasswordState();
}

class _AuthMailPasswordState extends State<AuthMailPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  // error state
  String error = '';
  double errorSizedBoxHeight1 = 20.0;
  double errorSizedBoxHeight2 = 20.0;
  double errorSizedBoxHeight3 = 12.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: paletteColors["cream"],
      appBar: AppBar(
        leading: appBarButton(iconData: Icons.arrow_back, color: Colors.black, onPressedFunction: () {
          Navigator.pushReplacementNamed(context, '/authenticate');
        }),
        backgroundColor: paletteColors["cream"],
        elevation: 1.0,
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              "Sign in to ",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            Text(
              " jobee",
              style: GoogleFonts.museoModerno().copyWith(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700
              ),
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
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                    validator: (val) {
                      if (val!.isEmpty) {
                        setState(() {
                          errorSizedBoxHeight1 = 9.0;
                        });
                        return "Enter an email";
                      } else {
                        setState(() {
                          errorSizedBoxHeight1 = 20.0;
                        });
                        return null;
                      }
                    },
                    onChanged: (val) { setState(() => email = val); },
                  ),
                  SizedBox(height: errorSizedBoxHeight1),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Password'),
                    obscureText: true,
                    validator: (val) {
                      if (val!.length < 8) {
                        setState(() {
                          errorSizedBoxHeight2 = 9.0;
                        });
                        return "Enter a password with at least 8 characters";
                      } else {
                        setState(() {
                          errorSizedBoxHeight2 = 20.0;
                        });
                        return null;
                      }
                    },
                    onChanged: (val) { setState(() => password = val); },
                  ),
                  SizedBox(height: errorSizedBoxHeight2),
                  Builder(
                    builder: (BuildContext context) {
                      return loading ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(paletteColors["orange"]!),
                      )
                      : ElevatedButton(
                        style: orangeElevatedButtonStyle,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Icon(Icons.login),
                            SizedBox(width: 2.0),
                            Text(
                              'Login',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // while logging in, set loading to true
                            setState(() => loading = true);
                            try {
                              await AuthService.loginWithEmailAndPassword(email, password);
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                if (e.message == "The email address is badly formatted.") {
                                  error = e.message!;
                                } else {
                                  // This ELSE condition merges two conditions, for security reasons:
                                  // 1 - e.message == "There is no user record corresponding to this identifier. The user may have been deleted."
                                  // 2 - e.message == "The password is invalid or the user does not have a password."
                                  error = 'The email and/or password provided are incorrect.';
                                }
                                errorSizedBoxHeight3 = 0.0;
                              });
                            }
                            // after everything is done, set loading back to false
                            setState(() => loading = false);
                          }
                        },
                      );
                    }
                  ),
                  SizedBox(height: errorSizedBoxHeight3),
                  Text(
                    error,
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 260.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                "Still don't have an account?",
                style: TextStyle(color: Colors.black),
              ),
              TextButton(
                style: ButtonStyle( overlayColor: MaterialStateProperty.all(Colors.transparent) ),
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
    );
  }
}


