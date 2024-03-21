part of 'data_table_bloc.dart';

@immutable
abstract class DataTableState {
  final List<UserProfile> userList;

  DataTableState(this.userList);
}

class DataTableInitial extends DataTableState {
  DataTableInitial(List<UserProfile> userList) : super([]);
}

class SetMarkedItemsState extends DataTableState{
  SetMarkedItemsState(List<UserProfile> userList) : super(userList);
}
