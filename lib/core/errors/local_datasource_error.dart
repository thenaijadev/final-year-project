import 'package:minimalist_social_app/core/errors/article_error.dart';

class LocalDataSourceError extends ArticleError {
  LocalDataSourceError({required super.message});

  @override
  String toString() => 'LocalDataSourceError(message: $message)';
}
