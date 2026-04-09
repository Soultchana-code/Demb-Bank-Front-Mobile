import '../entities/bank_card.dart';

abstract class CardsRepository {
  Future<List<BankCard>> getCards();
  Future<void> toggleCardLock(String cardId, bool isLocked);
  Future<void> updatePin(String cardId, String newPin);
}