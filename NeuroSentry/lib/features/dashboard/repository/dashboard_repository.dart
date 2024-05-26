import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_healthapp/features/auth/repository/profile_repository.dart';
import 'package:mental_healthapp/models/article_model.dart';
import 'package:mental_healthapp/models/consultant_model.dart';
import 'package:mental_healthapp/models/profile_model.dart';
import 'package:mental_healthapp/models/rating_and_review_model.dart';
import 'package:mental_healthapp/shared/enums/question_type.dart';

final dashboardRepositoryProvider = Provider(
  (ref) => DashboardRepository(
    ref: ref,
  ),
);

class DashboardRepository {
  final ProviderRef ref;
  DashboardRepository({required this.ref});

  Future<List<ArticleModel>> fetchArticles() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('articles').get();

      return snapshot.docs.map((doc) {
        return ArticleModel.fromMap(doc.data());
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<ArticleModel>> fetchBookMarkArticles(UserProfile profile) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('articles')
              .where('title', whereIn: profile.bookMarkArticles)
              .get();

      return snapshot.docs.map((doc) {
        return ArticleModel.fromMap(doc.data());
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<ArticleModel>> fetchWorstArticles(QuestionType worstType) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('articles')
              .where('articleType', isEqualTo: worstType.name)
              .get();

      return snapshot.docs.map((doc) {
        return ArticleModel.fromMap(doc.data());
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future updateReviews(
      RatingAndReviewModel ratings, String consultantName) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('consultants')
          .where('name', isEqualTo: consultantName)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        DocumentReference docRef = doc.reference;

        await docRef.update({
          'ratingsAndReviews': FieldValue.arrayUnion(
            [
              ratings.toMap(),
            ],
          ),
        });
      }
    } catch (e) {
      print('Error updating reviews: $e');
    }
  }

  Stream<List<ConsultantModel>> searchConsultants(String query, String? filter) {
    final CollectionReference consultantsCollection =
    FirebaseFirestore.instance.collection('consultants');

    // Retrieve snapshots of all consultants
    Stream<QuerySnapshot> querySnapshotStream = consultantsCollection.snapshots();

    return querySnapshotStream.map((snapshot) {
      var consultants = snapshot.docs.map((doc) =>
          ConsultantModel.fromMap(doc.data() as Map<String, dynamic>)).toList();

      // Filter consultants by name if a query is provided
      if (query.isNotEmpty) {
        consultants = consultants.where((consultant) =>
            consultant.name.toLowerCase().contains(query.toLowerCase())).toList();
      }

      // Apply the type filter if provided
      if (filter != null && filter.isNotEmpty) {
        consultants = consultants.where((consultant) =>
        consultant.type == filter).toList();
      }

      return consultants;
    });
  }
    
// Stream<List<ConsultantModel>> searchConsultants(String query, String? filter,) {
//     final CollectionReference consultantsCollection =
//     FirebaseFirestore.instance.collection('consultants');
//
//     Query queryRef = consultantsCollection;
//
//     // Apply the name search filter
//     if (query.isNotEmpty) {
//       queryRef = queryRef
//           .where('name', isGreaterThanOrEqualTo: query)
//           .where('name', isLessThan: query + 'z') // Ensures names start with the query
//           .orderBy('name');
//
//     }
//     // Apply the type filter if provided
//     if (filter != null && filter.isNotEmpty) {
//       queryRef = queryRef.where('type', isEqualTo: filter);
//     }
//     // Retrieve snapshots based on the query reference
//     Stream<QuerySnapshot> querySnapshotStream = queryRef.snapshots();
//     return querySnapshotStream.map((snapshot) =>
//         snapshot.docs.map((doc) =>
//             ConsultantModel.fromMap(doc.data() as Map<String, dynamic>)).toList());
//   }

}
