import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ms18_applicatie/Api/apiManager.dart';

import '../../config.dart';
import '../../menu.dart';
import '../Widgets/buttons.dart';
import '../Widgets/inputFields.dart';
import '../Widgets/paddingSpacing.dart';

final ImagePicker picker = ImagePicker();
XFile? photo;
File? file;

List<DropdownMenuItem<String>> _costCentres = [
  const DropdownMenuItem(
    value: "Selecteer een kostencentrum",
    enabled: false,
    child: Text("Selecteer een kostencentrum"),
  )
];
String? selectedCostCentre;


TextEditingController nameController = TextEditingController();
TextEditingController descriptionController = TextEditingController();
TextEditingController amountController = TextEditingController();

class PickPhoto extends StatefulWidget {
  const PickPhoto({Key? key}) : super(key: key);

  @override
  State<PickPhoto> createState() => PickPhotoState();
}

class PickPhotoState extends State<PickPhoto> {
  @override
  void initState() {
    // Retrieve all the costcentres and put them in a list
    ApiManager.get("/api/v1/CostCentre").then((x) {
      List<dynamic> data = x;
      List<DropdownMenuItem<String>> temp = [];
      // Loop over the data and add the names to the list
      for (var i = 0; i < data.length; i++) {
        temp.add(DropdownMenuItem(
          value: data[i]['name'].toString(),
          child: Text(data[i]['name'].toString()),
        ));
      }

      setState(() {
        _costCentres = temp;
      });
    });
    super.initState();
  }

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
              hintText: "Naam: ",
              controller: nameController,
              isRequired: false,
            ),
            const PaddingSpacing(),
            InputField(
              hintText: "Description: ",
              controller: descriptionController,
              icon: Icons.description,
              isRequired: false,
            ),
            const PaddingSpacing(),
            // Fill in the amount of euros
            InputField(
              hintText: "Amount: ",
              controller: amountController,
              icon: Icons.euro,
              isRequired: false,
            ),
            const PaddingSpacing(),
            DropdownButton<String>(
              hint: const Text("Selecteer een kostencentrum"),
              isExpanded: true,
              value: selectedCostCentre,
              iconEnabledColor: mainColor,
              style: const TextStyle(color: mainColor, fontSize: 17),
              underline: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: mainButtonColor), // Onderstreping kleur
                  ),
                ),
              ),
              items: _costCentres,
              onChanged: (String? value) {
                setState(() {
                  selectedCostCentre = value!;
                });
              },
            ),
            const PaddingSpacing(),
            // Make or take a photo in a alertDialog
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Button(
                  padding: const EdgeInsets.fromLTRB(21, 0, 21, 0),
                  icon: Icons.camera_alt,
                  onTap: () async {
                    if (amountController.text.isEmpty) {
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
                      file = File(photo!.path);
                    }
                  },
                  text: "Maak een foto",
                ),
                Button(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  icon: Icons.photo,
                  onTap: () async {
                    if (amountController.text.isEmpty) {
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
                      file = File(photo!.path);
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
                  if (photo == null || amountController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Kies een foto en vul alle velden in"),
                      ),
                    );
                    return;
                  } else {
                    var res = await ApiManager.post(
                      "/api/v1/Receipt",
                      {
                        "amount": amountController.text,
                        "name": nameController.text,
                        "note": descriptionController.text,
                        "costCentre": selectedCostCentre,
                        "photos": [
                          {
                            "fileName": file!.path.split("/").last,
                            "fileExtension": file!.path.split(".").last,
                            "base64Image": await imageToBase64(file!),
                          }
                        ],
                      },
                    );
                    if (res == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Er is iets fout gegaan"),
                        ),
                      );
                      return;
                    }
                    SnackBar snackBar = const SnackBar(
                      content: Text("Succesvol geupload"),
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

  Future<String> imageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(Uint8List.fromList(imageBytes));
    return base64Image;
  }
}
