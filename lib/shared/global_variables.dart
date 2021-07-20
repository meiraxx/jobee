import 'dart:typed_data' show Uint8List;

/// used to check if we should update user's profile avatar
bool updateUserProfileAvatar = true;
/// used to store the bytes of the user's profile avatar
Uint8List userProfileAvatarBytes = Uint8List.fromList(<int>[]);

/// boolean used to halt navigation
bool navigationHaltRequired = false;