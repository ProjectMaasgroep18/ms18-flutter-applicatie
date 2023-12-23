class User {
  int id;
  String name;
  String email;
  String hashedPassword;
  bool guest;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.hashedPassword,
    required this.guest
  });
}
