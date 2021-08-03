class AppUser {
  final String uid;
  final String email;

  AppUser({ required this.uid, required this.email });

  @override
  String toString() {
    return 'AppUser('
        'uid: ${this.uid}, '
        'email: ${this.email})';
  }

}