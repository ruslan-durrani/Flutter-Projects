import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../global/services/firestore_service.dart';

part 'user_registered_count_state.dart';

class UserRegisteredCountBloc extends Cubit<UserRegisteredCountState> {
  UserRegisteredCountBloc() : super(UserRegisteredCountInitial());
  Future<void> fetchBarChartUserRegisteredData()async {
    try {
      emit(UserRegistrationLoadingState());
      List<Map<String,dynamic>> registrationCounts = await FireStoreService().getUsersRegisteredLastTwoWeeks();
      emit(DashboardRegisterationCountLoadedState(registrationCounts));
    } catch (error) {
      emit(UserRegistrationErrorState('Error fetching user registration data: $error'));
    }
  }
}
