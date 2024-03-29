import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:ms18_applicatie/globals.dart';
import '../Api/apiManager.dart';
import '../Widgets/paddingSpacing.dart';
import '../Widgets/popups.dart';
import '../menu.dart';

class Declarations extends StatefulWidget {
  const Declarations({super.key});

  @override
  State<Declarations> createState() => _DeclarationsState();
}

class _DeclarationsState extends State<Declarations> {
  Future<dynamic>? _future;
  TextEditingController remarkController = TextEditingController();

  getReceipt() {
    setState(() {
      _future = ApiManager.get("api/v1/Receipt", getHeaders());
    });
  }

  @override
  void initState() {
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
                      // data = data
                      //     .where((element) => element["status"] == 1)
                      //     .toList();
                      if (data.isEmpty) {
                        return const Text("Geen declaraties gevonden");
                      }
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> decl = data[index];
                          Map<String, dynamic> costCentre =
                              decl["costCentre"] ?? {};
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
                  PopupAndLoading.showSuccess("Declaratie goedgekeurd");
                  setState(() {
                    _future = getReceipt();
                  });
                  // Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Declarations(),
                    ),
                  );
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
                      "approved": false,
                    },
                    getHeaders());
                print(" RESPONSE AFTER SEND: $res");
                if (res != null) {
                  PopupAndLoading.showSuccess("Declaratie afgekeurd");
                  setState(() {
                    _future = getReceipt();
                  });
                  // Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Declarations(),
                    ),
                  );
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
