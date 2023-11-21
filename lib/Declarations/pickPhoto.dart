import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../config.dart';
import '../../menu.dart';
import '../Widgets/inputFields.dart';
import '../Widgets/paddingSpacing.dart';

class PickPhoto extends StatefulWidget {
  const PickPhoto({Key? key}) : super(key: key);

  @override
  State<PickPhoto> createState() => PickPhotoState();
}
final ImagePicker picker = ImagePicker();
XFile? photo = null;
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
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: InputField(
              icon: Icons.person,
              hintText: "Naam:",
              isUnderlineBorder: true,
            ),
          ),
          const PaddingSpacing(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: InputField(
              hintText: "Description: ",
              icon: Icons.description,
              isUnderlineBorder: true,
            ),
          ),
          const PaddingSpacing(),
          // Make or take a photo in a alertDialog
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  photo = await picker.pickImage(
                    source: ImageSource.camera,
                  );
                  // if (photo != null) {
                  //   Navigator.pop(context, photo);
                  // }
                  print(photo?.path);
                },
                child: const Text("Maak een foto"),
              ),
              ElevatedButton(
                onPressed: () async {
                  photo = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  // if (photo != null) {
                  //   Navigator.pop(context, photo);
                  // }
                  print(photo?.path);
                },
                child: const Text("Kies een foto"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
