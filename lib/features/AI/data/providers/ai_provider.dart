import 'package:dartz/dartz.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:minimalist_social_app/core/errors/ai_error.dart';
import 'package:minimalist_social_app/core/utils/typedef.dart';
import 'package:minimalist_social_app/features/AI/data/models/ai_response_model.dart';

class AiProvider {
  final String api_key = "AIzaSyDuzHjnJhpBAtzIIaaXz-9j6QYFKZuE49o";

  FutureEitherStringOrAIError getAiText({required String prompt}) async {
    try {
      final model = GenerativeModel(model: 'gemini-pro', apiKey: api_key);
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      return right(AiResponse(responseText: response.text));
    } catch (e) {
      return left(AIError(message: e.toString()));
    }
  }
}
