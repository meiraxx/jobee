import 'package:flutter/material.dart';
import 'package:jobee/models/app_user.dart' show AppUser;
import 'package:jobee/screens/package1_authenticate/1.0_authenticate.dart' show Authenticate;
import 'package:jobee/screens/package2_after_auth/2.0_app_user_data_builder.dart' show AppUserDataBuilder;
import 'package:jobee/services/database.dart' show DatabaseService;
import 'package:provider/provider.dart' show Provider;

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    /// Choose between Authenticate or Home widget
    ///
    /// @param context BuildContext object.
    /// @returns either the Authenticate() or the Home() screen.
    final AppUser? appUser = Provider.of<AppUser?>(context);
    // maintain user in the authentication part of the app tree while login is not performed
    if (appUser == null) {
      return const Authenticate();
    }
    // when login is performed, allows access to the app
    else {
      return AppUserDataBuilder(userDatabaseService: DatabaseService(uid: appUser.uid, email: appUser.email));
    }
  }
}
