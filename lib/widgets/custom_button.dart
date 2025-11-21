import 'package:flutter/material.dart';
import '../utils/app_colors.dart';


class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const CustomButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
      child: Text(title, style: const TextStyle(color: Colors.white)),
    );
  }
}