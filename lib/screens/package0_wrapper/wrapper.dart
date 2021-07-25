import 'package:flutter/material.dart';
import 'package:jobee/models/app_user.dart' show AppUser, AppUserData;
import 'package:jobee/screens/package0_wrapper/load_user_resources.dart' show LoadUserResources;
import 'package:jobee/screens/package1_authenticate/authenticate.dart' show Authenticate;
import 'package:jobee/services/database.dart' show DatabaseService;
import 'package:provider/provider.dart' show Provider, StreamProvider;

class Wrapper extends StatelessWidget {

  const Wrapper();

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
      final DatabaseService userDatabaseService = DatabaseService(uid: appUser.uid, email: appUser.email);

      return StreamProvider<AppUserData>.value(
        initialData: userDatabaseService.initialAppUserData,
        value: userDatabaseService.appUserData,
        child: const LoadUserResources(),
      );
    }
  }

}