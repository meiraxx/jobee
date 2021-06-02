import 'package:flutter/material.dart';
import 'package:jobee/services/auth.dart';
import 'package:jobee/shared/constants.dart';
import 'package:jobee/shared/loading.dart';

class RegMailPassword extends StatefulWidget {
  final Function toggleView;

  RegMailPassword({ required this.toggleView });

  @override
  _RegMailPasswordState createState() => _RegMailPasswordState();
}

class _RegMailPasswordState extends State<RegMailPassword> {

  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  // error state
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :
    Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: paletteColors["cream"],
      appBar: AppBar(
        leading: appBarButton(iconData: Icons.arrow_back, color: Colors.black, onPressedFunction: () {
          Navigator.pushReplacementNamed(context, '/authenticate');
        }),
        backgroundColor: paletteColors["cream"],
        elevation: 1.0,
        title: Text(
          "Register to Jobee",
          style: TextStyle(
            color: Colors.black,
          ),
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
                    validator: (val) => val!.isEmpty ? "Enter an e-mail" : null,
                    onChanged: (val) { setState(() => email = val); },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Password'),
                    obscureText: true,
                    validator: (val) => val!.length <= 6
                        ?"Enter a password with more than 6 characters"
                        :null,
                    onChanged: (val) { setState(() => password = val); },
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    style: orangeElevatedButtonStyle,
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => loading = true);
                        dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                        if (result==null) {
                          setState(() {
                            error = 'Please provide a valid email.';
                            loading = false;
                          });
                        }
                      }
                    },
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    error,
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0
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
                  "Sign In",
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
