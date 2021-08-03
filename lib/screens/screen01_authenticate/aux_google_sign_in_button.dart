import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:jobee/services/service00_authentication/aux_app_user.dart' show AppUser;
import 'package:jobee/services/service00_authentication/0.2_google_auth.dart' show GoogleAuthService;
import 'package:jobee/services/service01_database/1.0_database.dart' show DatabaseService;

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    final BorderRadius buttonBorderRadius = BorderRadius.circular(4.0);
    final Widget button = InkWell(
      onTap: () async {
        _isSigningIn = true;
        if (this.mounted) setState(() {});

        final AppUser? appUser = await GoogleAuthService.signInWithGoogle();

        // if the user did not login
        if (appUser==null) {
          _isSigningIn = false;
          // stop loading widget and return
          if (this.mounted) setState((){});
          return;
        }

        // else, if the user logged in:
        // - if the user does not exist yet, we need to create a new document for the user with the returned uid
        await DatabaseService(uid: appUser.uid, email: appUser.email).createUserData('Google');
        // - load image data
      },
      overlayColor: MaterialStateProperty.all(Colors.lightBlueAccent.withAlpha(0x7F)),
      highlightColor: Colors.lightBlueAccent.withAlpha(0x7F),
      borderRadius: buttonBorderRadius,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: buttonBorderRadius,
          color: const Color(0xFF397AF3),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 4.0, 10.0, 4.0),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 32.0,
                height: 32.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: buttonBorderRadius,
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
              const SizedBox(width: 12.0),
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
    ? const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF397AF3)),
    )
    : button;
  }

}