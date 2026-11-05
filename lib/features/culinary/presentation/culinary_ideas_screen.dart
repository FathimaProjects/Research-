import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../data/culinary_service.dart';
import '../domain/recipe_item.dart';

class CulinaryIdeasScreen extends StatefulWidget {
  final String fruitName;

  const CulinaryIdeasScreen({
    super.key,
    required this.fruitName,
  });

  @override
  State<CulinaryIdeasScreen> createState() => _CulinaryIdeasScreenState();
}

class _CulinaryIdeasScreenState extends State<CulinaryIdeasScreen> {
  final CulinaryService _culinaryService = CulinaryService();
  List<RecipeItem> _recipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCulinarySuggestions();
  }

  Future<void> _loadCulinarySuggestions() async {
    final ideas = await _culinaryService.getCulinaryIdeas(widget.fruitName);
    if (mounted) {
      setState(() {
        _recipes = ideas;
        _isLoading = false;
      });
    }
  }

  Future<void> _launchRecipeUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open external recipe link.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching link: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(
        title: Text('${widget.fruitName} Culinary Ideas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGreen),
              )
            : _recipes.isEmpty
                ? const Center(
                    child: Text(
                      'No culinary suggestions available for this variety.',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    itemCount: _recipes.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Culinary & Serving Ideas',
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.forestGreen,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Explore verified preparation methods and video guides featuring ${widget.fruitName}.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.forestGreen.withOpacity(0.75),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final recipe = _recipes[index - 1];
                      return _buildRecipeCard(recipe);
                    },
                  ),
      ),
    );
  }

  Widget _buildRecipeCard(RecipeItem recipe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipe Image
          if (recipe.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                recipe.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    color: AppColors.softSage,
                    child: const Center(
                      child: Icon(Icons.restaurant, color: AppColors.primaryGreen, size: 40),
                    ),
                  );
                },
              ),
            ),

          // Recipe Content
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.forestGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  recipe.description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),

                // "View Recipe >" Button (Only rendered if URL is valid)
                if (recipe.hasValidLink)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => _launchRecipeUrl(recipe.recipeUrl),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        backgroundColor: AppColors.softSage,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_circle_fill, size: 16, color: AppColors.citrusOrange),
                          SizedBox(width: 6),
                          Text(
                            AppStrings.viewRecipe,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
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
        ],
      ),
    );
  }
}

