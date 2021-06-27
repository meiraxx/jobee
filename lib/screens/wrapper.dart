import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobee/models/app_user.dart';
import 'package:jobee/screens/profile/submit_public_profile_data.dart';
import 'package:jobee/services/database.dart';
import 'package:provider/provider.dart';
import 'authenticate/authenticate.dart';

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
      // since we have an appUser at this point, we can retrieve and
      // provide appUserData
      return StreamProvider<AppUserData>.value(
        initialData: AppUserData(
          uid: appUser.uid,
          email: appUser.email,
          hasRegisteredPublicData: false,
          hasRegisteredPersonalData: false
        ),
        value: DatabaseService(uid: appUser.uid).appUserData,
        child: SubmitPublicProfileData()
      );
    }
  }
}
