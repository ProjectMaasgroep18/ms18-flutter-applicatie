import 'package:flutter/material.dart';

import '../menu.dart';

class Declarations extends StatefulWidget {
  const Declarations({Key? key}) : super(key: key);

  @override
  State<Declarations> createState() => DeclarationsState();
}

class DeclarationsState extends State<Declarations> {
  @override
  Widget build(BuildContext context) {
    return Menu(child: Text("Ga vanaf hier verder"));
  }
}