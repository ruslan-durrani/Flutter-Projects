part of 'user_registered_count_cubit.dart';

@immutable
abstract class UserRegisteredCountState {}

class UserRegisteredCountInitial extends UserRegisteredCountState {}
class DashboardRegisterationCountLoadedState extends UserRegisteredCountState{
  final List registrationCounts;

  DashboardRegisterationCountLoadedState(this.registrationCounts);

  int range = 0;
  String getYAxisRange(){
    registrationCounts.forEach((element) {
      final count = element["user_count"];
      if(count>range){
        range = count;
      }
    });
    print("Range:"+range.toString());
    if(range < 1000){
      return "H";
    }
    else if(range > 1000){
      return "K";
    }
    else if(range >99999){
      return "M";
    }
    return "H";
  }

}
class UserRegistrationLoadingState extends UserRegisteredCountState{}
class UserRegistrationErrorState extends UserRegisteredCountState {
  final String error;
  UserRegistrationErrorState(this.error);
}