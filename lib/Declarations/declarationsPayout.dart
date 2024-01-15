// Made by Joost Both 103674
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Models/declaration.dart';
import 'package:ms18_applicatie/Widgets/inputFields.dart';
import 'package:ms18_applicatie/config.dart';

import '../Api/apiManager.dart';
import '../Widgets/paddingSpacing.dart';
import '../Widgets/popups.dart';
import '../menu.dart';

Future<dynamic>? _future;
TextEditingController remarkController = TextEditingController();

class DeclarationsPayout extends StatefulWidget {
  const DeclarationsPayout({super.key});

  @override
  State<DeclarationsPayout> createState() => DeclarationsPayoutState();
}

class DeclarationsPayoutState extends State<DeclarationsPayout> {
  getReceipt() async {
    _future = ApiManager.get("api/v1/Receipt", getHeaders());
  }

  @override
  void initState()  {
    getReceipt();
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
      child: Expanded(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  mainColor,
                  Colors.transparent,
                ],
                stops: [5 / 6, 5 / 6],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(3.0),
                  topLeft: Radius.circular(3.0),
                ),
              ),
              child: Column(
                children: [
                  if (_future is Future<Map<String, dynamic>>)
                    const Center(
                      child: Text("Geen data gevonden"),
                    )
                  else showRows(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
                      data = data.where((element) => element['status'] == 2).toList();
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> decl = data[index];
                          Map<String, dynamic> costCentre =
                              decl["costCentre"] ?? {};
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
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                // Show a dialog with some info about the decl
                                var photos = await ApiManager.get(
                                    "api/v1/Receipt/${decl['id']}/Photo",
                                    getHeaders());
                                showInfoDialog(context, decl, photos);
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
                                              decl['amount'].toString() ==
                                                  "null"
                                                  ? "Geen bedrag"
                                                  : decl['amount'].toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              costCentre["id"].toString() == ""
                                                  ? "Geen \n"
                                                  "kostencentrum"
                                                  : costCentre["id"].toString(),
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

  showInfoDialog(context, declInfo, photo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(declInfo['note']),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Note: ${declInfo['note']}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Amount: ${declInfo['amount']}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Status: ${declInfo['statusString']}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Kostencentrum: ${declInfo['costCentre']['name']}"),
                  ],
                ),
                const PaddingSpacing(),
                TextFormField(
                  controller: remarkController,
                  decoration: const InputDecoration(
                    hintText: "Opmerking",
                    labelText: "Opmerking: ",
                    hintStyle: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.w300,
                    ),
                    enabledBorder: inputUnderlineBorder,
                    focusedBorder: inputUnderlineBorder,
                    border: inputUnderlineBorder,
                    prefixIcon: Align(
                      widthFactor: 1.0,
                      heightFactor: 1.0,
                      child: Icon(
                        Icons.note,
                        color: mainColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const PaddingSpacing(),
                // Show the photo
                photo != null &&
                    photo.length > 0 &&
                    photo[0]['base64Image'] != null
                    ? ElevatedButton(
                  onPressed: () async {
                    // Show a dialog with the photo full size
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          contentPadding: const EdgeInsets.all(8),
                          content: Image(
                            image: MemoryImage(
                                base64Decode(photo[0]['base64Image'])),
                            height:
                            MediaQuery.of(context).size.height * 1,
                            width: MediaQuery.of(context).size.width * 1,
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: mainColor,
                    padding: const EdgeInsets.all(5),
                    shadowColor: backgroundColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(3))),
                  ),
                  child: Image(
                    image: MemoryImage(
                        base64Decode(photo[0]['base64Image'])),
                    height: 250,
                    width: 250,
                  ),
                )
                    : const PaddingSpacing(),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Update the status
                print("Sending to: api/v1/Receipt/${declInfo['id']}/Approve");
                var res = await ApiManager.post(
                    "api/v1/Receipt/${declInfo['id']}/Approve",
                    {
                      "receiptId": declInfo['id'],
                      "note": remarkController.text,
                      "approved": true,
                      "paid": true
                    },
                    getHeaders());
                if (res != null) {
                  PopupAndLoading.showSuccess("Declaratie goedgekeurd voor uitbetaling");
                  Navigator.pop(context);
                  setState(() {
                    _future = null;
                  });
                  setState(() {
                    _future = ApiManager.get("api/v1/Receipt", getHeaders());
                  });
                }
              },
              child: const Text('Goedkeuren'),
            ),
            TextButton(
              onPressed: () async {
                // Update the status
                var res = await ApiManager.post(
                    "api/v1/Receipt/${declInfo['id']}/Approve",
                    {
                      "receiptId": declInfo['id'],
                      "note": remarkController.text,
                      "approved": true,
                      "paid": false
                    },
                    getHeaders());
                print(" RESPONSE AFTER SEND: $res");
                if (res != null) {
                  PopupAndLoading.showSuccess("Declaratie afgekeurd voor uitbetaling");
                  Navigator.pop(context);
                  setState(() {
                    _future = null;
                  });
                  setState(() {
                    _future = ApiManager.get("api/v1/Receipt", getHeaders());
                  });
                }
              },
              child: const Text('Afkeuren'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
