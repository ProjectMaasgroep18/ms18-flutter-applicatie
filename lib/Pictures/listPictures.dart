import 'package:flutter/material.dart';

import '../menu.dart';

class ListPictures extends StatefulWidget {
  const ListPictures({Key? key}) : super(key: key);

  @override
  State<ListPictures> createState() => ListPicturesState();
}

class ListPicturesState extends State<ListPictures> {
  @override
  Widget build(BuildContext context) {
    return Menu(child: Text("Ga vanaf hier verder"));
  }
}