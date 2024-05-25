import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_healthapp/features/auth/repository/profile_repository.dart';
import 'package:mental_healthapp/shared/enums/question_type.dart';

final profileControllerProvider = Provider((ref) {
  final profileRepo = ref.read(profileRepositoryProvider);
  return ProfileController(profileRepository: profileRepo);
});

class ProfileController {
  ProfileController({required this.profileRepository});
  final ProfileRepository profileRepository;

  String getProfileName() {
    return profileRepository.profile!.profileName;
  }

  Future downloadUserProfile() async {
    await profileRepository.getUserProfile();
  }

  double getProfileAverageScore() {
    return profileRepository.profile!.averageScore!;
  }

  Future uploadPicture(File file) async {
    await profileRepository.uploadPictureToFirebase(file);
  }

  bool isCompletedCheckin() {
    return profileRepository.profile!.todayMoodScore != null &&
        profileRepository.profile!.todayNutritionScore != null &&
        profileRepository.profile!.todayThoughtsScore != null &&
        profileRepository.profile!.todaySleepScore != null;
  }

  QuestionType getWorstScore() {
    QuestionType ans = QuestionType.sleep;
    int worstScore = 100;
    if (profileRepository.profile!.todaySleepScore! < worstScore) {
      ans = QuestionType.sleep;
      worstScore = profileRepository.profile!.todaySleepScore!;
    }
    if (profileRepository.profile!.todayThoughtsScore! < worstScore) {
      ans = QuestionType.thoughts;
      worstScore = profileRepository.profile!.todayThoughtsScore!;
    }

    if (profileRepository.profile!.todayNutritionScore! < worstScore) {
      ans = QuestionType.nutrition;
      worstScore = profileRepository.profile!.todayNutritionScore!;
    }
    if (profileRepository.profile!.todayMoodScore! < worstScore) {
      ans = QuestionType.mood;
      worstScore = profileRepository.profile!.todayMoodScore!;
    }
    return ans;
  }

  updateScore(int score, QuestionType question) {
    if (question == QuestionType.mood) {
      profileRepository.profile!.todayMoodScore = score;
    } else if (question == QuestionType.nutrition) {
      profileRepository.profile!.todayNutritionScore = score;
    } else if (question == QuestionType.thoughts) {
      profileRepository.profile!.todayThoughtsScore = score;
    } else {
      profileRepository.profile!.todaySleepScore = score;
    }
  }

  getScore(QuestionType question) {
    if (question == QuestionType.mood) {
      return profileRepository.profile!.todayMoodScore;
    } else if (question == QuestionType.nutrition) {
      return profileRepository.profile!.todayNutritionScore;
    } else if (question == QuestionType.thoughts) {
      return profileRepository.profile!.todayThoughtsScore;
    } else {
      return profileRepository.profile!.todaySleepScore;
    }
  }

  Future uploadUserScoreWhenCompleted() async {
    await profileRepository.updateUserScores();
  }

  bool isCompletionDateTimeExpired() {
    final completionDateTime =
        profileRepository.profile!.todayCompletionDateTime;
    if (completionDateTime == null) {
      return true;
    } else {
      Duration difference = DateTime.now().difference(completionDateTime);

      return difference.inHours > 24;
    }
  }
}
