import 'package:minimalist_social_app/features/AI/data/providers/ml_kit_provider.dart';

class MlKitRepository {
  final MlKitProvider mlKitProvider;

  MlKitRepository({required this.mlKitProvider});
  Future<String> processImage() async {
    return mlKitProvider.processImage();
  }
}
