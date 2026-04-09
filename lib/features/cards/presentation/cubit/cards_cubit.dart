import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/cards_repository.dart';
import 'cards_state.dart';

class CardsCubit extends Cubit<CardsState> {
  final CardsRepository repository;

  CardsCubit(this.repository) : super(CardsInitial());

  Future<void> loadCards() async {
    emit(CardsLoading());
    try {
      final cards = await repository.getCards();
      emit(CardsLoaded(cards));
    } catch (e) {
      emit(CardsError(e.toString()));
    }
  }

  Future<void> toggleLock(String cardId, bool currentLockState) async {
    try {
      await repository.toggleCardLock(cardId, !currentLockState);
      await loadCards();
    } catch (e) {
      emit(CardsError(e.toString()));
    }
  }

  void changePin(String cardId, String newPin) {}
}