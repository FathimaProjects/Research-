import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// Pixel-perfect vector render of the Citrus AI circular logo with citrus slice and orange leaf
class CitrusLogo extends StatelessWidget {
  final double size;
  final bool showBadge;

  const CitrusLogo({
    super.key,
    this.size = 64,
    this.showBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Main Forest Green Circle
          Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              color: AppColors.primaryGreen,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomPaint(
                size: Size(size * 0.58, size * 0.58),
                painter: _CitrusSlicePainter(),
              ),
            ),
          ),

          // Orange Leaf Badge at 1 o'clock
          if (showBadge)
            Positioned(
              top: -size * 0.04,
              right: -size * 0.04,
              child: Container(
                width: size * 0.36,
                height: size * 0.36,
                decoration: BoxDecoration(
                  color: AppColors.citrusOrange,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size * 0.25),
                    bottomRight: Radius.circular(size * 0.25),
                    topRight: Radius.circular(size * 0.1),
                    bottomLeft: Radius.circular(size * 0.1),
                  ),
                  border: Border.all(
                    color: AppColors.warmCream,
                    width: size * 0.03,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.eco,
                    color: AppColors.forestGreen,
                    size: size * 0.2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CitrusSlicePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Half-circle / slice outer arc
    canvas.drawArc(rect, 0.2, math.pi * 0.95, false, paint);

    // Slice segments radiating from center
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final radius = size.width * 0.44;

    for (int i = 0; i < 4; i++) {
      final angle = 0.5 + (i * 0.65);
      final p2 = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(center, p2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

