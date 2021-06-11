import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          setState(() => _isSigningIn = true );
          
          AppUser? appUser = await AuthService.signInWithGoogle(context: context);

          // if the user does not exist yet, we need to create
          // a new document for the user with the returned uid
          await DatabaseService(uid: appUser!.uid).createUserData(appUser.email, 'Google');
        } catch(e){
          setState(() => _isSigningIn = false );
          print(e);
        }
      },
      overlayColor: MaterialStateProperty.all(Colors.lightBlueAccent.withAlpha(0x5F)),
      highlightColor: Colors.lightBlueAccent.withAlpha(0x5F),
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
                  ),
                ),
              ),
              SizedBox(width: 12.0),
              Text(
                "Sign in with Google",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600
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