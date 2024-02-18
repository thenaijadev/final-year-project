// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'ai_bloc.dart';

abstract class AiState extends Equatable {
  const AiState();

  @override
  List<Object> get props => [];
}

class AiInitial extends AiState {}

class AiResponseIsLoading extends AiState {}

class AiResponseError extends AiState {
  final AIError error;
  const AiResponseError({
    required this.error,
  });
}

class AiResponseRetrieved extends AiState {
  final AiResponse response;
  const AiResponseRetrieved({
    required this.response,
  });
}
