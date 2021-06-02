import 'package:flutter/material.dart';
import 'package:jobee/screens/authenticate/reg_mail_password.dart';
import 'package:jobee/screens/authenticate/auth_mail_password.dart';
import 'package:jobee/shared/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool? showSignIn;

  void toggleView() {
    print(showSignIn);
    setState( () => showSignIn = !(showSignIn!) );
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(
      AssetImage("images/higher-quality/dude-call.png"),
      context,
      size: Size(
        MediaQuery.of(context).size.width,
        232
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    const double paddingLeft1 = 20.0;
    const double paddingTop1 = 0.0;
    const double paddingRight1 = 0.0;
    const double paddingBottom1 = 0.0;
    MediaQueryData queryData = MediaQuery.of(context);
    final Color? orRectangleColor = Colors.grey[600];
    GoogleSignInAccount? _currentUser;

    if (showSignIn != null) {
      return (showSignIn!)?AuthMailPassword(toggleView: toggleView):RegMailPassword(toggleView: toggleView);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: paletteColors["cream"],
      body: SafeArea(
        child: Column(
          children: [
            // - Guy Call Image
            Container(
              color: paletteColors["cream"],
              child: Image.asset(
                "images/higher-quality/dude-call.png",
                semanticLabel: "Businessman negotiating with a client",
                width: queryData.size.width,
                height: 232,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.fromLTRB(paddingLeft1, paddingTop1, paddingRight1, paddingBottom1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // - Join Text
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "Join our community to",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                            color: Colors.black
                        ),
                      ),
                      Text(
                        "start providing and/or hiring services in your area.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                            color: Colors.black
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.0),
                  // - Create account Button
                  Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          setState(() => showSignIn = false);
                        });
                      },
                      overlayColor: MaterialStateProperty.all(paletteColors["yellow1"]!.withAlpha(0x5F)),
                      highlightColor: paletteColors["yellow1"]!.withAlpha(0x5F),
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: paletteColors["orange"],
                          /*boxShadow: [
                            BoxShadow(color: Colors.grey[400], spreadRadius: 0.20, blurRadius: 0.0001),
                          ],*/
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(4.0, 4.0, 10.0, 4.0),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 30.0,
                                height: 30.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.0),
                                    color: Colors.transparent,
                                  ),
                                  child: Image.asset(
                                    "images/bee-logo-07.png",
                                    semanticLabel: "Jobee app logo",
                                    width: 24.0, // default icon width
                                    height: 24.0, // default icon height
                                    //fit: BoxFit.scaleDown,
                                    //alignment: FractionalOffset.center,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.0),
                              Text(
                                "Create account",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // - OR Rectangle
                  Row(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                        ),
                        child: Container(
                          width: queryData.size.width/2 - paddingLeft1,
                          height: 2.0,
                          decoration: new BoxDecoration(
                            color: orRectangleColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.0),
                      Center(
                        child: Text(
                          "OR",
                          style: TextStyle(
                            color: orRectangleColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.0),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                        ),
                        child: Container(
                          width: queryData.size.width/2 - paddingLeft1*2,
                          height: 2.0,
                          decoration: new BoxDecoration(
                            color: orRectangleColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.0),
                  // - Google Sign In
                  Center(
                    child: InkWell(
                      onTap: () {
                        _handleSignIn();
                      },
                      overlayColor: MaterialStateProperty.all(Colors.lightBlueAccent.withAlpha(0x5F)),
                      highlightColor: Colors.lightBlueAccent.withAlpha(0x5F),
                      child: Ink(
                        //color: Color(0xFF397AF3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: Color(0xFF397AF3),
                          /*boxShadow: [
                            BoxShadow(color: Colors.grey[400], spreadRadius: 0.20, blurRadius: 0.0001),
                          ],*/
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(4.0, 4.0, 10.0, 4.0),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 30.0,
                                height: 30.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.0),
                                    color: Colors.white,
                                  ),
                                  child: Image.asset(
                                    "images/google-logo-1080x1080.png",
                                    semanticLabel: "Google logo",
                                    width: 24.0, // default icon width
                                    height: 24.0, // default icon height
                                    //fit: BoxFit.scaleDown,
                                    //alignment: FractionalOffset.center,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.0),
                              Text(
                                "Sign In with your Google account",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 77.0),
                  // - Sign In Text
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
                          print("HI!2");
                          setState(() => showSignIn = true);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
