class RecognitionResult {
  final String predictedClass;
  final double confidence;
  final String imagePath;
  final Map<String, double> allScores;
  final bool isSupported;

  const RecognitionResult({
    required this.predictedClass,
    required this.confidence,
    required this.imagePath,
    required this.allScores,
    required this.isSupported,
  });

  String get confidencePercentage => '${(confidence * 100).toStringAsFixed(1)}%';

  /// Factory constructor for unsupported or low-confidence recognition
  factory RecognitionResult.unsupported({
    required String imagePath,
    double highestConfidence = 0.0,
    String tentativeClass = 'Unknown',
  }) {
    return RecognitionResult(
      predictedClass: tentativeClass,
      confidence: highestConfidence,
      imagePath: imagePath,
      allScores: const {},
      isSupported: false,
    );
  }
}

