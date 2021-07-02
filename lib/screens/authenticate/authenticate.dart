import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobee/screens/authenticate/jobee_register.dart';
import 'package:jobee/screens/authenticate/jobee_login.dart';
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
    // constants
    const double paddingLeft = 20.0;
    const double orSeparationWidth = 3.0;
    final Color? orRectangleColor = Colors.grey[600];
    // query data
    MediaQueryData queryData = MediaQuery.of(context);

    if (showSignIn != null) {
      return (showSignIn!)?AuthMailPassword(toggleView: toggleView):RegMailPassword(toggleView: toggleView);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            // - Guy Call Image
            Container(
              color: lightPaletteColors["cream"],
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
              padding: const EdgeInsets.only(left: paddingLeft),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // - Join Text
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "Join our community to",
                        style: GoogleFonts.roboto().copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          color: Colors.black
                        ),
                      ),
                      Text(
                        "start providing and hiring services in your area.",
                        style: GoogleFonts.roboto().copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                            color: Colors.black
                        ),
                      ),
                    ],
                  ),
                  //SizedBox(height: 74.0),
                ],
              ),
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
                overlayColor: MaterialStateProperty.all(lightPaletteColors["yellow"]!.withAlpha(0x5F)),
                highlightColor: lightPaletteColors["yellow"]!.withAlpha(0x5F),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: lightPaletteColors["crispYellow"],
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(4.0, 4.0, 10.0, 4.0),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 32.0,
                          height: 32.0,
                          child: Container(
                            padding: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: Colors.white,
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
                          "Create ",
                          style: GoogleFonts.montserrat(
                            //fontFamily: Theme.of(context).textTheme.button!.fontFamily,
                            fontSize: Theme.of(context).textTheme.button!.fontSize,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).textTheme.button!.color,
                          ),
                        ),
                        Text(
                          "jobee",
                          style: GoogleFonts.museoModerno().copyWith(
                            fontSize: Theme.of(context).textTheme.button!.fontSize,
                            color: Theme.of(context).textTheme.button!.color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          " account",
                          style: GoogleFonts.montserrat(
                            //fontFamily: Theme.of(context).textTheme.button!.fontFamily,
                            fontSize: Theme.of(context).textTheme.button!.fontSize,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).textTheme.button!.color,
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
              children: <Widget>[
                SizedBox(width: paddingLeft),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                    ),
                    child: Container(
                      height: 1.0,
                      decoration: new BoxDecoration(
                        color: orRectangleColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: orSeparationWidth),
                Center(
                  child: Text(
                    "OR",
                    style: TextStyle(
                      color: orRectangleColor,
                    ),
                  ),
                ),
                SizedBox(width: orSeparationWidth),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                    ),
                    child: Container(
                      height: 1.0,
                      decoration: new BoxDecoration(
                        color: orRectangleColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: paddingLeft),
              ],
            ),
            SizedBox(height: 24.0),
            // - Google Sign In
            Center(
              child: GoogleSignInButton(),
            ),
            Expanded(
              child: Container(),
            ),
            // - Sign In Text
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
                    setState(() => showSignIn = true);
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
