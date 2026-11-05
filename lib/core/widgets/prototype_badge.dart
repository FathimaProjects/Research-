import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';

class PrototypeBadge extends StatelessWidget {
  final String text;

  const PrototypeBadge({
    super.key,
    this.text = AppStrings.researchPrototype,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.softSage,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.primaryGreen,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

