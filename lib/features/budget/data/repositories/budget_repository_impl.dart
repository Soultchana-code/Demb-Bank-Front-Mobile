import 'package:djembe_bank_mobile/core/network/api_client.dart';
import '../../domain/entities/category_spending.dart';
import '../../domain/entities/savings_goal.dart';
import '../../domain/repositories/budget_repository.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final ApiClient apiClient;

  BudgetRepositoryImpl(this.apiClient);

  @override
  Future<List<CategorySpending>> getMonthlySpending(int year, int month) async {
    try {
      final response = await apiClient.dio.get('/api/v1/budget/spending', queryParameters: {
        'year': year,
        'month': month,
      });
      final List<dynamic> data = response.data is List ? response.data : (response.data as Map)['data'] ?? [];
      return data.map((item) => CategorySpending(
        category: item['category'] as String,
        amount: (item['amount'] as num).toDouble(),
      )).toList();
    } catch (e) {
      throw Exception('Erreur chargement dépenses : $e');
    }
  }

  @override
  Future<List<SavingsGoal>> getSavingsGoals() async {
    try {
      final response = await apiClient.dio.get('/api/v1/budget/goals');
      final List<dynamic> data = response.data is List ? response.data : (response.data as Map)['data'] ?? [];
      return data.map((item) => SavingsGoal(
        id: item['id'].toString(),
        name: item['name'] as String,
        target: (item['target'] as num).toDouble(),
        current: (item['current'] as num).toDouble(),
      )).toList();
    } catch (e) {
      throw Exception('Erreur chargement objectifs : $e');
    }
  }
}