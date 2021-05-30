import 'package:flutter/material.dart';
import 'package:jobee/services/auth.dart';
import 'package:jobee/shared/constants.dart';
import 'package:jobee/shared/loading.dart';
import 'authenticate.dart';

class AuthMailPassword extends StatefulWidget {
  final Function toggleView;

  AuthMailPassword({ this.toggleView });

  @override
  _AuthMailPasswordState createState() => _AuthMailPasswordState();
}

class _AuthMailPasswordState extends State<AuthMailPassword> {

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          splashColor: paletteColors["orange"].withAlpha(0x5F),
          highlightColor: paletteColors["orange"].withAlpha(0x5F),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/authenticate');
          },
        ),
        backgroundColor: paletteColors["cream"],
        elevation: 1.0,
        title: Text(
          "Sign in to Jobee",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          appBarTextIcon("Register", Icons.person, Colors.black, () {
            widget.toggleView();
          }),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (val) => val.isEmpty ? "Enter an email" : null,
                onChanged: (val) { setState(() => email = val); },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                obscureText: true,
                validator: (val) => val.length <= 6
                    ?"Enter a password with more than 6 characters"
                    :null,
                onChanged: (val) { setState(() => password = val); },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) => Colors.orange),
                  overlayColor: MaterialStateProperty.all(paletteColors["yellow1"].withAlpha(0x5F))
                ),
                child: Text(
                  'Log In',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    setState(() => loading = true);
                    dynamic result = await _auth.loginWithEmailAndPassword(email, password);
                    if (result==null) {
                      setState(() {
                        error = 'The email and/or password provided are incorrect.';
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
    );
  }
}


