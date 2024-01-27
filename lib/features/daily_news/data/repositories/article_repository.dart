import 'package:minimalist_social_app/core/connection/network_info.dart';
import 'package:minimalist_social_app/core/constants/app_constants.dart';
import 'package:minimalist_social_app/core/utils/typedef.dart';
import 'package:minimalist_social_app/features/daily_news/data/datasources/local/local_article_datasource.dart';
import 'package:minimalist_social_app/features/daily_news/data/datasources/remote/news_api_service.dart';
import 'package:minimalist_social_app/features/daily_news/domain/repositories/article_repository.dart';

class ArticleRepositoryImplementation implements ArticleRepository {
  final NewsApiService newsApiService;
  final ArticlesLocalDataSourceImpl localDataSource;
  final NetworkInfo networkInfo;

  ArticleRepositoryImplementation(
      {required this.newsApiService,
      required this.localDataSource,
      required this.networkInfo});
  @override
  FutureEitherArticleOrException getNewsArticles() async {
    if (await networkInfo.isConnected!) {
      final remoteArticle = await newsApiService.getNewsArticles(
          country: AppConstants.country, apiKey: AppConstants.apikey);
      localDataSource.saveArticle(remoteArticle);
      return remoteArticle;
    } else {
      final localArticles = await localDataSource.getSavedArticles();
      return localArticles;
    }
  }
}
