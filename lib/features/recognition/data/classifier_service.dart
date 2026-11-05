import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../domain/recognition_result.dart';

class ClassifierService {
  static const List<String> labels = [
    'Kaffir Lime',
    'Lemon',
    'Lime',
    'Orange',
    'Tangerine',
  ];

  static const int inputSize = 224;
  static const double confidenceThreshold = 0.40; // 60% minimum confidence

  Interpreter? _interpreter;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Load the MobileNetV2 TFLite model from assets
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final options = InterpreterOptions();
      // Use NNAPI delegate on Android if available
      if (Platform.isAndroid) {
        // options.useNnApiForAndroid = true;
      }

      _interpreter = await Interpreter.fromAsset(
        'assets/models/model.tflite',
        options: options,
      );

      _isInitialized = true;
      debugPrint('ClassifierService: MobileNetV2 model loaded successfully.');
      debugPrint('Input shape: ${_interpreter?.getInputTensor(0).shape}');
      debugPrint('Output shape: ${_interpreter?.getOutputTensor(0).shape}');
    } catch (e) {
      debugPrint('ClassifierService initialization error: $e');
      _isInitialized = false;
    }
  }

  /// Perform inference on the provided image file
  Future<RecognitionResult> classifyImage(File imageFile) async {
    if (!_isInitialized || _interpreter == null) {
      await initialize();
    }

    if (_interpreter == null) {
      throw Exception('Classifier model is not initialized.');
    }

    // Read and decode the image bytes
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) {
      throw Exception('Failed to decode image.');
    }

    // Resize image to expected input shape (224x224)
    final resizedImage = img.copyResize(
      image,
      width: inputSize,
      height: inputSize,
    );

    // Prepare input tensor [1, 224, 224, 3] normalized to [-1, 1] for MobileNetV2
    final input = Float32List(1 * inputSize * inputSize * 3);
    var pixelIndex = 0;

    for (var y = 0; y < inputSize; y++) {
      for (var x = 0; x < inputSize; x++) {
        final pixel = resizedImage.getPixel(x, y);
        // MobileNetV2 standard normalization: scale [0, 255] to [-1.0, 1.0]
        input[pixelIndex++] = (pixel.r - 127.5) / 127.5;
        input[pixelIndex++] = (pixel.g - 127.5) / 127.5;
        input[pixelIndex++] = (pixel.b - 127.5) / 127.5;
      }
    }

    // Reshape input to 4D [1, 224, 224, 3]
    final inputBuffer = input.reshape([1, inputSize, inputSize, 3]);

    // Determine output shape
    final outputShape = _interpreter!.getOutputTensor(0).shape;
    final numClasses = outputShape.last;

    // Prepare output buffer [1, numClasses]
    final outputBuffer = List<double>.filled(1 * numClasses, 0.0).reshape([1, numClasses]);

    // Run inference
    _interpreter!.run(inputBuffer, outputBuffer);

    // Extract probabilities
    final rawScores = List<double>.from(outputBuffer[0]);
    final probabilities = _applySoftmax(rawScores);

    // Map probabilities to labels
    final Map<String, double> scoresMap = {};
    for (int i = 0; i < math.min(labels.length, probabilities.length); i++) {
      scoresMap[labels[i]] = probabilities[i];
    }

    // Find highest scoring class
    var highestConfidence = -1.0;
    var predictedIndex = 0;

    for (int i = 0; i < probabilities.length; i++) {
      if (probabilities[i] > highestConfidence) {
        highestConfidence = probabilities[i];
        predictedIndex = i;
      }
    }

    final predictedLabel = predictedIndex < labels.length ? labels[predictedIndex] : 'Unknown';

    debugPrint('ClassifierService Raw logits: $rawScores');
    debugPrint('ClassifierService Probabilities: $scoresMap');
    debugPrint('ClassifierService Top match: $predictedLabel (${(highestConfidence * 100).toStringAsFixed(1)}%)');

    final isConfident = highestConfidence >= confidenceThreshold;

    if (!isConfident) {
      return RecognitionResult.unsupported(
        imagePath: imageFile.path,
        highestConfidence: highestConfidence,
        tentativeClass: predictedLabel,
      );
    }

    return RecognitionResult(
      predictedClass: predictedLabel,
      confidence: highestConfidence,
      imagePath: imageFile.path,
      allScores: scoresMap,
      isSupported: true,
    );
  }

  /// Apply softmax if raw model outputs are logits
  List<double> _applySoftmax(List<double> scores) {
    // Check if outputs already sum to ~1.0 (already softmaxed)
    final sum = scores.fold<double>(0.0, (acc, val) => acc + val);
    if ((sum - 1.0).abs() < 0.05 && scores.every((s) => s >= 0 && s <= 1.0)) {
      return scores;
    }

    // Otherwise apply softmax
    final maxVal = scores.reduce(math.max);
    final expScores = scores.map((s) => math.exp(s - maxVal)).toList();
    final expSum = expScores.fold<double>(0.0, (acc, val) => acc + val);
    return expScores.map((e) => e / expSum).toList();
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isInitialized = false;
  }
}

