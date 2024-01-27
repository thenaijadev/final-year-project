import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:minimalist_social_app/core/errors/article_error.dart';
import 'package:minimalist_social_app/core/errors/remote_datasource_error.dart';
import 'package:minimalist_social_app/features/daily_news/domain/entities/article.dart';
import 'package:minimalist_social_app/features/daily_news/domain/usecases/get_article_usecase.dart';

part 'daily_news_event.dart';
part 'daily_news_state.dart';

class DailyNewsBloc extends Bloc<DailyNewsEvent, DailyNewsState> {
  final GetArticleUseCase getArticleUseCase;
  DailyNewsBloc(this.getArticleUseCase) : super(DailyArticleInitial()) {
    on<GetArticlesEvent>(onGetArticles);
  }

  void onGetArticles(event, emit) async {
    emit(RemoteArticleLoading());

    final response = await getArticleUseCase.call();

    response.fold((l) {
      emit(RemoteArticleError(serverError: l));
    }, (r) {
      if (r.articles.isEmpty) {
        emit(RemoteArticleError(
            serverError:
                RemoteDataSourceError(message: "No Articles to be shown")));
      } else {
        emit(RemoteArticleDone(articles: r));
      }
    });
  }
}
