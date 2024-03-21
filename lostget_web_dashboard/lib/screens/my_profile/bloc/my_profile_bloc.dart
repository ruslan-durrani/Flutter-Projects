import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:responsive_admin_dashboard/global/services/firebase_service.dart';
import '../../users_management/models/userProfile.dart';
part 'my_profile_event.dart';
part 'my_profile_state.dart';
class MyProfileBloc extends Bloc<MyProfileEvent, MyProfileState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  MyProfileBloc() : super(MyProfileInitial()) {
    on<GetMyProfileDataEvent>(_getMyProfileDataEvent);
  }
  Future<FutureOr<void>> _getMyProfileDataEvent(GetMyProfileDataEvent event, Emitter<MyProfileState> emit) async {
    try {
      emit(MyProfilesLoading());
      print("MY UID IS: "+FirebaseService().getMyUID());
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await firestore.collection('users').doc(FirebaseService().getMyUID()).get();
      if (userSnapshot.exists) {
        final userProfile = UserProfile.fromSnapshot(userSnapshot);
        emit (MyProfileLoaded(userProfile));
      } else {
        emit( MyProfileError('User profile with the specified UID not found.'));
      }
    } catch (e) {
      emit(MyProfileError('Failed to fetch user profiles.'));
    }
    }
}