import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryMock implements ProfileRepository {
  @override
  Future<UserProfile> getUserProfile() async {
    await Future.delayed(const Duration(seconds: 1));
    return UserProfile(
      id: '1',
      firstName: 'Jean',
      lastName: 'Dupont',
      email: 'jean.dupont@example.com',
      phone: '+221 77 000 00 00',
      address: 'Dakar, Sénégal',
      tier: 'Djembé Prestige',
    );
  }

  @override
  Future<void> updateProfile(UserProfile profile) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simuler une mise à jour
    print('Profil mis à jour : ${profile.fullName}');
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // La déconnexion sera gérée par AuthCubit
  }
}