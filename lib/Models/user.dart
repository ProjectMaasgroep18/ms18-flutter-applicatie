class User {
  int id;
  String name;
  String email;
  String password;
  bool guest;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.guest
  });
}
