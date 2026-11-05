import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../about/presentation/about_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../recognition/data/image_picker_service.dart';
import '../../recognition/presentation/image_preview_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;
  final ImagePickerService _pickerService = ImagePickerService();

  final List<Widget> _screens = [
    const HomeScreen(),
    const AboutScreen(),
  ];

  Future<void> _handleImageSelection({required bool isCamera}) async {
    Navigator.of(context).pop(); // Close bottom sheet
    final File? file = isCamera
        ? await _pickerService.pickImageFromCamera()
        : await _pickerService.pickImageFromGallery();

    if (file != null && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ImagePreviewScreen(imageFile: file),
        ),
      );
    }
  }

  void _showImageSourceModal(BuildContext modalContext) {
    showModalBottomSheet(
      context: modalContext,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Identify Citrus Variety',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.forestGreen,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Capture a clear photo or select from your gallery.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.softSage,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.camera_alt, color: AppColors.primaryGreen),
                  ),
                  title: const Text(
                    'Take a Photo',
                    style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.forestGreen),
                  ),
                  subtitle: const Text('Use your device camera'),
                  onTap: () => _handleImageSelection(isCamera: true),
                ),
                const Divider(height: 1, color: AppColors.borderLight),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.softSage,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.photo_library, color: AppColors.primaryGreen),
                  ),
                  title: const Text(
                    'Choose from Gallery',
                    style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.forestGreen),
                  ),
                  subtitle: const Text('Pick an existing photo'),
                  onTap: () => _handleImageSelection(isCamera: false),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showImageSourceModal(context),
        backgroundColor: AppColors.primaryGreen,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.camera_alt,
          color: AppColors.white,
          size: 26,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: AppColors.white,
        elevation: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home Tab
              InkWell(
                onTap: () => setState(() => _currentIndex = 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.home_filled,
                        color: _currentIndex == 0 ? AppColors.primaryGreen : AppColors.textMuted,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: _currentIndex == 0 ? FontWeight.w700 : FontWeight.w500,
                          color: _currentIndex == 0 ? AppColors.primaryGreen : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 48), // Spacing for central FAB

              // About Tab
              InkWell(
                onTap: () => setState(() => _currentIndex = 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: _currentIndex == 1 ? AppColors.primaryGreen : AppColors.textMuted,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'About',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: _currentIndex == 1 ? FontWeight.w700 : FontWeight.w500,
                          color: _currentIndex == 1 ? AppColors.primaryGreen : AppColors.textMuted,
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
    );
  }
}
