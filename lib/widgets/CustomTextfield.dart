import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final IconData? prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  const CustomTextField({
    Key? key,
    this.controller,
    this.labelText,
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.black, fontSize: 16 * textScaleFactor), // Responsive font size
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: const Color(0xff5D56C8),
              )
            : null,
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey, fontSize: 14 * textScaleFactor), // Responsive label size
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(vertical: 16 * textScaleFactor, horizontal: 12 * textScaleFactor), // Responsive padding
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}