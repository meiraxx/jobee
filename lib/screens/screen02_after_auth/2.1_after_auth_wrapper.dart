import 'package:flutter/material.dart';
import 'package:jobee/services/service01_database/aux_app_user_data.dart' show AppUserData;
import 'package:jobee/screens/screen02_after_auth/2.2_user_resource_loader.dart' show UserResourceLoader;
import 'package:jobee/screens/screen03_user_details_registration/3.2_submit_personal_profile_data_screen.dart'
    show SubmitPersonalProfileDataScreen;
import 'package:jobee/screens/screen03_user_details_registration/3.1_submit_public_profile_data_screen.dart'
    show SubmitPublicProfileDataScreen;
import 'package:provider/provider.dart' show Provider;

class AfterAuthWrapper extends StatefulWidget {

  const AfterAuthWrapper({Key? key}) : super(key: key);
  @override
  _AfterAuthWrapperState createState() => _AfterAuthWrapperState();
}

class _AfterAuthWrapperState extends State<AfterAuthWrapper> {
  @override
  Widget build(BuildContext context) {
    final AppUserData appUserData = Provider.of<AppUserData>(context);
    // if we haven't submitted public data yet, head to the SubmitPublicProfileData() widget
    if (appUserData.hasRegisteredPublicData == false) return const SubmitPublicProfileDataScreen();
    // else, if we haven't submitted personal data yet, head to the SubmitPersonalProfileData() widget
    if (appUserData.hasRegisteredPersonalData == false) return const SubmitPersonalProfileDataScreen();

    // head to the UserResourceLoader() widget to prepare to go to Home()
    return const UserResourceLoader();
  }
}
