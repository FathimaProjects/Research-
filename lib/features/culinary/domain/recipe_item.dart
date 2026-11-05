class RecipeItem {
  final String title;
  final String description;
  final String imageUrl;
  final String recipeUrl;

  const RecipeItem({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.recipeUrl,
  });

  bool get hasValidLink => recipeUrl.isNotEmpty && (recipeUrl.startsWith('http://') || recipeUrl.startsWith('https://'));

  factory RecipeItem.fromJson(Map<String, dynamic> json) {
    return RecipeItem(
      title: json['title']?.toString() ?? 'Recipe Idea',
      description: json['description']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      recipeUrl: json['recipeUrl']?.toString() ?? '',
    );
  }
}

