import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../models/user_profile.dart';

part 'user_profiles_event.dart';
part 'user_profiles_state.dart';

class UserProfilesBloc extends Bloc<UserProfilesEvent, UserProfilesState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserProfilesBloc() : super(UserProfilesLoading([])) {
    on<FetchUserProfilesEvent>(_fetchUserProfilesEvent);
    on<SearchFilterUsersProfilesEvent>(_searchFilterUsersProfilesEvent);
  }
  List<UserProfile> userProfileList = [];
  void _fetchUserProfilesEvent(
      FetchUserProfilesEvent event,
      Emitter<UserProfilesState> emit,
      ) async {
    try {
      emit(UserProfilesLoading([]));
      Stream<QuerySnapshot<Map<String, dynamic>>> userProfilesStream =
      firestore.collection('users').snapshots();
      await for (QuerySnapshot<Map<String, dynamic>> snapshot
      in userProfilesStream) {
        final userProfiles = snapshot.docs.map((doc) {

        print("COUNT IS _________ ${UserProfile.fromSnapshot(doc)}");
        print(UserProfile.fromSnapshot(doc).fullName);
          return UserProfile.fromSnapshot(doc);
        }).toList();
        print("fullName");
        userProfileList = userProfiles;
        emit(UserProfilesLoaded(userProfiles));
      }
    } catch (e, stacktrace) {
      print("Error fetching user profiles: $e");
      print("Stacktrace: $stacktrace");
      emit(UserProfilesError('Failed to fetch user profiles. Error: $e'));
    }

  }

  FutureOr<void> _searchFilterUsersProfilesEvent(SearchFilterUsersProfilesEvent event, Emitter<UserProfilesState> emit) {
    String filteredTextNameOrEmailOrPhone = event.controllerText;
    List<UserProfile> filteredProfiles = [];
    userProfileList.forEach((element) {
      if(element.fullName!.toLowerCase().contains(filteredTextNameOrEmailOrPhone.toLowerCase())||
          element.email!.toLowerCase().contains(filteredTextNameOrEmailOrPhone.toLowerCase())){
        filteredProfiles.add(element);
      }
    });
    if(filteredTextNameOrEmailOrPhone ==""){
      emit(UserProfilesLoaded(userProfileList));
    }
    else if(filteredProfiles.isEmpty){
      emit(UserProfilesLoaded(filteredProfiles));
    }
    else{
      emit(UserProfilesLoaded(filteredProfiles));
    }

  }
}

































// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';
// import 'package:responsive_admin_dashboard/screens/users_management/repository/users_repository.dart';
//
// import '../models/userProfile.dart';
//
// part 'user_profiles_event.dart';
// part 'user_profiles_state.dart';
//
// class UserProfilesBloc extends Bloc<UserProfilesEvent, UserProfilesState> {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   UserProfilesBloc() : super(UserProfilesLoading()) {
//     on<FetchUserProfilesEvent>(_fetchUserProfilesEvent);
//   }
//
//   void _fetchUserProfilesEvent(
//       FetchUserProfilesEvent event,
//       Emitter<UserProfilesState> emit,
//       ) async {
//     if (event is FetchUserProfilesEvent) {
//       try {
//         emit(UserProfilesLoading());
//         Stream<QuerySnapshot<Map<String, dynamic>>> userProfilesStream =
//         firestore.collection('users').snapshots();
//         await for (QuerySnapshot<Map<String, dynamic>> snapshot
//         in userProfilesStream) {
//           final userProfiles = snapshot.docs.map((doc) {
//             final data = doc.data();
//             print(data);
//             return UserProfile(
//               phoneNumber: data['phoneNumber'],
//               preferenceList: data['preferenceList'] as Map<String, dynamic>,
//               isAdmin: data['isAdmin'],
//               fullName: data['fullName'],
//               email: data['email'],
//               imgUrl: data['imgUrl'],
//               biography: data["biography"],
//               dateOfBirth: data["dateOfBirth"],
//               gender: data["gender"],
//             );
//           }).toList();
//
//           emit(UserProfilesLoaded(userProfiles));
//         }
//       } catch (e) {
//         emit(UserProfilesError('Failed to fetch user profiles.'));
//       }
//     }
//   }
// }
