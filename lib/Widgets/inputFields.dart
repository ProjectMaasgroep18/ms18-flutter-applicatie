import 'package:flutter/material.dart';
import 'package:ms18_applicatie/config.dart';

String? validation(String? value, bool isRequired,
    String? Function(String?)? validator, String? labelText) {
  if (isRequired) {
    if ((value ?? '') == '') {
      return "${labelText ?? "Dit veld"} is verplicht";
    }
  }

  if (validator != null) {
    validator(value);
  }
}

class InputField extends StatelessWidget {
  final IconData? icon;
  final String? hintText;
  final String? labelText;
  final TextAlign? textAlign;
  final bool isUnderlineBorder;
  final bool isPassword;
  final bool isNumeric;
  final bool isRequired;
  final String? Function(String?)? validator;

  final TextEditingController? controller;
  const InputField({
    super.key,
    this.icon,
    this.hintText,
    this.labelText,
    this.controller,
    this.textAlign,
    this.isUnderlineBorder = true,
    this.isPassword = false,
    this.isNumeric = false,
    this.isRequired = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) => validation(value, isRequired, validator, labelText),
      obscureText: isPassword,
      textAlign: textAlign ?? TextAlign.start,
      keyboardType: isNumeric ? TextInputType.phone : TextInputType.text,
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

class InputDropDown extends StatefulWidget {
  InputDropDown({
    super.key,
    required this.items,
    this.value,
    this.onChange,
    this.hintText,
    this.isUnderlineBorder = true,
    this.labelText,
    this.isRequired = true,
    this.validator,
  });

  final List<DropdownMenuItem<String>> items;
  final Function(String? value)? onChange;
  final String? hintText;
  final String? labelText;
  final bool isUnderlineBorder;
  String? value;
  final bool isRequired;
  final String? Function(String?)? validator;

  @override
  State<InputDropDown> createState() => _InputDropDownState();
}

class _InputDropDownState extends State<InputDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      items: widget.items,
      value: widget.value,
      isExpanded: true,
      validator: (value) => validation(
          value, widget.isRequired, widget.validator, widget.labelText),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            vertical: 10, horizontal: widget.isUnderlineBorder ? 0 : 15),
        isDense: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        hintStyle: const TextStyle(
          color: mainColor,
          fontWeight: FontWeight.w300,
        ),
        enabledBorder:
            widget.isUnderlineBorder ? inputUnderlineBorder : inputBorder,
        focusedBorder:
            widget.isUnderlineBorder ? inputUnderlineBorder : inputBorder,
        border: widget.isUnderlineBorder ? inputUnderlineBorder : inputBorder,
      ),
      onChanged: (newValue) {
        if (widget.onChange != null) widget.onChange!(newValue);

        setState(() {
          widget.value = newValue;
        });
      },
    );
  }
}
