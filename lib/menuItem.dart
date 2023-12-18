import 'package:flutter/cupertino.dart';
import 'package:ms18_applicatie/roles.dart';

class MenuItem {
  MenuItem({required this.text,required this.icon,required this.page, this.roles = const [Roles.Admin]});

  final List<Roles> roles;
  final String text;
  final IconData icon;
  final Route page;


}
