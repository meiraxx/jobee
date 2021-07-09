import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobee/models/app_user.dart';
import 'package:jobee/services/auth.dart';
import 'package:jobee/services/database.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    Widget button = InkWell(
      onTap: () async {
        try {
          _isSigningIn = true;
          if (this.mounted) setState(() {});

          AppUser? appUser = await AuthService.signInWithGoogle(context: context);

          // if the user did not login
          if (appUser==null) {
            _isSigningIn = false;
            // stop loading widget and return
            if (this.mounted) setState((){});
            return;
          }

          // else, if the user logged in:
          // - if the user does not exist yet, we need to create a new document for the user with the returned uid
          await DatabaseService(uid: appUser.uid).createUserData(appUser.email, 'Google');
        } catch(e) {
          // this is usually not reached. if it is, print error to the console
          print("An unknown error on the GoogleSignInButton widget occurred. Error message: '$e'.");
        }
      },
      overlayColor: MaterialStateProperty.all(Colors.lightBlueAccent.withAlpha(0x7F)),
      highlightColor: Colors.lightBlueAccent.withAlpha(0x7F),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Color(0xFF397AF3),
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: Colors.white,
                  ),
                  child: Image.asset(
                    "images/google-logo-1080x1080.png",
                    semanticLabel: "Google logo",
                    width: 24.0, // default icon width
                    height: 24.0, // default icon height
                  ),
                ),
              ),
              SizedBox(width: 12.0),
              Text(
                "Sign in with Google",
                style: GoogleFonts.montserrat(
                  //fontFamily: Theme.of(context).textTheme.button!.fontFamily,
                  fontSize: Theme.of(context).textTheme.button!.fontSize,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return _isSigningIn
    ? CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF397AF3)),
    )
    : button;
  }

}