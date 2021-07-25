import 'dart:typed_data' show Uint8List;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:jobee/models/app_user.dart' show AppUserData;
import 'package:jobee/screens/package4_profile/global_variables_profile.dart' show ProfileAsyncGlobals, ProfileSyncGlobals;
import 'package:jobee/widgets/widget_utils/preload_image.dart' show loadImage;

/// ensures build code is only called once
bool _calledOnce = false;
/// local user profile avatar load function
Future<bool> loadLocalUserProfileAvatar(AppUserData appUserData) async {
  if (!_calledOnce) {
    debugPrint("load_user_resources_state.dart: Loading local profile avatar.");
    // set avatar bytes to the local file bytes if file exists, else remain null
    ProfileSyncGlobals.userProfileAvatarBytes = await ProfileAsyncGlobals.getLocalUserProfileAvatarBytes(appUserData.uid);
    // check if image does not exist yet (empty if no avatar was sent to the server)
    final bool imageEmpty = listEquals( ProfileSyncGlobals.userProfileAvatarBytes, Uint8List.fromList(<int>[]) );
    // pre-load user profile avatar
    if (!imageEmpty) await loadImage(MemoryImage(ProfileSyncGlobals.userProfileAvatarBytes!));
    _calledOnce = true;
  }

  // extend loading duration, both for looks and to give the stream of AppUserData some time to get
  // the real values from the back-end, thus avoiding re-entering the SubmitPublicProfile page
  await Future<void>.delayed(const Duration(seconds: 1), () {});
  return true;
}