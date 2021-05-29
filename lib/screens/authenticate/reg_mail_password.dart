import 'package:flutter/material.dart';
import 'package:jobee/services/auth.dart';
import 'package:jobee/shared/constants.dart';
import 'package:jobee/shared/loading.dart';

class RegMailPassword extends StatefulWidget {
  final Function toggleView;

  RegMailPassword({ this.toggleView });

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
      //extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.amber[600],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Register to Jobee",
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
              "Login",
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
          padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 50.0),
          // setting BackGround Image
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/net-honeycomb-pattern.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                    validator: (val) => val.isEmpty ? "Enter an e-mail" : null,
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
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
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
