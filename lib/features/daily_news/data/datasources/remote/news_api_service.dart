import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:minimalist_social_app/core/errors/remote_datasource_error.dart';
import 'package:minimalist_social_app/core/network/api_endpoint.dart';
import 'package:minimalist_social_app/core/network/dio_client.dart';
import 'package:minimalist_social_app/core/network/dio_exception.dart';
import 'package:minimalist_social_app/core/utils/logger.dart';
import 'package:minimalist_social_app/core/utils/typedef.dart';
import 'package:minimalist_social_app/features/daily_news/data/models/article_model.dart';

abstract class NewsApiService {
  FutureEitherArticleOrException getNewsArticles(
      {required String country, required String apiKey});
}

class NewsApiServiceImplementation implements NewsApiService {
  @override
  FutureEitherArticleOrException getNewsArticles(
      {required String country,
      required String apiKey,
      String topic = ''}) async {
    try {
      final theQuery = topic == '' ? 'nigeria' : topic;
      final response = await DioClient.instance
          .get(RoutesAndPaths.everything, queryParameters: {
        "q": theQuery,
        "apiKey": "948aa2afb2d14c989725beae7e49d6e4",
      });
      logger.e(response);
      return right(NewsArticlesModel.fromMap(response));
    } on DioException catch (e) {
      final errorMessage = DioExceptionClass.fromDioException(e).errorMessage;
      logger.e(e);
      return left(RemoteDataSourceError(message: errorMessage));
    } catch (e) {
      logger.e({"error": e.toString()});
      return left(RemoteDataSourceError(message: e.toString()));
    }
  }
}
