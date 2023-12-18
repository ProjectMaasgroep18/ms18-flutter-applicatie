import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Models/declaration.dart';
import 'package:ms18_applicatie/Widgets/inputFields.dart';
import 'package:ms18_applicatie/config.dart';

import '../Api/apiManager.dart';
import '../Widgets/paddingSpacing.dart';
import '../menu.dart';

Future<dynamic>? _future;
TextEditingController remarkController = TextEditingController();

class Declarations extends StatefulWidget {
  const Declarations({super.key});

  @override
  State<Declarations> createState() => _DeclarationsState();
}

ApiManager apiManager = ApiManager();

class _DeclarationsState extends State<Declarations> {
  @override
  void initState() {
    _future = apiManager.get("/api/v1/Receipt");
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
                  showRows(),
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
                                // Show a dialog with some info about the decl
                                showInfoDialog(context, decl);
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

  showInfoDialog(context, declInfo) {
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
                const PaddingSpacing(),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  declInfo['photos'] != null &&
                          declInfo['photos'].length > 0 &&
                          declInfo['photos'][0]['base64Image'] != null
                      ? Image(
                          image: MemoryImage(base64Decode(
                              declInfo['photos'][0]['base64Image'])),
                          height: 250,
                          width: 250,
                        )
                      : Container(
                          child: const PaddingSpacing(),
                        ),
                ]),
                const PaddingSpacing(),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     InputField(
                //       icon: Icons.note,
                //       hintText: "Opmerking",
                //       labelText: "Opmerking: ",
                //       controller: remarkController
                //     )
                //   ],
                // )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Update the status
                var res = apiManager
                    .post("/api/v1/Receipt/${declInfo['id']}/Approve", {
                  "receiptId": declInfo['id'],
                  "note": declInfo['note'],
                  "approved": true,
                });
                if (res != null) {
                  // Show snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Declaratie goedgekeurd"),
                    ),
                  );
                  Navigator.pop(context);
                  setState(() {
                    _future = null;
                  });
                  setState(() {
                    _future = apiManager.get("/api/v1/Receipt");
                  });
                }
              },
              child: const Text('Goedkeuren'),
            ),
            TextButton(
              onPressed: () {
                // Update the status
                var res = apiManager
                    .post("/api/v1/Receipt/${declInfo['id']}/Approve", {
                  "receiptId": declInfo['id'],
                  "note": declInfo['note'],
                  "approved": false,
                });
                if (res != null) {
                  // Show snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Declaratie afgekeurd"),
                    ),
                  );
                  Navigator.pop(context);
                  setState(() {
                    _future = null;
                  });
                  setState(() {
                    _future = apiManager.get("/api/v1/Receipt");
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
