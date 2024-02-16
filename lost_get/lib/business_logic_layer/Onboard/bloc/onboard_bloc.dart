import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';

part 'onboard_event.dart';
part 'onboard_state.dart';

class OnboardBloc extends Bloc<OnboardEvent, OnboardState> {
  OnboardBloc() : super(OnboardState()) {
    on<ChangePageDotIndicatorEvent>(changePageDotIndicatorEvent);
    on<GetStartedButtonClickedEvent>(getStartedButtonClickedEvent);
  }
  FutureOr<void> changePageDotIndicatorEvent(
      ChangePageDotIndicatorEvent event, Emitter<OnboardState> emit) {
    emit(OnboardState(page: state.page));
  }

  FutureOr<void> getStartedButtonClickedEvent(
      GetStartedButtonClickedEvent event, Emitter<OnboardState> emit) {
    emit(GetStartedButtonClickedActionState());
  }
}
