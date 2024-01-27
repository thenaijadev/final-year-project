import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimalist_social_app/core/utils/logger.dart';

class AppObserver implements BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {}

  @override
  void onClose(BlocBase bloc) {}

  @override
  void onCreate(BlocBase bloc) {}

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {}

  @override
  void onEvent(Bloc bloc, Object? event) {}

  @override
  void onTransition(Bloc bloc, Transition transition) {
    logger.e("${bloc.runtimeType}: $transition");
  }
}
