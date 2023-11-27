import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ms18_applicatie/Api/apiManager.dart';

import '../../config.dart';
import '../../menu.dart';
import '../Widgets/buttons.dart';
import '../Widgets/inputFields.dart';
import '../Widgets/paddingSpacing.dart';

class PickPhoto extends StatefulWidget {
  const PickPhoto({Key? key}) : super(key: key);

  @override
  State<PickPhoto> createState() => PickPhotoState();
}

final ImagePicker picker = ImagePicker();
XFile? photo;

ApiManager apiManager = ApiManager();

TextEditingController nameController = TextEditingController();
TextEditingController descriptionController = TextEditingController();
TextEditingController amountController = TextEditingController();

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
      child: Padding(
        padding: const EdgeInsets.all(mobilePadding),
        child: Column(
          children: [
            InputField(
              icon: Icons.person,
              hintText: "Naam:",
              controller: nameController,
              isUnderlineBorder: true,
            ),
            const PaddingSpacing(),
            InputField(
              hintText: "Description: ",
              controller: descriptionController,
              icon: Icons.description,
              isUnderlineBorder: true,
            ),
            const PaddingSpacing(),
            // Fill in the amount of euros
            InputField(
              hintText: "Amount: ",
              controller: amountController,
              icon: Icons.euro,
              isUnderlineBorder: true,
            ),
            const PaddingSpacing(),
            const PaddingSpacing(),
            // Make or take a photo in a alertDialog
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Button(
                  padding: const EdgeInsets.fromLTRB(21, 0, 21, 0),
                  icon: Icons.camera_alt,
                  onTap: () async {
                    if (nameController.text.isEmpty ||
                        descriptionController.text.isEmpty ||
                        amountController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Vul alle velden in"),
                        ),
                      );
                      return;
                    } else {
                      var res = await picker.pickImage(
                        source: ImageSource.camera,
                      );
                      setState(() {
                        photo = res;
                      });
                      print(photo?.path);
                    }
                  },
                  text: "Maak een foto",
                ),
                Button(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  icon: Icons.photo,
                  onTap: () async {
                    if (nameController.text.isEmpty ||
                        descriptionController.text.isEmpty ||
                        amountController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Vul alle velden in"),
                        ),
                      );
                      return;
                    } else {
                      var res = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      setState(() {
                        photo = res;
                      });
                      // if (photo != null) {
                      //   Navigator.pop(context, photo);
                      // }
                      print(photo?.path);
                    }
                  },
                  text: "Kies een foto",
                ),
              ],
            ),
            const PaddingSpacing(),
            // Show the photo
            photo != null
                ? Image.file(
                    File(photo!.path),
                    width: 250,
                    height: 250,
                  )
                : Container(
                    child: const PaddingSpacing(),
                  ),
            const PaddingSpacing(),
            // Upload the photo
        Button(
            onTap: () async {
                  if (photo == null ||
                      nameController.text.isEmpty ||
                      descriptionController.text.isEmpty ||
                      amountController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Kies een foto en vul alle velden in"),
                      ),
                    );
                    return;
                  } else {
                    var res = await apiManager.post(
                      "",
                      {
                        "name": nameController.text,
                        "description": descriptionController.text,
                        "image": photo!.path,
                      },
                    );
                    SnackBar snackBar = const SnackBar(
                      content: Text("succesvol geupload"),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.pop(context);
                  }
                },
            text: "Uploaden")
          ],
        ),
      ),
    );
  }
}
