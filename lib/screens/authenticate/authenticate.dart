import 'package:flutter/material.dart';
import 'package:jobee/screens/authenticate/jobee_register.dart';
import 'package:jobee/screens/authenticate/jobee_authenticate.dart';
import 'package:jobee/shared/constants.dart';
import 'google_sign_in_button.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool? showSignIn;

  void toggleView() {
    setState( () => showSignIn = !(showSignIn!) );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(
      AssetImage("images/dude-call.png"),
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
                "images/dude-call.png",
                semanticLabel: "Businessman negotiating with a client",
                width: queryData.size.width,
                height: 232,
                cacheWidth: 1500,
                cacheHeight: 846,
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
                                    semanticLabel: "Jobee logo",
                                    width: 24.0, // default icon width
                                    height: 24.0, // default icon height
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.0),
                              Text(
                                "Create account",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600
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
                    child: GoogleSignInButton(),
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
                          "Sign in",
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () {
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
