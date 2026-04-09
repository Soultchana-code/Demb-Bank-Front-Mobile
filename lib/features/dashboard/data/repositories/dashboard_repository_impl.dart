import 'package:djembe_bank_mobile/core/network/api_client.dart';
import 'package:djembe_bank_mobile/features/dashboard/domain/entities/savings_goal.dart';
import 'package:djembe_bank_mobile/features/dashboard/domain/entities/account_summary.dart';
import 'package:djembe_bank_mobile/features/dashboard/domain/entities/recent_transaction.dart';

import 'package:djembe_bank_mobile/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final ApiClient apiClient;

  DashboardRepositoryImpl(this.apiClient);

  @override
  Future<List<AccountSummary>> getAccounts() async {
    try {
      final response = await apiClient.dio.get('/api/v1/accounts');
      final List<dynamic> data = response.data is List ? response.data : (response.data as Map)['data'] ?? [];
      return data.map((item) {
        final balances = item['balances'] as List?;
        final balanceObj = balances != null && balances.isNotEmpty ? balances[0] as Map : null;
        final balance = balanceObj != null ? (balanceObj['available'] as num?)?.toDouble() ?? 0.0 : 0.0;
        final currency = balanceObj != null ? balanceObj['currency'] as String? ?? 'XOF' : 'XOF';
        return AccountSummary(
          id: item['id'] as String,
          name: item['account_type'] as String? ?? 'Compte',
          balance: balance,
          currency: currency,
        );
      }).toList();
    } catch (e) {
      throw Exception('Erreur chargement comptes : $e');
    }
  }

  @override
  Future<List<RecentTransaction>> getRecentTransactions() async {
    try {
      final response = await apiClient.dio.get('/api/v1/transactions', queryParameters: {'page_size': 10});
      final List<dynamic> data = response.data is List ? response.data : (response.data as Map)['data'] ?? [];
      return data.map((item) {
        return RecentTransaction(
          id: item['id'] as String,
          title: item['reference'] as String? ?? 'Transaction',
          category: item['type'] as String? ?? 'Autre',
          date: DateTime.parse(item['created_at'] as String),
          amount: (item['amount'] as num?)?.toDouble() ?? 0.0,
        );
      }).toList();
    } catch (e) {
      throw Exception('Erreur chargement transactions : $e');
    }
  }

  @override
  Future<List<SavingsGoal>> getSavingsGoals() async {
    // Endpoint à confirmer avec le backend (ex: /api/v1/budget/goals)
    // Si non disponible, retourner une liste vide
    return [];
  }
}