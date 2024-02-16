import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardState()) {
    on<TriggerAppEvent>(triggerAppEvent);
  }

  FutureOr<void> triggerAppEvent(
      TriggerAppEvent event, Emitter<DashboardState> emit) {
    emit(DashboardState(index: event.index));
  }
}
