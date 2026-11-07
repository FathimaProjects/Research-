import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/circular_back_button.dart';
import '../data/knowledge_repository.dart';
import '../domain/citrus_knowledge_model.dart';

class AllergyHealthScreen extends StatefulWidget {
  final String fruitName;

  const AllergyHealthScreen({
    super.key,
    required this.fruitName,
  });

  @override
  State<AllergyHealthScreen> createState() => _AllergyHealthScreenState();
}

class _AllergyHealthScreenState extends State<AllergyHealthScreen> {
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
                          'Allergy & Health',
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

                    // Forest Green Hero Card: "Understand with care."
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppColors.forestGreen,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -30,
                            bottom: -30,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.white.withValues(alpha: 0.08),
                                  width: 25,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'GENERAL INFORMATION',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: AppColors.citrusOrange,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Understand with care.',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Food responses vary between individuals. This guidance is informational, not diagnostic.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.white.withValues(alpha: 0.8),
                                  height: 1.45,
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
                                    'Fruit-specific precautions require an active internet connection to retrieve.',
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

                    // Important Medical Notice Card (Amber/Orange Border)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9F2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.citrusOrange.withValues(alpha: 0.85),
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 18,
                                color: Color(0xFFC26E17),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Important medical notice',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF78350F),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Citrus AI does not diagnose allergies or provide personal medical advice. Seek qualified care for individual concerns or urgent symptoms.',
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xFF92400E).withValues(alpha: 0.9),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Card 1: Individual Responses Differ
                    Container(
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
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppColors.softSage.withValues(alpha: 0.7),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.eco_outlined,
                                    size: 20,
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Individual responses differ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.forestGreen,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'A reaction to one citrus variety does not automatically mean every person must avoid all citrus. Advice should be based on individual clinical assessment.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.forestGreen.withValues(alpha: 0.75),
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Card 2: Verified Precautions
                    Container(
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
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppColors.softSage.withValues(alpha: 0.7),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.verified_user_outlined,
                                    size: 20,
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Verified precautions',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.forestGreen,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _knowledge != null
                                ? '${_knowledge!.allergyInfo.citrusAllergy} ${_knowledge!.allergyInfo.sensitivityAdvice}'
                                : 'Fruit-specific precautions and references will display only after a verified database match is available.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.forestGreen.withValues(alpha: 0.75),
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Footer Card: References (Dark Forest Green)
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
                                Icons.menu_book_outlined,
                                size: 18,
                                color: AppColors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'References',
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
                            'Verified source informations are shown here',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.white.withValues(alpha: 0.75),
                              height: 1.4,
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
}
