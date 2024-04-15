// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'daily_news_bloc.dart';

abstract class DailyNewsEvent extends Equatable {
  const DailyNewsEvent();

  @override
  List<Object> get props => [];
}

class GetArticlesEvent extends DailyNewsEvent {
  final String query;
  const GetArticlesEvent({
    required this.query,
  });
}
