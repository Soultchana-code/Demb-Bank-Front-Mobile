import '../../domain/entities/category_spending.dart';
import '../../domain/entities/savings_goal.dart';
import '../../domain/repositories/budget_repository.dart';

class BudgetRepositoryMock implements BudgetRepository {
  @override
  Future<List<CategorySpending>> getMonthlySpending(int year, int month) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      CategorySpending(category: 'Shopping', amount: 400),
      CategorySpending(category: 'Alimentation', amount: 300),
      CategorySpending(category: 'Transport', amount: 150),
      CategorySpending(category: 'Loisirs', amount: 200),
    ];
  }

  @override
  Future<List<SavingsGoal>> getSavingsGoals() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      SavingsGoal(id: '1', name: 'Voyage à Dakar', target: 1500, current: 850),
      SavingsGoal(id: '2', name: 'Fonds d’urgence', target: 2000, current: 400),
    ];
  }
}