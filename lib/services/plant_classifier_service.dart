import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class ClassificationResult {
  final String scientificName;
  final double confidenceScore;

  ClassificationResult({
    required this.scientificName,
    required this.confidenceScore,
  });
}

class PlantClassifierService {
  static const int inputSize = 224;
  static const String modelPath = 'assets/models/eco2_plant_model.tflite';
  static const String labelsPath = 'assets/models/labels.txt';

  Interpreter? _interpreter;
  List<String> _labels = [];

  bool get isLoaded => _interpreter != null;

  Future<void> loadModelAndLabels() async {
    _interpreter = await Interpreter.fromAsset(modelPath);
    final raw = await rootBundle.loadString(labelsPath);
    _labels = raw
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .map((line) => line.contains(':') ? line.split(':')[1].trim() : line)
        .toList();
  }

  Future<ClassificationResult> classify(File imageFile) async {
    if (_interpreter == null) {
      throw StateError('Model not loaded — call loadModelAndLabels() first');
    }

    final rawBytes = await imageFile.readAsBytes();
    var decoded = img.decodeImage(rawBytes);
    if (decoded == null) throw Exception('Could not decode image');
    decoded = img.bakeOrientation(decoded); // Ensure correct orientation

    final resized = img.copyResize(decoded, width: inputSize, height: inputSize);

    final input = List.generate(
      1,
      (_) => List.generate(
        inputSize,
        (y) => List.generate(
          inputSize,
          (x) {
            final pixel = resized.getPixel(x, y);
            return [
              pixel.r.toDouble(),
              pixel.g.toDouble(),
              pixel.b.toDouble(),
            ];
          },
        ),
      ),
    );

    final output = List.generate(1, (_) => List.filled(_labels.length, 0.0));
    _interpreter!.run(input, output);

    final probabilities = output[0];
    var maxIndex = 0;
    var maxProb = probabilities[0];
    for (var i = 1; i < probabilities.length; i++) {
      if (probabilities[i] > maxProb) {
        maxProb = probabilities[i];
        maxIndex = i;
      }
    }

    return ClassificationResult(
      scientificName: _labels[maxIndex].replaceAll('_', ' '),
      confidenceScore: maxProb,
    );
  }

  void dispose() {
    _interpreter?.close();
  }
}