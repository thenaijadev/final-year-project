// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'text_recognition_bloc.dart';

@freezed
abstract class TextRecognitionState extends Equatable {
  const TextRecognitionState();

  @override
  List<Object> get props => [];
}

class TextRecognitionInitialState extends TextRecognitionState {}

class TextRecognitionTextRecognized extends TextRecognitionState {
  final String recognizedText;
  const TextRecognitionTextRecognized({
    required this.recognizedText,
  });
}

class TextRecognitionErrorState extends TextRecognitionState {
  final String errorText;
  const TextRecognitionErrorState({
    required this.errorText,
  });
}
