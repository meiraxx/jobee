import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  double errorSizedBoxHeight1 = 20.0;
  double errorSizedBoxHeight2 = 20.0;
  double submissionErrorSizedBoxHeight = 12.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: appBarButton(iconData: Icons.arrow_back, color: Colors.black, onPressedFunction: () {
          Navigator.pushReplacementNamed(context, '/authenticate');
        }),
        elevation: 1.0,
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              "Register to  ",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            Text(
              "jobee",
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
                    decoration: InputDecoration(labelText: 'Email'),
                    textAlignVertical: TextAlignVertical.bottom,
                    validator: (val) {
                      if (val!.isEmpty) {
                        setState(() {
                          errorSizedBoxHeight1 = 9.0;
                        });
                        return "Enter your email";
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
                    decoration: InputDecoration(labelText: 'Password'),
                    textAlignVertical: TextAlignVertical.bottom,
                    cursorColor: lightPaletteColors["crispYellow"],
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
                  Builder(builder: (BuildContext context) {
                    return loading ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(lightPaletteColors["crispYellow"]!),
                    )
                    : ElevatedButton(
                      style: orangeElevatedButtonStyle,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Image.asset(
                            "images/bee-logo-07.png",
                            semanticLabel: "Jobee logo",
                            width: 20.0, // default icon width
                            height: 20.0, // default icon height
                            color: Colors.white,
                          ),
                          SizedBox(width: 2.0),
                          Text(
                            'Register',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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
          SizedBox(height: 260.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                "Already have an account?",
                style: TextStyle(color: Colors.black),
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
