import 'package:flutter/material.dart';

import '../../config.dart';
import '../../menu.dart';

class PickPhoto extends StatefulWidget {
  const PickPhoto({Key? key}) : super(key: key);

  @override
  State<PickPhoto> createState() => PickPhotoState();
}

class PickPhotoState extends State<PickPhoto> {
  @override
  Widget build(BuildContext context) {
    return Menu(
      title: const Text(
          "Maak een keuze",
          style: TextStyle(
            color: Colors.white,
          ),
      ),
      child: bodyContent(),
    );
  }

  Widget bodyContent() {
    return
  }
}