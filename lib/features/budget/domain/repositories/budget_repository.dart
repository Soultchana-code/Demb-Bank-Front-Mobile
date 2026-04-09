import '../entities/category_spending.dart';
import '../entities/savings_goal.dart';

abstract class BudgetRepository {
  Future<List<CategorySpending>> getMonthlySpending(int year, int month);
  Future<List<SavingsGoal>> getSavingsGoals();
}