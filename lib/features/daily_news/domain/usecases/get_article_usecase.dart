import 'package:minimalist_social_app/core/usecase/article_usecase.dart';
import 'package:minimalist_social_app/core/utils/typedef.dart';
import 'package:minimalist_social_app/features/daily_news/domain/entities/article.dart';
import 'package:minimalist_social_app/features/daily_news/domain/repositories/article_repository.dart';

class GetArticleUseCase implements ArticleUseCase<NewsArticlesEntity, void> {
  final ArticleRepository articleRepository;

  GetArticleUseCase({required this.articleRepository});
  @override
  FutureEitherArticleOrException call({params}) {
    return articleRepository.getNewsArticles();
  }
}
