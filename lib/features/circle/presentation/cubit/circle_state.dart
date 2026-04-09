import '../../domain/entities/pot.dart';
import '../../domain/entities/friend.dart';
import '../../domain/entities/referral.dart';

abstract class CircleState {}

class CircleInitial extends CircleState {}
class CircleLoading extends CircleState {}
class CircleLoaded extends CircleState {
  final List<Pot> pots;
  final List<Friend> friends;
  final Referral referral;

  CircleLoaded({required this.pots, required this.friends, required this.referral});
}
class CircleError extends CircleState {
  final String message;
  CircleError(this.message);
}