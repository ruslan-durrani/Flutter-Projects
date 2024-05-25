import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_healthapp/features/check_in/repository/check_in_repository.dart';
import 'package:mental_healthapp/models/question_model.dart';
import 'package:mental_healthapp/shared/enums/question_type.dart';

final checkInControllerProvider = Provider((ref) {
  final checkInRepo = ref.read(checkinRepositoryProvider);
  return CheckInController(checkinRepository: checkInRepo);
});

class CheckInController {
  CheckInController({required this.checkinRepository});
  final CheckinRepository checkinRepository;

  Future<List<Question>> getQuestionsFromQuestionType(
      QuestionType questionType) async {
    return await checkinRepository.fetchQuestionsFromBackend(questionType);
  }
}
