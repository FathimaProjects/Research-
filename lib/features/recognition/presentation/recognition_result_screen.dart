import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/circular_back_button.dart';
import '../../culinary/presentation/culinary_ideas_screen.dart';
import '../../knowledge/data/knowledge_repository.dart';
import '../../knowledge/presentation/allergy_health_screen.dart';
import '../../knowledge/presentation/nutrition_screen.dart';
import '../domain/recognition_result.dart';

class RecognitionResultScreen extends StatefulWidget {
  final RecognitionResult result;

  const RecognitionResultScreen({
    super.key,
    required this.result,
  });

  @override
  State<RecognitionResultScreen> createState() => _RecognitionResultScreenState();
}

class _RecognitionResultScreenState extends State<RecognitionResultScreen> {
  final KnowledgeRepository _repository = KnowledgeRepository();
  String? _scientificName;

  @override
  void initState() {
    super.initState();
    _fetchScientificName();
  }

  Future<void> _fetchScientificName() async {
    // Only retrieve fruit information from Firestore for supported, confident predictions
    if (!widget.result.isSupported) return;

    final knowledge = await _repository.getFruitKnowledge(widget.result.predictedClass);
    if (mounted && knowledge != null) {
      if (knowledge.scientificName.isNotEmpty &&
          knowledge.scientificName != 'Information unavailable') {
        setState(() {
          _scientificName = knowledge.scientificName;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: SafeArea(
        child: SingleChildScrollView(
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
                    'Recognition result',
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

              // Hero Image with Overlapping Floating Prediction Card
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  // Main Image Container
                  Container(
                    width: double.infinity,
                    height: 270,
                    margin: const EdgeInsets.only(bottom: 40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.file(
                        File(widget.result.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Floating Overlapping Card: Model Prediction
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.07),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'MODEL PREDICTION',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              // Citrus Orange icon avatar
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: AppColors.citrusOrange,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.eco,
                                    color: AppColors.forestGreen,
                                    size: 26,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.result.predictedClass,
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.forestGreen,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    if (_scientificName != null) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        _scientificName!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryGreen,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 2),
                                    Text(
                                      '${widget.result.confidencePercentage} model confidence',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textMuted,
                                        fontWeight: FontWeight.w500,
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
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const SizedBox(height: 16),

              // Dark Forest Green Confidence Card
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Model confidence',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          widget.result.confidencePercentage,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Progress bar track
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        height: 6,
                        width: double.infinity,
                        color: const Color(0xFF245445),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: widget.result.confidence.clamp(0.0, 1.0),
                            child: Container(
                              color: AppColors.citrusOrange,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'High model confidence. A prediction is not a confirmed botanical identity.',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.white.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Grouped Navigation Card (Nutrition, Allergy & Health, Culinary Ideas)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    _buildNavItem(
                      icon: Icons.menu_book_outlined,
                      title: 'Nutrition',
                      subtitle: 'Verified database fields',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => NutritionScreen(
                              fruitName: widget.result.predictedClass,
                              imagePath: widget.result.imagePath,
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, color: AppColors.borderLight),
                    _buildNavItem(
                      icon: Icons.verified_user_outlined,
                      title: 'Allergy & Health',
                      subtitle: 'Precautions and references',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AllergyHealthScreen(fruitName: widget.result.predictedClass),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, color: AppColors.borderLight),
                    _buildNavItem(
                      icon: Icons.restaurant_outlined,
                      title: 'Culinary Ideas',
                      subtitle: 'AI-assisted inspiration',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CulinaryIdeasScreen(fruitName: widget.result.predictedClass),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Bottom Button: Identify Another Fruit
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.forestGreen,
                    side: const BorderSide(color: AppColors.borderLight, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh, size: 18, color: AppColors.forestGreen),
                      SizedBox(width: 8),
                      Text(
                        'Identify Another Fruit',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.forestGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryGreen, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.forestGreen,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textLight,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
