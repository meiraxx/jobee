class AppUser {
  final String uid;
  final String email;

  AppUser({ required this.uid, required this.email });

}

class AppUserData {
  final String uid;
  final String email;
  final String? name;
  final String? phoneNumber;

  AppUserData({ required this.uid, required this.email, this.name, this.phoneNumber });

}