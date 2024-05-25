import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_healthapp/features/auth/repository/auth_repository.dart';
import 'package:mental_healthapp/features/auth/repository/profile_repository.dart';
import 'package:mental_healthapp/models/profile_model.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  final profileRepository = ref.read(profileRepositoryProvider);
  return AuthController(
    authRepository: authRepository,
    profileRepository: profileRepository,
  );
});

class AuthController {
  AuthController({
    required this.authRepository,
    required this.profileRepository,
  });
  final AuthRepository authRepository;
  final ProfileRepository profileRepository;

  Future saveUserProfile(UserProfile profile) async {
    await profileRepository.saveProfile(profile);
  }

  Future creatingUserWithEmailPassword({
    required String email,
    required String password,
  }) async {
    await authRepository.creatingUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future signingInUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await authRepository.signingInUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future signInWithGoogle() async {
    await authRepository.googleSignIn();
  }

  Future<bool> checkProfileExists(String id) async {
    return await authRepository.checkProfileExists(id);
  }

  Future resetPassword({required String email}) async {
    await authRepository.resetPassword(email: email);
  }

  Future signOutUser() async {
    await authRepository.signingOut();
  }
}
