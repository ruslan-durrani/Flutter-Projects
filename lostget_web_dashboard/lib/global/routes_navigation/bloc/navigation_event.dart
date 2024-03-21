part of 'navigation_bloc.dart';

@immutable
abstract class NavigationEvent {}

class OnNavigationClickEvent extends NavigationEvent{
  final String currentNavigationItem;
  final dynamic screen;
  OnNavigationClickEvent(this.currentNavigationItem, this.screen);
}
class OnNavigationHoverEvent extends NavigationEvent{
  final String currentNavigationItem;
  final String hoveredNavigationItem;
  OnNavigationHoverEvent(this.currentNavigationItem, this.hoveredNavigationItem);
}
