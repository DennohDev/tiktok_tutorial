import 'package:flutter/material.dart';
import 'package:tiktok_tutorial/constants.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isObscure;
  final IconData icon;
  final String labelText;
  const TextInputField({super.key, required this.controller, required this.isObscure, required this.icon, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        labelStyle: TextStyle(fontSize: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: borderColor),
        ),
      ),
    );
  }
}
