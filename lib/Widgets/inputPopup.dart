import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Widgets/buttons.dart';
import 'package:ms18_applicatie/Widgets/responsiveness.dart';
import 'package:ms18_applicatie/config.dart';

Future showInputPopup(BuildContext context,
    {required String title,
    required Widget child,
    Function()? onSave,
    double height = 220}) async {
  await showDialog(
    context: context,
    builder: (context) {
      double popupWidth = getResponsifeWidth(context, width: desktopPopupWidth);
      if (popupWidth == double.infinity) popupWidth = double.maxFinite;

      return AlertDialog(
        scrollable: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: SizedBox(
          width: popupWidth,
          child: Column(
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
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        content: SizedBox(
          width: popupWidth,
          child: child,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Sluit het dialoogvenster
            },
            child: const Text('Terug'),
          ),
          if (onSave != null)
            SizedBox(
              width: 150,
              child: Button(
                onTap: () {
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
