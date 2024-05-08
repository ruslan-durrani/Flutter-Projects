import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dashboard_bloc_state.dart';




class DashboardAnalyticsBloc extends Cubit<DashboardAnalyticsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DashboardAnalyticsBloc() : super(DashboardAnalyticsLoadingState());

  Future<void> fetchAnalyticsData() async {
    try {
      emit(DashboardAnalyticsLoadingState());

      // Fetch report items
      final reportItemsQuery = await _firestore.collection('reportItems').get();
      final totalItems = reportItemsQuery.docs.length;
      final lostItems = reportItemsQuery.docs.where((doc) => doc['status'] == 'Lost').length;
      final foundItems = reportItemsQuery.docs.where((doc) => doc['status'] == 'Found').length;
      final recoveredItems = reportItemsQuery.docs.where((doc) => doc['status'] == 'Recovered').length ;

      // Calculate recovery rate
      final recoveryRate = totalItems != 0 ? (recoveredItems / totalItems * 100) : 0.0;

      // Fetch user count
      final usersQuery = await _firestore.collection('users').get();
      final userCount = usersQuery.docs.length;

      emit(DashboardAnalyticsDataLoadedState(lostItems, userCount, foundItems, recoveryRate));
    } catch (error) {
      emit(DashboardAnalyticsErrorState(error.toString()));
    }
  }
}


// class DashboardAnalyticsBloc extends Cubit<DashboardAnalyticsState> {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   DashboardAnalyticsBloc() : super(DashboardAnalyticsLoadingState());
//
//   Future<void> fetchAnalyticsData() async {
//     try {
//       emit(DashboardAnalyticsLoadingState());
//       int totalItems = 0;
//       int lostItems = 0;
//       int foundItems = 0;
//       int recoveredItem = 0;
//       CollectionReference itemsCollection = firestore.collection('reportItems');
//       QuerySnapshot itemsSnapshot = await itemsCollection.get();
//
//       itemsSnapshot.docs.forEach((itemDoc) {
//         totalItems++;
//         String status = itemDoc['status'];
//         if (status == 'Lost') {
//           lostItems++;
//         } else if (status == 'Found') {
//           foundItems++;
//         }
//         else if (status == 'Recovered') {
//           recoveredItem++;
//         }
//       });
//
//       double recoveryRate = totalItems != 0 ? (recoveredItem / totalItems * 100) : 0;
//       QuerySnapshot usersSnapshot = await firestore.collection('users').get();
//       final userCount = usersSnapshot.docs.length;
//       emit(DashboardAnalyticsDataLoadedState(lostItems , userCount, foundItems, recoveryRate));
//     } catch (error) {
//       emit(DashboardAnalyticsErrorState(error.toString()));
//     }
//   }
// }
