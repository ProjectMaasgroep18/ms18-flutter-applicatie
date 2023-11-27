import 'package:flutter/material.dart';
import 'package:ms18_applicatie/config.dart';

class InputField extends StatelessWidget {
  final IconData? icon;
  final String? hintText;
  final String? labelText;
  final TextAlign? textAlign;
  final bool isUnderlineBorder;
  final bool isPassword;
  final bool isNumeric;

  final TextEditingController? controller;
  const InputField({
    super.key,
    this.icon,
    this.hintText,
    this.labelText,
    this.controller,
    this.textAlign,
    this.isUnderlineBorder = false,
    this.isPassword = false,
    this.isNumeric = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      textAlign: textAlign ?? TextAlign.start,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            vertical: 10, horizontal: isUnderlineBorder ? 0 : 15),
        isDense: true,
        hintText: hintText,
        labelText: labelText,
        hintStyle: const TextStyle(
          color: mainColor,
          fontWeight: FontWeight.w300,
        ),
        enabledBorder: isUnderlineBorder ? inputUnderlineBorder : inputBorder,
        focusedBorder: isUnderlineBorder ? inputUnderlineBorder : inputBorder,
        border: isUnderlineBorder ? inputUnderlineBorder : inputBorder,
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
