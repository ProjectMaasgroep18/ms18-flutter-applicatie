import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Login/screens/components/components/gastInlog.dart';
import 'package:ms18_applicatie/Login/screens/components/components/guestSigninForm.dart';
import 'package:ms18_applicatie/config.dart';
import 'sign_in_form.dart';

Future<Object?> customSigninDialog(BuildContext context,
    {required ValueChanged onClosed}) {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: "Sign up",
    context: context,
    transitionDuration: const Duration(milliseconds: 800),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      Tween<Offset> tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      return SlideTransition(
          position: tween.animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
          child: child);
    },
    pageBuilder: (context, _, __) => Center(
      child: Container(
        height: 520,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 46),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(1),
          borderRadius: const BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        child: const Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset:
              false, // avoid overflow error when keyboard shows up
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(children: [
                Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 34,
                    fontFamily: "Poppins",
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                SizedBox(
                  height: 65,
                ),
                SignInForm(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text("", style: TextStyle(color: Colors.black54)),
                ),
              ]),
              Positioned(
                left: 0,
                right: 0,
                bottom: -48,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close, color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  ).then(onClosed);
}

Future<Object?> customGuestLogin(BuildContext context,
    {required ValueChanged onClosed}) {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: "Sign up",
    context: context,
    transitionDuration: const Duration(milliseconds: 800),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      Tween<Offset> tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      return SlideTransition(
          position: tween.animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
          child: child);
    },
    pageBuilder: (context, _, __) => Center(
      child: Container(
        height: 520,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 46),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(1),
          borderRadius: const BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        child: const Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset:
              false, // avoid overflow error when keyboard shows up
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(children: [
                Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 34,
                    fontFamily: "Poppins",
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                SizedBox(
                  height: 65,
                ),
                GuestSignInForm(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text("", style: TextStyle(color: Colors.black54)),
                ),
              ]),
              Positioned(
                left: 0,
                right: 0,
                bottom: -48,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close, color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  ).then(onClosed);
}

Future<Object?> customGastDialog(BuildContext context,
    {required ValueChanged onClosed}) {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: "Sign up",
    context: context,
    transitionDuration: const Duration(milliseconds: 800),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      Tween<Offset> tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      return SlideTransition(
          position: tween.animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
          child: child);
    },
    pageBuilder: (context, _, __) => Center(
      child: Container(
        height: 520,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 46),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(1),
          borderRadius: const BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        child: const Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset:
              false, // avoid overflow error when keyboard shows up
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(children: [
                Text(
                  "Nieuw bij Maasgroep 18?",
                  style: TextStyle(
                    fontSize: 34,
                    fontFamily: "Poppins",
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                SizedBox(
                  height: 65,
                ),
                GastInfrom(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text("", style: TextStyle(color: Colors.black54)),
                ),
              ]),
              Positioned(
                left: 0,
                right: 0,
                bottom: -48,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close, color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  ).then(onClosed);
}
