import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../core/widgets/citrus_logo.dart';
import '../../welcome/presentation/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _progressController.forward();

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const WelcomeScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 600),
              ),
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: SafeArea(
        child: Stack(
          children: [
            // Background subtle organic botanical leaf lines
            Positioned.fill(
              child: CustomPaint(
                painter: _BotanicalBackgroundPainter(),
              ),
            ),

            // Main Centered Brand Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Concentric circular ripples framing the Citrus Logo
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outermost ripple ring
                      Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.softSage.withValues(alpha: 0.35),
                        ),
                      ),
                      // Middle ripple ring
                      Container(
                        width: 220,
                        height: 220,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.warmCream,
                        ),
                      ),
                      // Inner soft ring
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.softSage,
                            width: 1.5,
                          ),
                        ),
                      ),
                      // Small accent dot on the orbit
                      Positioned(
                        bottom: 40,
                        left: 45,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.citrusOrange,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      // Center Logo
                      const CitrusLogo(size: 78),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Brand Title
                  Text(
                    AppStrings.appName,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: AppColors.forestGreen,
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                        ),
                  ),

                  const SizedBox(height: 10),

                  // Tagline
                  const Text(
                    AppStrings.appTagline,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryGreen,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Progress Bar & University Prototype Footer
            Positioned(
              left: 32,
              right: 32,
              bottom: 36,
              child: Column(
                children: [
                  // Progress Status Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Preparing your citrus guide',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.forestGreen.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        'AI',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Dual-tone Linear Progress Bar
                  AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, _) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          height: 4,
                          width: double.infinity,
                          color: AppColors.softSage,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: _progressAnimation.value,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primaryGreen,
                                      AppColors.citrusOrange,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // University Research Prototype Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        size: 15,
                        color: AppColors.forestGreen.withValues(alpha: 0.65),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        AppStrings.universityResearchPrototype,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: AppColors.forestGreen.withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Painter for organic botanical leaf curve lines in background
class _BotanicalBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.softSage.withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Top Right subtle leaf contour
    final pathTop = Path();
    pathTop.moveTo(size.width * 0.7, 0);
    pathTop.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.12,
      size.width * 0.95,
      size.height * 0.15,
    );
    pathTop.moveTo(size.width * 0.85, size.height * 0.06);
    pathTop.quadraticBezierTo(
      size.width * 0.98,
      size.height * 0.1,
      size.width,
      size.height * 0.18,
    );
    canvas.drawPath(pathTop, paint);

    // Bottom Left subtle leaf contour
    final pathBottom = Path();
    pathBottom.moveTo(size.width * 0.25, size.height);
    pathBottom.quadraticBezierTo(
      size.width * 0.18,
      size.height * 0.88,
      size.width * 0.05,
      size.height * 0.85,
    );
    pathBottom.moveTo(size.width * 0.15, size.height * 0.92);
    pathBottom.quadraticBezierTo(
      size.width * 0.05,
      size.height * 0.88,
      0,
      size.height * 0.78,
    );
    canvas.drawPath(pathBottom, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
