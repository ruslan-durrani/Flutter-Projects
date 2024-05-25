import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_healthapp/features/dashboard/repository/dashboard_repository.dart';
import 'package:mental_healthapp/models/article_model.dart';
import 'package:mental_healthapp/models/consultant_model.dart';
import 'package:mental_healthapp/shared/enums/question_type.dart';

final dashboardControllerProvider = Provider((ref) {
  final dashboardRepo = ref.read(dashboardRepositoryProvider);
  return DashboardController(dashboardRepository: dashboardRepo);
});

class DashboardController {
  DashboardController({required this.dashboardRepository});
  final DashboardRepository dashboardRepository;

  Future<List<ArticleModel>> getWorstArticleType(
      QuestionType? worstType) async {
    if (worstType == null) {
      return await dashboardRepository.fetchArticles();
    }
    return await dashboardRepository.fetchWorstArticles(worstType);
  }

  Future<List<ArticleModel>> getArticlesFromFirebase() async {
    return await dashboardRepository.fetchArticles();
  }

  Stream<List<ConsultantModel>> getConsultantsFromFirebase(String query, {String? filter}) {
    return dashboardRepository.searchConsultants(query, filter);
  }
}
