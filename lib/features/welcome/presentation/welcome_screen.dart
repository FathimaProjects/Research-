import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../core/widgets/citrus_logo.dart';
import '../../../core/widgets/prototype_badge.dart';
import '../../shell/presentation/main_navigation_shell.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Brand Logo + Research Prototype Badge
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CitrusLogo(size: 32, showBadge: false),
                      SizedBox(width: 10),
                      Text(
                        AppStrings.appName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.forestGreen,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  PrototypeBadge(text: AppStrings.researchPrototype),
                ],
              ),

              const SizedBox(height: 20),

              // Hero Image Container with Rounded Corners & Floating Pill
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.forestGreen.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        // Hero Image
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/welcome_hero.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Elegant fallback if asset file path differs
                              return Container(
                                color: AppColors.softSage,
                                child: const Center(
                                  child: CitrusLogo(size: 90),
                                ),
                              );
                            },
                          ),
                        ),

                        // Bottom-Left Floating Pill Badge: 5 citrus varieties
                        Positioned(
                          left: 16,
                          bottom: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.92),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.eco_outlined,
                                  size: 16,
                                  color: AppColors.forestGreen,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  AppStrings.fiveVarietiesBadge,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.forestGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Text Content Section
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kicker
                        const Text(
                          AppStrings.welcomeKicker,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Headline
                        Text(
                          AppStrings.welcomeHeadline,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                height: 1.15,
                                color: AppColors.forestGreen,
                              ),
                        ),
                        const SizedBox(height: 12),

                        // Subtitle
                        Text(
                          AppStrings.welcomeSubtitle,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.forestGreen.withOpacity(0.75),
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),

                    // Bottom Action Area
                    Column(
                      children: [
                        // Continue as Guest Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const MainNavigationShell(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                              foregroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_forward, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  AppStrings.continueAsGuest,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Disclaimer Note
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.verified_user_outlined,
                              size: 14,
                              color: AppColors.forestGreen.withOpacity(0.6),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                AppStrings.guestDisclaimer,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.forestGreen.withOpacity(0.65),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

