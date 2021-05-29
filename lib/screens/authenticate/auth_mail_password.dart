import 'package:flutter/material.dart';
import 'package:jobee/services/auth.dart';
import 'package:jobee/shared/constants.dart';
import 'package:jobee/shared/loading.dart';

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
      // in case we want to extend background image to
      // the AppBar
      //extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.amber[600],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Sign in to Jobee",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: Text(
              "Register",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () {
              widget.toggleView();
            },
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Container(
          // setting BackGround Image
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/net-honeycomb-pattern.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
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
                                (Set<MaterialState> states) => Colors.pinkAccent)
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() => loading = true);
                        dynamic result = await _auth.loginWithEmailAndPassword(email, password);
                        if (result==null) {
                          setState(() {
                            error = 'The email or password provided is incorrect.';
                            loading = false;
                          });
                        }
                      }
                    },
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


