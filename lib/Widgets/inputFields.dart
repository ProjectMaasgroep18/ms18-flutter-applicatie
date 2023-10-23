import 'package:flutter/material.dart';
import 'package:ms18_applicatie/config.dart';

class InputField extends StatelessWidget {
  final IconData? icon;
  final String? hintText;
  final String? labelText;
  final TextAlign? textAlign;

  final TextEditingController? controller;
  const InputField({
    super.key,
    this.icon,
    this.hintText,
    this.labelText,
    this.controller,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: textAlign??TextAlign.start,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        hintText: hintText,
        labelText: labelText,
        hintStyle: const TextStyle(
          color: mainColor,
          fontWeight: FontWeight.w300,
        ),
        enabledBorder: inputBorder,
        focusedBorder: inputBorder,
        border: inputBorder,
        prefixIcon: icon != null
            ? Align(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: Icon(
                  icon!,
                  color: mainColor,
                  size: 20,
                ),
              )
            : null,
      ),
    );
  }
}
