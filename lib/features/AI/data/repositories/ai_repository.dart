// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:minimalist_social_app/core/utils/typedef.dart';
import 'package:minimalist_social_app/features/AI/data/providers/ai_provider.dart';

class AiRepository {
  final AiProvider provider;
  AiRepository({
    required this.provider,
  });
  FutureEitherStringOrAIError getAiText({required String prompt}) async {
    return provider.getAiText(prompt: prompt);
  }
}
