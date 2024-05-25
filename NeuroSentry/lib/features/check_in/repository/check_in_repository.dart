import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_healthapp/models/question_model.dart';
import 'package:mental_healthapp/shared/enums/question_type.dart';

final checkinRepositoryProvider = Provider(
  (ref) => CheckinRepository(),
);

class CheckinRepository {
  Future<List<Question>> fetchQuestionsFromBackend(
      QuestionType questionType) async {
    List<Question> questions = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('${questionType.name}Questions')
          .get();

      querySnapshot.docs.forEach(
        (doc) {
          Question question =
              Question.fromJson(doc.data() as Map<String, dynamic>);
          questions.add(question);
        },
      );

      return questions;
    } catch (e) {
      return []; // Return an empty list in case of an error
    }
  }
}
