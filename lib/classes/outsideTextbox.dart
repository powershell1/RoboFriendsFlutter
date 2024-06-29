import 'package:flutter/material.dart';

class OutsideTextBox extends StatelessWidget {
  final TextEditingController controller;
  final String name;
  final IconData prefixIcon;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;

  const OutsideTextBox({
    Key? key,
    required this.controller,
    required this.name,
    required this.prefixIcon,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    required this.inputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*
    Color borderColor = App.theme.brightness == Brightness.dark
        ? const Color(0xFF4CCD99)
        : const Color(0xFF007F73);

     */
    Color borderColor = const Color(0xFF007F73);

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        enabled: true,
        controller: controller,
        textCapitalization: textCapitalization,
        maxLength: 32,
        maxLines: 1,
        obscureText: obscureText,
        keyboardType: inputType,
        textAlign: TextAlign.start,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon),
          isDense: true,
          labelText: name,
          counterText: "",
          labelStyle:
          TextStyle(color: Colors.black.withAlpha(137)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.black.withAlpha(137)),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
    );
  }
}