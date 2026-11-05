import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../core/widgets/citrus_logo.dart';
import '../../../core/widgets/prototype_badge.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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

              const SizedBox(height: 24),

              Text(
                'About Citrus AI',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.forestGreen,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'An intelligent botanical recognition system developed as an 8th-semester university research prototype.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.forestGreen.withOpacity(0.75),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 24),

              // Card: Machine Learning Architecture
              _buildInfoCard(
                icon: Icons.memory,
                title: 'On-Device Machine Learning',
                content:
                    'Powered by a fine-tuned MobileNetV2 convolutional neural network running locally via TensorFlow Lite. Inference executes directly on the device, ensuring ultra-low latency and user privacy without transmitting image scans to external servers.',
              ),

              const SizedBox(height: 16),

              // Card: Supported Species
              _buildInfoCard(
                icon: Icons.eco,
                title: '5 Supported Citrus Classes',
                content:
                    '1. Sweet Orange (Citrus sinensis)\n2. Mandarin / Tangerine (Citrus reticulata)\n3. Lemon (Citrus limon)\n4. Lime (Citrus aurantiifolia)\n5. Kaffir / Makrut Lime (Citrus hystrix)',
              ),

              const SizedBox(height: 16),

              // Card: Verified Static Knowledge Base
              _buildInfoCard(
                icon: Icons.menu_book,
                title: 'Verified Knowledge Base',
                content:
                    'All nutritional values, allergy profiles, and health characteristics are derived strictly from verified static datasets and agricultural laboratory findings. When verified data is missing, the system strictly reports "Information unavailable" rather than approximating.',
              ),

              const SizedBox(height: 16),

              // Card: Secure Gemini Suggestions
              _buildInfoCard(
                icon: Icons.auto_awesome,
                title: 'Culinary Suggestions & Recipes',
                content:
                    'Culinary recipe recommendations and serving ideas are assisted by Google Gemini through a secure backend proxy. The mobile app never exposes credentials, and suggestions only link to verified culinary publications and video tutorials.',
              ),

              const SizedBox(height: 16),

              // Card: Privacy & Guest Access
              _buildInfoCard(
                icon: Icons.security,
                title: 'Privacy & Guest Access',
                content:
                    'Citrus AI requires no registration, passwords, or personal credentials. No scan history is recorded on remote databases, protecting individual privacy.',
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.softSage,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primaryGreen, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.forestGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

