import '../../domain/entities/category_spending.dart';
import '../../domain/entities/savings_goal.dart';

abstract class BudgetState {}

class BudgetInitial extends BudgetState {}
class BudgetLoading extends BudgetState {}
class BudgetLoaded extends BudgetState {
  final List<CategorySpending> spending;
  final List<SavingsGoal> goals;
  final int year;
  final int month;

  BudgetLoaded({
    required this.spending,
    required this.goals,
    required this.year,
    required this.month,
  });
}
class BudgetError extends BudgetState {
  final String message;
  BudgetError(this.message);
}