class AppUser {
  final String uid;
  final String email;

  AppUser({ required this.uid, required this.email });

}

class AppUserData {
  // appUser variables
  final String uid;
  final String email;

  // state variables
  final bool hasRegisteredPublicData;
  final bool hasRegisteredPersonalData;

  // appUserData variables
  final String? userName;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? birthDay;
  final String? phoneCountryDialCode;
  final String? phoneNumber;

  AppUserData({ required this.uid, required this.email, required this.hasRegisteredPublicData,
    required this.hasRegisteredPersonalData,
    this.userName, this.firstName, this.lastName, this.gender, this.birthDay,
    this.phoneCountryDialCode, this.phoneNumber });

}