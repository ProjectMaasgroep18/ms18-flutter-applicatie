import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Widgets/buttons.dart';
import 'package:ms18_applicatie/config.dart';

Future showInputPopup(BuildContext context,
    {required String title,
    required Widget child,
    required Function() onSave,
    double height = 220}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            const Divider(
              color: secondColor,
            )
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        content: Container(
          width: double.maxFinite,
          height: height,
          color: Colors.white,
          child: child,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Sluit het dialoogvenster
            },
            child: const Text('Terug'),
          ),
          SizedBox(
            width: 150,
            child: Button(
              onTap: () {
                Navigator.pop(context);
                onSave();
              },
              text: 'Opslaan',
            ),
          )
        ],
      );
    },
  );
}
