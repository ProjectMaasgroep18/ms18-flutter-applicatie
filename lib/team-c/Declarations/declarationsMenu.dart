import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Declarations/declarations.dart';
import 'package:ms18_applicatie/roles.dart';

import '../../Declarations/declarationsPayout.dart';
import '../../Declarations/pickPhoto.dart';
import '../../Widgets/paddingSpacing.dart';
import '../../config.dart';
import '../../menu.dart';

class DeclarationsMenu extends StatefulWidget {
  const DeclarationsMenu({Key? key}) : super(key: key);

  @override
  State<DeclarationsMenu> createState() => DeclarationsMenuState();
}

class DeclarationsMenuState extends State<DeclarationsMenu> {
  @override
  Widget build(BuildContext context) {
    return Menu(
      title: const Text(
        "Declaraties",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: bodyContent(),
    );
  }

  Widget bodyContent() {
    return SingleChildScrollView(
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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(3),
                  topLeft: Radius.circular(3),
                ),
              ),
              child: Column(
                children: [
                  if (UserData.role == Roles.Admin)
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DeclarationsPayout()));
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            // padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                            shadowColor: shadowColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                          ),
                          child: Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                  border: Border.fromBorderSide(
                                    BorderSide(
                                      color: shadowColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: const Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Uitbetalen",
                                              style: TextStyle(
                                                color: mainColor,
                                                fontSize: 30,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "UItbetalen van declaraties",
                                              style: TextStyle(
                                                color: mainColor,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const PaddingSpacing(),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PickPhoto()));
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            // padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                            shadowColor: shadowColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                          ),
                          child: Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                  border: Border.fromBorderSide(
                                    BorderSide(
                                      color: shadowColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Image(
                                            image: AssetImage(
                                                'assets/declarations/uploadtruck.png'),
                                            width: 50,
                                            height: 50,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Uploaden",
                                            style: TextStyle(
                                              color: mainColor,
                                              fontSize: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Uploaden van declaraties voor goedkeuring",
                                            style: TextStyle(
                                              color: mainColor,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                  const PaddingSpacing(),
                  if (UserData.role == Roles.Admin)
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Declarations()));
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            // padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                            shadowColor: shadowColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                          ),
                          child: Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                  border: Border.fromBorderSide(
                                    BorderSide(
                                      color: shadowColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Image(
                                            image: AssetImage(
                                                'assets/declarations/approvetruck.png'),
                                            width: 50,
                                            height: 50,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Goedkeuren",
                                            style: TextStyle(
                                              color: mainColor,
                                              fontSize: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Declaraties goedkeuren voor uitbetaling",
                                            style: TextStyle(
                                              color: mainColor,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
