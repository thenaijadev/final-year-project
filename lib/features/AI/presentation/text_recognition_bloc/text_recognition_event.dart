part of 'text_recognition_bloc.dart';

abstract class TextRecognitionEvent extends Equatable {
  const TextRecognitionEvent();

  @override
  List<Object> get props => [];
}

class TextRecognitionEventGetText extends TextRecognitionEvent {
  const TextRecognitionEventGetText();
}
