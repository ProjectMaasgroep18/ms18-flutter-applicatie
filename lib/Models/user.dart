class User {
  final String firstName;
  final String lastName;
  final String email;
  final String hashedPassword;
  final DateTime dateOfBirth;
  final bool gender;
  final String ? profilePicture;
  String get fullName => '$firstName $lastName';


  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.hashedPassword,
    required this.dateOfBirth,
    required this.gender,
    this.profilePicture
  });
}
