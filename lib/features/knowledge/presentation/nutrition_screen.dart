import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../core/widgets/circular_back_button.dart';
import '../data/knowledge_repository.dart';
import '../domain/citrus_knowledge_model.dart';

class NutritionScreen extends StatefulWidget {
  final String fruitName;

  const NutritionScreen({
    super.key,
    required this.fruitName,
  });

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final KnowledgeRepository _repository = KnowledgeRepository();
  CitrusKnowledge? _knowledge;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final result = await _repository.getFruitKnowledge(widget.fruitName);
    if (mounted) {
      setState(() {
        _knowledge = result;
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
                              // Fruit Thumbnail Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
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
                                ),
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

                    // Curated Knowledge Database Notice Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.softSage.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.verified_user_outlined,
                            size: 18,
                            color: AppColors.primaryGreen,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Only values supplied by the curated knowledge database appear here.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.forestGreen.withValues(alpha: 0.85),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

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
                            'Sugars',
                            _getNutrientValue('sugar'),
                          ),
                          const Divider(height: 1, color: AppColors.borderLight),
                          _buildNutrientRow(
                            'Fibre',
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
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
                          const SizedBox(height: 8),
                          Text(
                            'Source attribution will appear when a matched knowledge record is available.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.white.withValues(alpha: 0.8),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Last updated: Information unavailable',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.white.withValues(alpha: 0.55),
                            ),
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
    final calcium = _knowledge!.nutrition['calcium'];
    final potassium = _knowledge!.nutrition['potassium'];
    if (calcium != null && potassium != null && calcium != AppStrings.infoUnavailable) {
      return 'Ca: $calcium, K: $potassium';
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
}
