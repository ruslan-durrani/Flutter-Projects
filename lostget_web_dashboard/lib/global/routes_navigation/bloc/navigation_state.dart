part of 'navigation_bloc.dart';

@immutable
class NavigationState {
  final String currentNavigationItem;
  final String hoveredNavigationItem;
  final dynamic screen;

  NavigationState(this.currentNavigationItem, this.hoveredNavigationItem, this.screen,);
  isActive(String navItem){
    return currentNavigationItem==navItem?true:false;
  }
  hovered(String navItem){
    return currentNavigationItem!=navItem?true:false;
  }
}

class NavigationInitial extends NavigationState {
  NavigationInitial(String currentNavigationItem, String hoveredNavigationItem, dynamic screen) : super(currentNavigationItem, hoveredNavigationItem, screen);
}
