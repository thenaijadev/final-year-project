import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:minimalist_social_app/features/AI/data/repositories/mi_kit_repository.dart';

part 'text_recognition_event.dart';
part 'text_recognition_state.dart';

class TextRecognitionBloc
    extends Bloc<TextRecognitionEvent, TextRecognitionState> {
  final MlKitRepository repo;
  TextRecognitionBloc({required this.repo})
      : super(TextRecognitionInitialState()) {
    on<TextRecognitionEventGetText>((event, emit) async {
      try {
        final String recognizedText = await repo.processImage(path: event.path);

        emit(TextRecognitionTextRecognized(recognizedText: recognizedText));
      } catch (e) {
        emit(TextRecognitionErrorState(errorText: e.toString()));
      }
    });
  }
}
