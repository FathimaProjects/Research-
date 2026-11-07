import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../core/widgets/circular_back_button.dart';
import '../data/knowledge_repository.dart';
import '../domain/citrus_knowledge_model.dart';

class NutritionScreen extends StatefulWidget {
  final String fruitName;
  final String? imagePath;

  const NutritionScreen({
    super.key,
    required this.fruitName,
    this.imagePath,
  });

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final KnowledgeRepository _repository = KnowledgeRepository();
  CitrusKnowledge? _knowledge;
  bool _isLoading = true;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final result = await _repository.getFruitKnowledge(widget.fruitName);
    if (mounted) {
      setState(() {
        _knowledge = result;
        _isOffline = (result == null);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGreen),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row: Circular Back Button + Centered Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircularBackButton(
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const Text(
                          'Nutrition Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.forestGreen,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(width: 44),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Forest Green Hero Card with Fruit Thumbnail
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.forestGreen,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Stack(
                        children: [
                          // Background subtle circular ripple watermark
                          Positioned(
                            right: -20,
                            top: -20,
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.white.withValues(alpha: 0.08),
                                  width: 20,
                                ),
                              ),
                            ),
                          ),

                          Row(
                            children: [
                              // Fruit Thumbnail Image (User's provided fruit image)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: (widget.imagePath != null &&
                                        widget.imagePath!.isNotEmpty &&
                                        File(widget.imagePath!).existsSync())
                                    ? Image.file(
                                        File(widget.imagePath!),
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            _buildFallbackThumbnail(),
                                      )
                                    : _buildFallbackThumbnail(),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'SELECTED FRUIT',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: AppColors.softSage.withValues(alpha: 0.9),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.fruitName,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.white,
                                        letterSpacing: -0.4,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _knowledge != null
                                          ? 'Serving basis: ${_knowledge!.servingSize}'
                                          : 'Serving basis: Per 100 g',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.white.withValues(alpha: 0.75),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    if (_isOffline) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDE8E8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF8B4B4)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.wifi_off_rounded, color: Color(0xFFC53030), size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Offline - Information Unavailable',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF9B1C1C),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Verified nutrition records require an active internet connection to retrieve.',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: const Color(0xFF9B1C1C).withValues(alpha: 0.85),
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: _loadData,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Retry',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF9B1C1C),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Nutrition Rows Card (Figma Layout with Orange Dot & Pill Values)
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        children: [
                          _buildNutrientRow(
                            'Energy',
                            _getNutrientValue('calories'),
                          ),
                          const Divider(height: 1, color: AppColors.borderLight),
                          _buildNutrientRow(
                            'Carbohydrates',
                            _getNutrientValue('carbs'),
                          ),
                          const Divider(height: 1, color: AppColors.borderLight),
                          _buildNutrientRow(
                            'Sugar',
                            _getNutrientValue('sugar'),
                          ),
                          const Divider(height: 1, color: AppColors.borderLight),
                          _buildNutrientRow(
                            'Fiber',
                            _getNutrientValue('fiber'),
                          ),
                          const Divider(height: 1, color: AppColors.borderLight),
                          _buildNutrientRow(
                            'Protein',
                            _getNutrientValue('protein'),
                          ),
                          const Divider(height: 1, color: AppColors.borderLight),
                          _buildNutrientRow(
                            'Fat',
                            _getNutrientValue('fat'),
                          ),
                          const Divider(height: 1, color: AppColors.borderLight),
                          _buildNutrientRow(
                            'Vitamin C',
                            _getNutrientValue('vitaminC'),
                          ),
                          const Divider(height: 1, color: AppColors.borderLight),
                          _buildNutrientRow(
                            'Selected minerals',
                            _getMineralsValue(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Dark Forest Green Verified Source Record Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.forestGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.verified_user_outlined,
                                size: 18,
                                color: AppColors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Verified source record',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                          
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
      ),
    );
  }

  String _getNutrientValue(String key) {
    if (_knowledge == null) return AppStrings.infoUnavailable;
    final val = _knowledge!.nutrition[key];
    if (val == null || val.isEmpty) return AppStrings.infoUnavailable;
    return val;
  }

  String _getMineralsValue() {
    if (_knowledge == null) return AppStrings.infoUnavailable;
    final parts = <String>[];
    final ca = _knowledge!.nutrition['calcium'];
    final fe = _knowledge!.nutrition['iron'];
    final k = _knowledge!.nutrition['potassium'];

    if (ca != null && ca.isNotEmpty && ca != AppStrings.infoUnavailable) parts.add('Ca: $ca');
    if (fe != null && fe.isNotEmpty && fe != AppStrings.infoUnavailable) parts.add('Fe: $fe');
    if (k != null && k.isNotEmpty && k != AppStrings.infoUnavailable) parts.add('K: $k');

    if (parts.isNotEmpty) {
      return parts.join(', ');
    }
    return AppStrings.infoUnavailable;
  }

  Widget _buildNutrientRow(String label, String value) {
    final isUnavailable = value == AppStrings.infoUnavailable;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Orange bullet dot
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.citrusOrange,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.forestGreen,
                ),
              ),
            ],
          ),
          // Value Pill Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isUnavailable ? FontWeight.w400 : FontWeight.w600,
                color: isUnavailable ? AppColors.textMuted : AppColors.primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackThumbnail() {
    return Image.asset(
      'assets/images/welcome_hero.jpg',
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: 80,
        height: 80,
        color: AppColors.primaryGreen,
        child: const Icon(
          Icons.eco,
          color: AppColors.white,
          size: 36,
        ),
      ),
    );
  }
}
