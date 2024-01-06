import 'package:flutter/material.dart';
import 'package:ms18_applicatie/roles.dart';

class User {
  int id;
  String name;
  String email;
  String password;
  List<Roles> roles;
  bool guest;
  Color color;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.roles,
    required this.guest,
    required this.color,
  });
}
