import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'text_recognition_event.dart';
part 'text_recognition_state.dart';

class TextRecognitionBloc
    extends Bloc<TextRecognitionEvent, TextRecognitionState> {
  TextRecognitionBloc() : super(TextRecognitionInitialState()) {
    on<TextRecognitionEventGetText>((event, emit) {});
  }
}
