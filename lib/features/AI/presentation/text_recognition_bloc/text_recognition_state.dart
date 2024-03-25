part of 'text_recognition_bloc.dart';

@freezed
abstract class TextRecognitionState extends Equatable {
  const TextRecognitionState();

  @override
  List<Object> get props => [];
}

class TextRecognitionInitialState extends TextRecognitionState {}
