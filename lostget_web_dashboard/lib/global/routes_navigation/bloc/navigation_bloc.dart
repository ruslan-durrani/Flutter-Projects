import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../screens/components/dashboard_content.dart';
import '../models/navigation_model.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationInitial(getNavigationItems().first.values.elementAt(0),getNavigationItems().first.values.elementAt(0),DashboardContent())) {
    on<OnNavigationClickEvent>(_onNavigationClickEvent);
    on<OnNavigationHoverEvent>(_onNavigationHoverEvent);
    // on<ChangeScreenEvent>(_changeScreenEvent);
  }

  FutureOr<void> _onNavigationClickEvent(OnNavigationClickEvent event, Emitter<NavigationState> emit) {
    emit(NavigationInitial(event.currentNavigationItem,event.currentNavigationItem,event.screen));
  }

  FutureOr<void> _onNavigationHoverEvent(OnNavigationHoverEvent event, Emitter<NavigationState> emit) {
    emit(NavigationInitial(event.currentNavigationItem,event.hoveredNavigationItem, state.screen));
  }

  //
  // FutureOr<void> _changeScreenEvent(ChangeScreenEvent event, Emitter<NavigationState> emit) {
  //   emit(NavigationInitial(state.currentNavigationItem,state.hoveredNavigationItem, event.widget));
  // }
}

