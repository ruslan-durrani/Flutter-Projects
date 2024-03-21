// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// abstract class ControllerState {
//   late GlobalKey<ScaffoldState> scaffoldKey;
//   bool controlMenu = false;
// }
//
// class ControllerInitial extends ControllerState {
//   GlobalKey<ScaffoldState> scaffoldKey;
//   ControllerInitial({required this.scaffoldKey});
// }
//
// abstract class ControllerEvent {}
//
// class UpdateScaffoldKeyEvent extends ControllerEvent {
//   final GlobalKey<ScaffoldState> scaffoldKey;
//
//   UpdateScaffoldKeyEvent(this.scaffoldKey);
// }
//
// class ToggleMenuEvent extends ControllerEvent {}
//
// class ControllerBloc extends Bloc<ControllerEvent, ControllerState> {
//   ControllerBloc() : super(ControllerInitial(scaffoldKey: GlobalKey<ScaffoldState>()));
//
//   @override
//   Stream<ControllerState> mapEventToState(ControllerEvent event) async* {
//     if (event is UpdateScaffoldKeyEvent) {
//       yield ControllerInitial(scaffoldKey: event.scaffoldKey).._controlMenu = state.controlMenu;
//     } else if (event is ToggleMenuEvent) {
//       yield ControllerInitial(scaffoldKey: state.scaffoldKey).._controlMenu = !state.controlMenu;
//     }
//   }
// }
