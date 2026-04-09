import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/circle_repository.dart';
import 'circle_state.dart';

class CircleCubit extends Cubit<CircleState> {
  final CircleRepository repository;

  CircleCubit(this.repository) : super(CircleInitial());

  Future<void> loadCircle() async {
    emit(CircleLoading());
    try {
      final pots = await repository.getActivePots();
      final friends = await repository.getRecentFriends();
      final referral = await repository.getReferralInfo();
      emit(CircleLoaded(pots: pots, friends: friends, referral: referral));
    } catch (e) {
      emit(CircleError(e.toString()));
    }
  }
}