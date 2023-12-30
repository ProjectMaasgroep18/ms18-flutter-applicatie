import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Declarations/declarations.dart';
import 'package:ms18_applicatie/roles.dart';

import '../../Declarations/declarationsPayout.dart';
import '../../Declarations/pickPhoto.dart';
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
          "Maak een keuze",
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
                  // Button 1
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: shadowColor,
                                blurRadius: 6,
                                offset: Offset(0, 0),
                              ),
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              print("Button 1 pressed");
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const PickPhoto()));
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              padding:
                              const EdgeInsets.fromLTRB(20, 30, 20, 30),
                              shadowColor: shadowColor,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(3))),
                            ),
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    child: const Icon(
                                      Icons.login_rounded,
                                      size: 50,
                                      color: mainColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    child: const Text(
                                      "Declaratie uploaden",
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: mainColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Icon
                      GestureDetector(
                        onTap: () {
                          
                        },
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: mainColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  // Button 2
                  if (UserData.role == Roles.Admin)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Declarations()));
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: mainColor,
                              padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                              shadowColor: mainColor,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(3))),
                            ),
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width:
                                    MediaQuery.of(context).size.width * 0.25,
                                    child: const Icon(
                                      Icons.logout_rounded,
                                      size: 50,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width:
                                    MediaQuery.of(context).size.width * 0.75,
                                    child: const Text(
                                      "Declaraties goedkeuren",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Icon
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const Declarations()));
                          },
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: mainColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(
                    height: 30,
                  ),

                  // Button 2
                  if (UserData.role == Roles.Admin)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const DeclarationsPayout()));
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: mainColor,
                            padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                            shadowColor: mainColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(3))),
                          ),
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width * 0.25,
                                  child: const Icon(
                                    Icons.logout_rounded,
                                    size: 50,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width * 0.75,
                                  child: const Text(
                                    "Declaraties uitbetalen",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Icon
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Declarations()));
                        },
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: mainColor,
                          ),
                        ),
                      ),
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