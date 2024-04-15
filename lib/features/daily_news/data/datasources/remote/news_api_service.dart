import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:minimalist_social_app/core/errors/article_error.dart';
import 'package:minimalist_social_app/core/errors/remote_datasource_error.dart';
import 'package:minimalist_social_app/core/network/api_endpoint.dart';
import 'package:minimalist_social_app/core/network/dio_client.dart';
import 'package:minimalist_social_app/core/network/dio_exception.dart';

class NewsApiService {
  Future<Either<ArticleError, Map<String, dynamic>>> getNewsArticles(
      {required String query}) async {
    try {
      final response = await DioClient.instance.get(RoutesAndPaths.search,
          queryParameters: {"keyword": query, "lr": 'en-US'},
          options: Options(headers: {
            'X-RapidAPI-Key':
                '23473dd6a1msh8dd209aa8079f0dp1503e5jsn6ec54be1045c',
            'X-RapidAPI-Host': 'google-news13.p.rapidapi.com'
          }));
      (response);
      return right(response);
    } on DioException catch (e) {
      final errorMessage = DioExceptionClass.fromDioException(e).errorMessage;
      (e);
      return left(RemoteDataSourceError(message: errorMessage));
    } catch (e) {
      ({"error": e.toString()});
      return left(RemoteDataSourceError(message: e.toString()));
    }
  }
}
