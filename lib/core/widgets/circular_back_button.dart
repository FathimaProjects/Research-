import 'package:flutter/material.dart';
import '../constants/colors.dart';

class CircularBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CircularBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.of(context).pop(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.arrow_back,
            size: 20,
            color: AppColors.forestGreen,
          ),
        ),
      ),
    );
  }
}

