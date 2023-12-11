import 'package:flutter/material.dart';
import 'package:ms18_applicatie/config.dart';

import '../menu.dart';

Future<List<Declarations>>? _future;
class Declarations extends StatefulWidget {
  const Declarations({super.key});

  @override
  State<Declarations> createState() => _DeclarationsState();
}

class _DeclarationsState extends State<Declarations> {
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
                builder: (context, AsyncSnapshot<List<Declarations>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          Declarations decl = snapshot.data![index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                // Show a dialog with some info about the decl
                                showInfoDialog(context, decl);
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.fromLTRB(5, 30, 5, 30),
                                shadowColor: mainColor,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3))),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        decl.note,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
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

  showInfoDialog(context, declInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(declInfo.note),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Note: ${declInfo.note}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Amount: ${declInfo.amount}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Status: ${declInfo.statusString}"),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Update the status
              },
              child: const Text('Goedkeuren'),
            ),
            TextButton(
              onPressed: () {
                // Update the status
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
