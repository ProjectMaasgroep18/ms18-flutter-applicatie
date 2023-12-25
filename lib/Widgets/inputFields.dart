import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ms18_applicatie/config.dart';

String? validation(String? value, bool isRequired,
    String? Function(String?)? validator, String? labelText,
    [bool isDouble = false, bool isInt = false]) {
  // Checking if the field is required
  if (isRequired) {
    if ((value ?? '') == '') {
      return "${labelText ?? "Dit veld"} is verplicht";
    }
  }

  // Checking if the value is a proper double
  if (isDouble && double.tryParse(value ?? '') == null) {
    return "${labelText ?? "Dit veld"} heeft een incorrect komma getal format";
  }

  // Checking if the value is a proper integer
  if (isInt && int.tryParse(value ?? '') == null) {
    return "${labelText ?? "Dit veld"} heeft een incorrect getal format";
  }

// Checking if a custom validator is present then use it
  if (validator != null) {
    return validator(value);
  }
  return null;
}

InputDecoration getInputDecoration(bool isUnderlineBorder, String? hintText,
    String? labelText, IconData? icon) {
  return InputDecoration(
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
              icon,
              color: mainColor,
              size: 20,
            ),
          )
        : null,
  );
}

class InputField extends StatelessWidget {
  final IconData? icon;
  final String? hintText;
  final String? labelText;
  final TextAlign? textAlign;
  final bool isUnderlineBorder;
  final bool isPassword;
  final bool isInt;
  final bool isDouble;
  final bool isRequired;
  final String? Function(String?)? validator;
  final Function(String?)? onChange;

  final TextEditingController? controller;
  const InputField(
      {super.key,
      this.icon,
      this.hintText,
      this.labelText,
      this.controller,
      this.textAlign,
      this.isUnderlineBorder = true,
      this.isPassword = false,
      this.isInt = false,
      this.isRequired = true,
      this.validator,
      this.isDouble = false,
      this.onChange});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) =>
          validation(value, isRequired, validator, labelText, isDouble, isInt),
      obscureText: isPassword,
      textAlign: textAlign ?? TextAlign.start,
      keyboardType:
          (isInt || isDouble) ? TextInputType.phone : TextInputType.text,
      inputFormatters: [
        if (isInt) FilteringTextInputFormatter.digitsOnly,
        if (isDouble)
          FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?([0-9]{1,2})?$'))
      ],
      onChanged: onChange,
      decoration:
          getInputDecoration(isUnderlineBorder, hintText, labelText, icon),
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
      decoration: getInputDecoration(widget.isUnderlineBorder, widget.hintText, widget.labelText, null),
      onChanged: (newValue) {
        if (widget.onChange != null) widget.onChange!(newValue);

        setState(() {
          widget.value = newValue;
        });
      },
    );
  }
}
