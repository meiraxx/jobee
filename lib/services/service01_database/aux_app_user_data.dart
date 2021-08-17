class AppUserData {
  // appUser variables
  final String uid;
  final String email;

  // state variables
  final bool? hasRegisteredPublicData;
  final bool? hasRegisteredPersonalData;

  // appUserData public data variables
  final String? userName;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? birthDay;
  final String? about;

  // appUserData private data variables
  final String? phoneCountryDialCode;
  final String? phoneNumber;
  // TODO-BackEnd: transform all firstName and lastName first character to uppercase
  // TODO-BackEnd: allow only firstName and lastName with letters or letters with hyphens in-between
  // TODO-BackEnd: transform all userName characters to lowercase

  AppUserData({ required this.uid, required this.email, this.hasRegisteredPublicData, this.hasRegisteredPersonalData,
    this.userName, this.firstName, this.lastName, this.gender, this.birthDay, this.about,
    this.phoneCountryDialCode, this.phoneNumber });

  @override
  String toString() {
    return 'AppUserData('
        'uid: ${this.uid}, '
        'email: ${this.email}, '
        'hasRegisteredPublicData: ${this.hasRegisteredPublicData}, '
        'hasRegisteredPersonalData: ${this.hasRegisteredPersonalData}, '
        'userName: ${this.userName}, '
        'firstName: ${this.firstName}, '
        'lastName: ${this.lastName}, '
        'gender: ${this.gender}, '
        'birthDay: ${this.birthDay}, '
        'phoneCountryDialCode: ${this.phoneCountryDialCode}, '
        'phoneNumber: ${this.phoneNumber})';
  }
}