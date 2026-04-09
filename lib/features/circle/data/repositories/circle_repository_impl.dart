import 'package:djembe_bank_mobile/core/network/api_client.dart';
import 'package:djembe_bank_mobile/features/circle/domain/entities/pot.dart';
import 'package:djembe_bank_mobile/features/circle/domain/entities/referral.dart';
import '../../domain/entities/friend.dart';
import '../../domain/repositories/circle_repository.dart';

class CircleRepositoryImpl implements CircleRepository {
  final ApiClient apiClient;

  CircleRepositoryImpl(this.apiClient);

  @override
  Future<List<Friend>> getRecentFriends() async {
    try {
      final response = await apiClient.dio.get('/api/v1/circle/friends');
      final List<dynamic> data = response.data is List ? response.data : [];
      return data.map((item) => Friend(
        id: item['id'].toString(),
        name: item['name'],
        avatarUrl: item['avatar_url'],
      )).toList();
    } catch (e) {
      throw Exception('Erreur chargement amis : $e');
    }
  }

  @override
  Future<List<Pot>> getActivePots() async {
    try {
      final response = await apiClient.dio.get('/api/v1/circle/pots/active');
      final List<dynamic> data = response.data is List ? response.data : [];
      return data.map((item) => Pot(
        id: item['id'].toString(),
        name: item['name'],
        description: item['description'],
        target: (item['target_amount'] as num).toDouble(),
        current: (item['current_amount'] as num).toDouble(),
      )).toList();
    } catch (e) {
      throw Exception('Erreur chargement cagnottes : $e');
    }
  }

  @override
  Future<Referral> getReferralInfo() async {
    try {
      final response = await apiClient.dio.get('/api/v1/circle/referral');
      final data = response.data;
      return Referral(
        referralCode: data['referral_code'],
        referralCount: data['referral_count'],
        referralBonus: (data['referral_bonus'] as num).toDouble(), code: '', message: '',
      );
    } catch (e) {
      throw Exception('Erreur chargement parrainage : $e');
    }
  }

  // Les endpoints pour les cagnottes (pots) et parrainage ne sont pas dans la doc actuelle.
  // On garde les mocks pour ces parties.
}