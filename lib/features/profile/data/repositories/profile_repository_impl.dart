import 'package:djembe_bank_mobile/core/network/api_client.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiClient apiClient;

  ProfileRepositoryImpl(this.apiClient);

  Future<UserProfile> getProfile() async {
    try {
      final response = await apiClient.dio.get('/api/v1/auth/me');
      final data = response.data as Map<String, dynamic>;
      return UserProfile(
        id: data['id'] as String,
        firstName: data['first_name'] as String? ?? '',
        lastName: data['last_name'] as String? ?? '',
        email: data['email'] as String,
        phone: data['phone'] as String? ?? '',
        address: '', // non fourni par l'API
        tier: 'Standard', // à définir selon logique métier
      );
    } catch (e) {
      throw Exception('Erreur chargement profil : $e');
    }
  }

  @override
  Future<void> updateProfile(UserProfile profile) async {
    try {
      await apiClient.dio.patch('/api/v1/auth/profile', data: {
        'first_name': profile.firstName,
        'last_name': profile.lastName,
        'phone': profile.phone,
      });
    } catch (e) {
      throw Exception('Erreur mise à jour profil : $e');
    }
  }
  
  @override
  Future<UserProfile> getUserProfile() {
    return getProfile();
  }
  
  @override
  Future<void> logout() async {
    try {
      await apiClient.dio.post('/api/v1/auth/logout');
    } catch (e) {
      throw Exception('Erreur déconnexion : $e');
    }
  }
}