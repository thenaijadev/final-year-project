// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'ai_bloc.dart';

abstract class AiEvent extends Equatable {
  const AiEvent();

  @override
  List<Object> get props => [];
}

class AiEventGetResponse extends AiEvent {
  final String prompt;
  const AiEventGetResponse({
    required this.prompt,
  });
}
