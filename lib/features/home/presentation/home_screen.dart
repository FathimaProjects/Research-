import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../core/widgets/citrus_logo.dart';
import '../../../core/widgets/prototype_badge.dart';
import '../../recognition/data/image_picker_service.dart';
import '../../recognition/presentation/image_preview_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleScan(BuildContext context, {required bool isCamera}) async {
    final picker = ImagePickerService();
    final File? file = isCamera
        ? await picker.pickImageFromCamera()
        : await picker.pickImageFromGallery();

    if (file != null && context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ImagePreviewScreen(imageFile: file),
        ),
      );
    }
  }

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

              // Welcome Greeting
              const Text(
                'Welcome, Guest',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGreen,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Identify Your Citrus',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.forestGreen,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Capture or select an image of citrus fruit to recognize its variety, nutritional value, and culinary ideas.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.forestGreen.withOpacity(0.75),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 20),

              // Action Cards: Take a Photo & Choose Image
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context,
                      title: 'Take a Photo',
                      subtitle: 'Use camera',
                      icon: Icons.camera_alt_outlined,
                      isPrimary: true,
                      onTap: () => _handleScan(context, isCamera: true),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildActionCard(
                      context,
                      title: 'Choose Image',
                      subtitle: 'From gallery',
                      icon: Icons.photo_library_outlined,
                      isPrimary: false,
                      onTap: () => _handleScan(context, isCamera: false),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Supported Classes Showcase Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Supported Citrus Species',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.forestGreen,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.softSage,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '5 Classes',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // List of the 5 Supported Varieties
              _buildSpeciesTile('Orange', 'Citrus sinensis', 'Sweet and juicy table citrus', Icons.lens),
              _buildSpeciesTile('Tangerine', 'Citrus reticulata', 'Easy-peel loose skin mandarin', Icons.lens),
              _buildSpeciesTile('Lemon', 'Citrus limon', 'Ellipsoidal sour culinary classic', Icons.lens),
              _buildSpeciesTile('Lime', 'Citrus aurantiifolia', 'Tart key & Persian green citrus', Icons.lens),
              _buildSpeciesTile('Kaffir Lime', 'Citrus hystrix', 'Bumpy rind & fragrant double leaves', Icons.lens),

              const SizedBox(height: 80), // Padding above bottom bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primaryGreen : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isPrimary ? AppColors.primaryGreen : AppColors.borderLight,
          ),
          boxShadow: [
            BoxShadow(
              color: isPrimary
                  ? AppColors.primaryGreen.withOpacity(0.18)
                  : Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isPrimary
                    ? AppColors.white.withOpacity(0.15)
                    : AppColors.softSage,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isPrimary ? AppColors.white : AppColors.primaryGreen,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isPrimary ? AppColors.white : AppColors.forestGreen,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: isPrimary
                    ? AppColors.white.withOpacity(0.8)
                    : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeciesTile(String name, String scientific, String desc, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.softSage,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(
                Icons.eco_rounded,
                color: AppColors.primaryGreen,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.forestGreen,
                  ),
                ),
                Text(
                  scientific,
                  style: const TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

