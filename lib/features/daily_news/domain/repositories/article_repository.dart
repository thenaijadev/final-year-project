import 'package:minimalist_social_app/core/utils/typedef.dart';

abstract class ArticleRepository {
  FutureEitherArticleOrException getNewsArticles();
}
