import 'dart:async';
import 'dart:js_interop';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../models/user_profile.dart';


part 'data_table_event.dart';
part 'data_table_state.dart';

class DataTableBloc extends Bloc<DataTableEvent, DataTableState> {
  DataTableBloc() : super(DataTableInitial([])) {
    on<SetMarkedItemsEvent>(_setMarkedItemsEvent);
    on<RemoveMarkedItemsEvent>(_removeMarkedItemsEvent);
  }

  FutureOr<void> _setMarkedItemsEvent(SetMarkedItemsEvent event, Emitter<DataTableState> emit) {
    if(event.userList.toString().isNotEmpty){
      List<UserProfile> stateList = state.userList;
      stateList.add((event.userList!));
      emit(SetMarkedItemsState(stateList));
    }
  }

  FutureOr<void> _removeMarkedItemsEvent(RemoveMarkedItemsEvent event, Emitter<DataTableState> emit) {
    if(!event.userList.toString().isEmpty){
      List<UserProfile> stateList = state.userList;
      if(stateList.contains(event.userList)){
        stateList.remove((event.userList!));
        emit(SetMarkedItemsState(stateList));
      }
    }
  }
}

