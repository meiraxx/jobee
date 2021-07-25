import 'package:flutter/material.dart';
import 'package:jobee/models/app_user.dart' show AppUserData;
import 'package:jobee/screens/package2_user_details_registration/submit_personal_profile_data.dart' show SubmitPersonalProfileData;
import 'package:jobee/screens/package2_user_details_registration/submit_public_profile_data.dart' show SubmitPublicProfileData;
import 'package:jobee/screens/package3_home/home.dart' show Home;
import 'package:jobee/widgets/loaders/text_loader.dart' show TextLoader;
import 'package:provider/provider.dart' show Provider;

import 'load_user_resources_state.dart' show loadLocalUserProfileAvatar;

class LoadUserResources extends StatelessWidget {
  const LoadUserResources();

  @override
  Widget build(BuildContext context) {
    /// local user profile avatar load future/promise
    Future<bool>? userProfileAvatarLoad;

    final AppUserData appUserData = Provider.of<AppUserData>(context);
    userProfileAvatarLoad = loadLocalUserProfileAvatar(appUserData);

    const TextLoader textLoader = TextLoader(text: "Loading all user data...");

    return FutureBuilder<bool>(
        future: userProfileAvatarLoad,
        builder: (BuildContext context, AsyncSnapshot<bool> futureSnapshot) {
          switch (futureSnapshot.connectionState) {
            case ConnectionState.none: return const Text("ConnectionState.none should not be reached.");
            case ConnectionState.waiting:
              debugPrint("load_user_resources.dart: Loading all user data (local profile avatar data).");
              return textLoader;
            default:
              if (futureSnapshot.hasError) {
                return Text('Error: ${futureSnapshot.error}');
              }

              if (futureSnapshot.data != true) {
                return const Text('Unexpected error: failed to load user data. Please try again later or contact support.');
              }

              if (appUserData.hasRegisteredPublicData == null || appUserData.hasRegisteredPersonalData == null) {
                debugPrint("load_user_resources.dart: Loading all user data ([AppUserData] data).");
                return textLoader;
              }

              // if we haven't submitted public data yet
              if (appUserData.hasRegisteredPublicData == false) {
                // Wrapper() -> SubmitPublicProfileData()
                // head to public data submission
                return const SubmitPublicProfileData();
              }

              // else, if we haven't submitted personal data yet
              if (appUserData.hasRegisteredPersonalData == false) {
                // SubmitPublicProfileData() -> SubmitPersonalData()
                // head to personal data submission
                return const SubmitPersonalProfileData();
              }

              // Home() presented
              // head to the home widget
              return const Home();
          } // switch case
        }
    );
  }
}
