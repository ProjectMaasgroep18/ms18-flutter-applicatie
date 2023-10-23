
import 'package:flutter/material.dart';
import 'package:ms18_applicatie/config.dart';

class Button extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final Function() onTap;
  const Button({
    super.key,
    this.icon,
    this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: mainColor,
        minimumSize: const Size(10, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: Colors.white,
            ),
          if (text != null)
            const SizedBox(
              width: 5,
            ),
          if (text != null)
            Text(
              text!,
              style: const TextStyle(color: Colors.white),
            )
        ],
      ),
    );
  }
}
