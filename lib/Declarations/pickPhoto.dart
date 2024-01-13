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
import '../Widgets/popups.dart';
import '../globals.dart';

List<DropdownMenuItem<String>> _costCentres = [
  const DropdownMenuItem(
    value: "Selecteer een kostencentrum",
    enabled: false,
    child: Text("Selecteer een kostencentrum"),
  )
];

class PickPhoto extends StatefulWidget {
  PickPhoto({Key? key}) : super(key: key);

  @override
  State<PickPhoto> createState() => PickPhotoState();
}

class PickPhotoState extends State<PickPhoto> {
  Future<dynamic>? _future;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  String? selectedCostCentre;
  final ImagePicker picker = ImagePicker();
  XFile? photo;
  File? file;

  Map<String, String> retrieveHeaders() {
    Map<String, String> header = getHeaders();
    print("HEARDER JWAKJKASKJ: $header");
    return header;
  }

  Future<dynamic> getReceipt() async {
    _future = ApiManager.get(
        "api/v1/User/${globalLoggedInUserValues?.id}/Receipt", getHeaders());
    print("Headers: ${getHeaders()}");
    print("URL: api/v1/User/${globalLoggedInUserValues?.id}/Receipt");
    return _future;
  }

  @override
  void initState() {
    _future = getReceipt();
    // Retrieve all the costcentres and put them in a list
    ApiManager.get("api/v1/CostCentre", retrieveHeaders()).then((x) {
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
    if (_costCentres.isEmpty) {
      _costCentres.add(const DropdownMenuItem(
        value: "Selecteer een kostencentrum",
        enabled: false,
        child: Text("Selecteer een kostencentrum"),
      ));
    }
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
                // Size it to according to the screen size
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.3,
                  height: MediaQuery.of(context).size.height / 15,
                  child: Button(
                    padding: const EdgeInsets.fromLTRB(21, 0, 21, 0),
                    icon: Icons.camera_alt,
                    onTap: () async {
                      // if (amountController.text.isEmpty) {
                      //   PopupAndLoading.showError("Vul alle velden in");
                      //   return;
                      // } else {
                      var res = await picker.pickImage(
                        source: ImageSource.camera,
                      );
                      setState(() {
                        photo = res;
                      });
                      file = File(photo!.path);
                      // }
                    },
                    text: "Maak een foto",
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.3,
                  height: MediaQuery.of(context).size.height / 15,
                  child: Button(
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    icon: Icons.photo,
                    onTap: () async {
                      // if (amountController.text.isEmpty) {
                      //   PopupAndLoading.showError("Vul alle velden in");
                      //   return;
                      // } else {
                      var res = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      setState(() {
                        photo = res;
                      });
                      file = File(photo!.path);
                      // }
                    },
                    text: "Kies een foto",
                  ),
                ),
              ],
            ),
            const PaddingSpacing(),
            // Show the photo
            photo != null
                ? Image.file(
                    File(photo!.path),
                    width: MediaQuery.of(context).size.width / 1.7,
                    height: MediaQuery.of(context).size.width / 1.7,
                  )
                : const PaddingSpacing(),
            const PaddingSpacing(),
            // Upload the photo
            Button(
                onTap: () async {
                  if (photo == null) {
                    PopupAndLoading.showError(
                        "Kies een foto en vul alle velden in");
                    return;
                  } else {
                    Map<String, dynamic> res = await ApiManager.post(
                      "api/v1/Receipt",
                      {
                        "amount": amountController.text == ""
                            ? null
                            : amountController.text,
                        "name": nameController.text == ""
                            ? null
                            : nameController.text,
                        "note": descriptionController.text == ""
                            ? null
                            : descriptionController.text,
                        "costCentre": selectedCostCentre,
                      },
                      getHeaders(),
                    );
                    print(getHeaders());
                    print(res);
                    if (res["error"] != null) {
                      PopupAndLoading.showError("Er is iets fout gegaan");
                      return;
                    }
                    Future<dynamic>? photoRes;
                    var fileLength = await file!.length();
                    print(" Size: $fileLength");
                    try {
                      photoRes = await ApiManager.post(
                        "api/v1/Receipt/${res["id"]}/Photo",
                        {
                          "fileName": file!
                              .path
                              .split("/")
                              .last,
                          "fileExtension": file!
                              .path
                              .split(".")
                              .last,
                          "base64Image": await imageToBase64(file!),
                          "receiptId": res["id"]
                        },
                        getHeaders(),
                      );
                    } catch (e) {
                      print(e);
                    }
                    if (photoRes != null) {
                      PopupAndLoading.showSuccess("De foto is geupload");
                      // Future.delayed(const Duration(seconds: 2), () {
                      Navigator.pop(context);
                      // });
                    } else {
                      PopupAndLoading.showError("Er is iets fout gegaan");
                    }
                  }
                },
                text: "Uploaden"),
            // Make a horizontal divider
            if (photo == null) ...[
              const Divider(color: mainColor),
              const PaddingSpacing(),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
                    showRows(),
              //     ],
              //   ),
              // ),
            ],
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

  showRows() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: FutureBuilder(
                future: _future,
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasData) {
                      List<dynamic> data = snapshot.data;
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> decl = data[index];
                          print("DECL: $decl");
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                // Load the text fields with the info
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: mainColor,
                                padding:
                                    const EdgeInsets.fromLTRB(5, 30, 5, 30),
                                shadowColor: backgroundColor,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3))),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              decl['note'] ??
                                                  "Geen beschrijving",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              decl['statusString'] ??
                                                  "Geen status",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      decl['photos'] != null &&
                                              decl['photos'].length > 0 &&
                                              decl['photos'][0]
                                                      ['base64Image'] !=
                                                  null
                                          ? Image(
                                              image: MemoryImage(base64Decode(
                                                  decl['photos'][0]
                                                      ['base64Image'])),
                                              height: 100,
                                              width: 150,
                                            )
                                          : Container(
                                              child: const PaddingSpacing(),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Text("Geen declaraties gevonden");
                    }
                  }
                })),
      ],
    );
  }
}
