import 'package:flutter/material.dart';

import '../../Declarations/pickPhoto.dart';
import '../../config.dart';
import '../../menu.dart';

class Declarations extends StatefulWidget {
  const Declarations({Key? key}) : super(key: key);

  @override
  State<Declarations> createState() => DeclarationsState();
}

class DeclarationsState extends State<Declarations> {
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
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {

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
                                  child: Text(
                                    "Btn2",
                                    style: const TextStyle(fontSize: 30),
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

                  // Button 3
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
                                      Icons.move_down_rounded,
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
                                    child: Text(
                                      "",
                                      style: const TextStyle(
                                          fontSize: 30,
                                          color: secondColor),
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

                  // Button 4
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

                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: mainColor,
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
                                      Icons.history,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    child: Text(
                                      "",
                                      style: const TextStyle(
                                          fontSize: 30,
                                          color: Colors.white),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}