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
  String btnText = "Uploaden";
  int? id;
  bool isEditing = false;

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
      print(x);
      List<dynamic> data = x;
      List<DropdownMenuItem<String>> temp = [];
      // Loop over the data and add the names to the list
      for (var i = 0; i < data.length; i++) {
        temp.add(DropdownMenuItem(
          value: data[i]['id'].toString(),
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
    setState(() {
      nameController.text = globalLoggedInUserValues?.name ?? "";
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
      child: SingleChildScrollView(
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
                    Map<String, dynamic> res;
                    var resp;
                    if (photo == null) {
                      PopupAndLoading.showError(
                          "Kies een foto en vul alle velden in");
                      return;
                    } else {
                      if (!isEditing) {
                        resp = await ApiManager.post(
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
                            "costCentreId": selectedCostCentre,
                          },
                          getHeaders(),
                        );
                      } else {
                        print("SENDING: ");
                        print("api/v1/Receipt/$id");
                        print({
                          "amount": amountController.text == ""
                              ? null
                              : amountController.text,
                          "name": nameController.text == ""
                              ? null
                              : nameController.text,
                          "note": descriptionController.text == ""
                              ? null
                              : descriptionController.text,
                          "costCentreId": selectedCostCentre,
                        });
                        resp = await ApiManager.put(
                          "api/v1/Receipt/$id",
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
                            "costCentreId": selectedCostCentre,
                          },
                          getHeaders(),
                        );
                      }
                      if (resp == null) {
                        PopupAndLoading.showSuccess("Het is gelukt");
                        setState(() {
                          btnText = "Uploaden";
                          photo = null;
                          file = null;
                          nameController.text = "";
                          descriptionController.text = "";
                          amountController.text = "";
                          selectedCostCentre = null;
                          _future = getReceipt();
                        });
                        return;
                      }
                      res = await resp;
                      print(getHeaders());
                      print(res.toString());
                      if (res["error"] != null) {
                        PopupAndLoading.showError("Er is iets fout gegaan");
                        return;
                      }
                      var photoRes;
                      var fileLength = await file!.length();
                      print(" Size: $fileLength");
                      try {
                        if (!isEditing) {
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
                        }
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
                  text: btnText),
              // Make a horizontal divider
              if (photo == null) ...[
                const Divider(color: mainColor),
                const PaddingSpacing(),
                showRows(),
              ],
            ],
          ),
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
                          Map<String, dynamic> costCentre = decl["costCentre"] ?? {};
                          Color btnColor = mainButtonColor;
                          // Switch the status to a string
                          switch (decl['status']) {
                            case 0:
                              btnColor = mainButtonColor;
                              break;
                            case 1:
                              btnColor = const Color(0xFFE8B025);
                              break;
                            case 2:
                              btnColor = const Color(0xFF00CCA1);
                              break;
                            case 3:
                              btnColor = dangerColor;
                              break;
                            case 4:
                              btnColor = successColor;
                              break;
                          }
                          print("DECL: $decl");
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onLongPress: () async {
                                // Ask if the user is sure about deletion if so delete
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Verwijderen"),
                                      contentPadding: const EdgeInsets.all(8),
                                      content: const Text(
                                          "Weet je zeker dat je deze declaratie wilt verwijderen?"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            var res = await ApiManager.delete(
                                                "api/v1/Receipt/${decl['id']}",
                                                getHeaders());
                                            if (res == null) {
                                              PopupAndLoading.showSuccess(
                                                  "De declaratie is verwijderd");
                                              setState(() {
                                                _future = getReceipt();
                                              });
                                            } else {
                                              PopupAndLoading.showError(
                                                  "Er is iets fout gegaan");
                                            }
                                          },
                                          child: const Text("Ja"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Nee"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: btnColor,
                                padding:
                                    const EdgeInsets.fromLTRB(5, 30, 5, 30),
                                shadowColor: backgroundColor,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3))),
                              ),
                              onPressed: () async {
                                // Load the text fields with the info
                                setState(() {
                                  if (decl["isEditable"]) {
                                    id = decl['id'];
                                    nameController.text =
                                        decl['memberCreated']['name'] ?? "";
                                    descriptionController.text =
                                        decl['note'] ?? "";
                                    amountController.text =
                                    decl['amount'].toString() == "null"
                                        ? ""
                                        : decl['amount'].toString();
                                    if (costCentre["id"] != null) {
                                      selectedCostCentre =
                                          costCentre["id"].toString();
                                    }
                                    // Load the photo from the api
                                    ApiManager.get(
                                        "api/v1/Receipt/${decl['id']}/Photo",
                                        getHeaders()).then((value) {
                                      print(value[0]['fileName']);
                                      print(
                                          base64Decode(value[0]['base64Image'])
                                              .lengthInBytes);
                                      setState(() {
                                        Directory tempDir = Directory
                                            .systemTemp;
                                        file = File(
                                            "${tempDir
                                                .path}/${value[0]['fileName']}");
                                        file!.writeAsBytesSync(base64Decode(
                                            value[0]['base64Image']));
                                        print("${tempDir
                                            .path}/${value[0]['fileName']}");
                                        photo = XFile(file!.path);
                                        btnText = "Bijwerken";
                                        isEditing = true;
                                      });
                                    });
                                  } else {
                                    PopupAndLoading.showError(
                                        "Je kan deze declaratie niet meer bewerken");
                                  }
                                });
                              },
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
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              decl['amount'].toString() == "null" ? "Geen bedrag" : decl['amount'].toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              costCentre["id"].toString() == "" ? "Geen \n"
                                                      "kostencentrum" : costCentre["id"].toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
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
