import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ControllerEvent {}

class UpdateScaffoldKeyEvent extends ControllerEvent {
  final GlobalKey<ScaffoldState> scaffoldKey;

  UpdateScaffoldKeyEvent(this.scaffoldKey);
}

class ToggleMenuEvent extends ControllerEvent {}

abstract class ControllerState {}

class ControllerInitialState extends ControllerState {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool controlMenu;

  ControllerInitialState({required this.scaffoldKey, this.controlMenu = false});
}
