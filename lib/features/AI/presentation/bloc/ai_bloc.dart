import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minimalist_social_app/core/errors/ai_error.dart';
import 'package:minimalist_social_app/features/AI/data/models/ai_response_model.dart';
import 'package:minimalist_social_app/features/AI/data/repositories/ai_repository.dart';

part 'ai_event.dart';
part 'ai_state.dart';

class AiBloc extends Bloc<AiEvent, AiState> {
  AiBloc({required AiRepository repo}) : super(AiInitial()) {
    on<AiEventGetResponse>((event, emit) async {
      emit(AiResponseIsLoading());
      final String prompt = event.prompt;

      final response = await repo.getAiText(prompt: prompt);
      response.fold((l) => emit(AiResponseError(error: l)),
          (r) => emit(AiResponseRetrieved(response: r)));
    });
  }
}
