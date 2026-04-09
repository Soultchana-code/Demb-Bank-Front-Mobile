import 'package:flutter/material.dart';
import '../../domain/entities/bank_card.dart';
import '../../domain/repositories/cards_repository.dart';

class CardsRepositoryMock implements CardsRepository {
  final List<BankCard> _cards = [
    BankCard(
      id: '1',
      cardNumber: '**** **** **** 8821',
      holderName: 'JEAN DUPONT',
      expiryDate: '12/28',
      type: 'physical',
      isLocked: false,
    ),
    BankCard(
      id: '2',
      cardNumber: '**** **** **** 7712',
      holderName: 'JEAN DUPONT',
      expiryDate: '09/27',
      type: 'virtual',
      isLocked: false,
    ),
  ];

  @override
  Future<List<BankCard>> getCards() async {
    await Future.delayed(const Duration(seconds: 1));
    return _cards;
  }

  @override
  Future<void> toggleCardLock(String cardId, bool isLocked) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _cards.indexWhere((c) => c.id == cardId);
    if (index != -1) {
      _cards[index] = BankCard(
        id: _cards[index].id,
        cardNumber: _cards[index].cardNumber,
        holderName: _cards[index].holderName,
        expiryDate: _cards[index].expiryDate,
        type: _cards[index].type,
        isLocked: isLocked,
      );
    }
  }

  @override
  Future<void> updatePin(String cardId, String newPin) async {
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('PIN mis à jour pour carte $cardId : $newPin');
  }
}