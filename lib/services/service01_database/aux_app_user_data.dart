class AppUserData {
  // appUser variables
  final String uid;
  final String email;

  // state variables
  final bool? hasRegisteredPublicData;
  final bool? hasRegisteredPersonalData;

  // appUserData variables
  final String? userName;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? birthDay;
  final String? phoneCountryDialCode;
  final String? phoneNumber;

  AppUserData({ required this.uid, required this.email, this.hasRegisteredPublicData,
    this.hasRegisteredPersonalData,
    this.userName, this.firstName, this.lastName, this.gender, this.birthDay,
    this.phoneCountryDialCode, this.phoneNumber });

// TODO-BackEnd: transform all firstName and lastName first character to uppercase
// TODO-BackEnd: transform all userName characters to lowercase
}