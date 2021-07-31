import 'dart:typed_data';

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:jobee/services/service01_database/aux_app_user_data.dart' show AppUserData;
import 'package:jobee/screens/screen04_home/4.0_home.dart' show Home;
import 'package:jobee/screens/screen05_profile/global_variables_profile.dart' show ProfileAsyncGlobals, ProfileSyncGlobals;
import 'package:jobee/widgets/loaders/text_loader.dart' show TextLoader;
import 'package:jobee/widgets/widget_utils/preload_image.dart' show loadImage;
import 'package:provider/provider.dart' show Provider;

class UserResourceLoader extends StatefulWidget {

  const UserResourceLoader({Key? key}) : super(key: key);

  @override
  _UserResourceLoaderState createState() => _UserResourceLoaderState();
}

class _UserResourceLoaderState extends State<UserResourceLoader> {
  /// function to load local user profile avatar
  Future<bool> _loadLocalUserProfileAvatar({required String uid}) async {
    if (_loadAlreadyCalled) return false;
    // set _loadAlreadyCalled to true so no other async functions can load it again
    _loadAlreadyCalled = true;
    // set avatar bytes to the local file bytes if file exists, else remain null
    ProfileSyncGlobals.userProfileAvatarBytes = await ProfileAsyncGlobals.getLocalUserProfileAvatarBytes(uid);
    // check if image does not exist yet (empty if no avatar was sent to the server)
    final bool imageEmpty = listEquals( ProfileSyncGlobals.userProfileAvatarBytes, Uint8List.fromList(<int>[]) );
    // pre-load user profile avatar if profile bytes are not empty and if it wasn't already called
    if (!imageEmpty) await loadImage(MemoryImage(ProfileSyncGlobals.userProfileAvatarBytes!));

    // extend loading duration, both for looks and to give the stream of AppUserData some time to get
    // the real values from the back-end, thus avoiding re-entering the SubmitPublicProfile page
    await Future<void>.delayed(const Duration(seconds: 1), () {});
    return true;
  }
  /// bool to call load function once only
  bool _loadAlreadyCalled = false;
  /// future used to store _loadLocalUserProfileAvatar function result
  late final Future<bool> _userProfileAvatarLoad;

  @override
  void didChangeDependencies() {
    // use an AppUserData provider instance to create the futures required for user resource loading
    final AppUserData appUserData = Provider.of<AppUserData>(context, listen: false);
    _userProfileAvatarLoad = _loadLocalUserProfileAvatar(uid: appUserData.uid);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _userProfileAvatarLoad,
      builder: (BuildContext context, AsyncSnapshot<bool> futureBoolSnapshot) {
        if (futureBoolSnapshot.connectionState == ConnectionState.waiting) {
          return const TextLoader(text: "Loading user information...");
        }

        if (futureBoolSnapshot.connectionState == ConnectionState.done) {
          if (futureBoolSnapshot.hasError) {
            return Text('Error: ${futureBoolSnapshot.error}');
          }

          // at this point, futureBoolSnapshot.data should be true
          assert(futureBoolSnapshot.data == true);

          return const Home();
        }
        throw Exception("Error: This code shouldn't ever be reached.");
      },
    );
  }
}
