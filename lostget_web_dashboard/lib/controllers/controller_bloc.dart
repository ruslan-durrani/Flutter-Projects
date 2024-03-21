//
// import 'package:bloc/bloc.dart';
// import 'package:flutter/cupertino.dart';
//
// import 'controller_event.dart';
//
// class ControllerBloc extends Bloc<ControllerEvent, ControllerState> {
//   ControllerBloc() : super(ControllerInitialState(scaffoldKey: GlobalKey<ScaffoldState>()));
//
//   @override
//   Stream<ControllerState> mapEventToState(ControllerEvent event) async* {
//     if (event is UpdateScaffoldKeyEvent) {
//       yield ControllerInitialState(scaffoldKey: event.scaffoldKey, controlMenu: state.controlMenu);
//     } else if (event is ToggleMenuEvent) {
//       yield ControllerInitialState(scaffoldKey: state.scaffoldKey, controlMenu: !state.controlMenu);
//     }
//   }
// }
