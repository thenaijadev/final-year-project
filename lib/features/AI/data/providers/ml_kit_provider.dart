// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class MlKitProvider {
  final String path;
  MlKitProvider({
    required this.path,
  });

  Future<String> processImage() async {
    final InputImage inputImage = InputImage.fromFilePath(path);
    final textRecognizer = TextRecognizer();

    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    String extractedText = recognizedText.text;
    return extractedText;
  }
}
