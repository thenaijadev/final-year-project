import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minimalist_social_app/core/errors/article_error.dart';
import 'package:minimalist_social_app/features/daily_news/data/datasources/remote/news_api_service.dart';

part 'daily_news_event.dart';
part 'daily_news_state.dart';

class DailyNewsBloc extends Bloc<DailyNewsEvent, DailyNewsState> {
  final NewsApiService service;
  DailyNewsBloc(this.service) : super(DailyArticleInitial()) {
    on<GetArticlesEvent>(onGetArticles);
  }

  void onGetArticles(event, emit) async {
    emit(RemoteArticleLoading());

    final response = await service.getNewsArticles(query: event.query);

    response.fold((l) {
      return emit(RemoteArticleError(serverError: l));
    }, (r) {
      return emit(RemoteArticleDone(articles: r));
    });
  }
}
