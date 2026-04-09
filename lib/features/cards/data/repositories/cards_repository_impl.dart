import 'package:djembe_bank_mobile/core/network/api_client.dart';
import '../../domain/entities/bank_card.dart';
import '../../domain/repositories/cards_repository.dart';

class CardsRepositoryImpl implements CardsRepository {
  final ApiClient apiClient;

  CardsRepositoryImpl(this.apiClient);

  @override
  Future<List<BankCard>> getCards() async {
    try {
      final response = await apiClient.dio.get('/api/v1/cards');
      final List<dynamic> data = response.data is List ? response.data : [];
      return data.map((item) => BankCard(
        id: item['id'].toString(),
        cardNumber: '**** **** **** ${item['last_4_digits']}',
        holderName: '', // à récupérer depuis le profil
        expiryDate: item['expiry_date'],
        type: item['card_type'],
        isLocked: item['status'] == 'frozen',
      )).toList();
    } catch (e) {
      throw Exception('Erreur chargement cartes : $e');
    }
  }

  @override
  Future<void> toggleCardLock(String cardId, bool isLocked) async {
    try {
      final endpoint = isLocked ? '/api/v1/cards/$cardId/freeze' : '/api/v1/cards/$cardId/unfreeze';
      await apiClient.dio.post(endpoint);
    } catch (e) {
      throw Exception('Erreur verrouillage carte : $e');
    }
  }

  Future<void> updateCardSettings(String cardId, Map<String, dynamic> settings) async {
    try {
      await apiClient.dio.patch('/api/v1/cards/$cardId/settings', data: settings);
    } catch (e) {
      throw Exception('Erreur mise à jour paramètres carte : $e');
    }
  }

  Future<Map<String, String>> revealCard(String cardId) async {
    try {
      final response = await apiClient.dio.post('/api/v1/cards/$cardId/reveal');
      return {
        'cardNumber': response.data['card_number'],
        'cvv': response.data['cvv'],
        'expiryDate': response.data['expiry_date'],
      };
    } catch (e) {
      throw Exception('Erreur révélation carte : $e');
    }
  }
  
  @override
  Future<void> updatePin(String cardId, String newPin) async {
    try {
      await apiClient.dio.patch('/api/v1/cards/$cardId/pin', data: {'pin': newPin});
    } catch (e) {
      throw Exception('Erreur mise à jour PIN : $e');
    }
  }
}