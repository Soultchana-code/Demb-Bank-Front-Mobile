import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getUserProfile();
  Future<void> updateProfile(UserProfile profile);
  Future<void> logout();
}