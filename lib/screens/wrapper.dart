import 'package:flutter/material.dart';
import 'package:jobee/models/app_user.dart';
import 'package:provider/provider.dart';
import 'authenticate/authenticate.dart';
import 'home/home.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    /// Choose between Authenticate or Home widget
    ///
    /// @param context BuildContext object.
    /// @returns either the Authenticate() or the Home() screen.
    final AppUser? user = Provider.of<AppUser?>(context);

    // maintain user in the authentication part of the app tree while login is not performed
    if (user == null) {
      return Authenticate();
    }
    // when login is performed, allows access to the app
    else {
      return Home();
    }
  }
}
