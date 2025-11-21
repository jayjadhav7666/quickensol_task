import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.isPassword = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscure : false,
        onTapOutside: (_){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        decoration: InputDecoration(
          labelText: widget.hint,
          filled: true,
          fillColor: Colors.grey.shade100,

          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon)
              : null,
          suffixIcon: widget.isPassword
              ? IconButton(
            icon: Icon(
              _obscure ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() => _obscure = !_obscure);
            },
          )
              : widget.suffixIcon != null
              ? IconButton(
            icon: Icon(widget.suffixIcon),
            onPressed: widget.onSuffixTap,
          )
              : null,

          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 18),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
        ),
      ),
    );
  }
}
