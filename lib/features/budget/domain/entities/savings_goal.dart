class SavingsGoal {
  final String id;
  final String name;
  final double target;
  final double current;

  SavingsGoal({
    required this.id,
    required this.name,
    required this.target,
    required this.current,
  });

  double get progress => current / target;
}