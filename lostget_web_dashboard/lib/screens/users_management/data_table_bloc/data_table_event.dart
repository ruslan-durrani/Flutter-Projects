part of 'data_table_bloc.dart';

@immutable
abstract class DataTableEvent {}

class SetMarkedItemsEvent extends DataTableEvent{
  final UserProfile? userList;
  SetMarkedItemsEvent(this.userList);
}
class RemoveMarkedItemsEvent extends DataTableEvent{
  final UserProfile? userList;
  RemoveMarkedItemsEvent(this.userList);
}