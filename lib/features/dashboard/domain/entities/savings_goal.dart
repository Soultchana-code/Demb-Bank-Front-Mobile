import 'package:equatable/equatable.dart';

class SavingsGoal extends Equatable {
  final int id;
  final String name;
  final double target;
  final double current;

  const SavingsGoal({
    required this.id,
    required this.name,
    required this.target,
    required this.current,
  });

  @override
  List<Object?> get props => [id, name, target, current];

  Null get progress => null;
}
