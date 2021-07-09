import 'package:flutter/material.dart';
import 'package:jobee/models/app_user.dart' show AppUser, AppUserData;
import 'package:jobee/screens/profile/submit_public_profile_data.dart' show SubmitPublicProfileData;
import 'package:jobee/services/database.dart' show DatabaseService;
import 'package:provider/provider.dart' show Provider, StreamProvider;
import 'authenticate/authenticate.dart' show Authenticate;

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    /// Choose between Authenticate or Home widget
    ///
    /// @param context BuildContext object.
    /// @returns either the Authenticate() or the Home() screen.
    final AppUser? appUser = Provider.of<AppUser?>(context);

    // maintain user in the authentication part of the app tree while login is not performed
    if (appUser == null) {
      return Authenticate();
    }
    // when login is performed, allows access to the app
    else {
      return StreamProvider<AppUserData?>.value(
        initialData: null,
        value: DatabaseService(uid: appUser.uid).appUserData,
        child: SubmitPublicProfileData(),
      );
    }
  }
}
