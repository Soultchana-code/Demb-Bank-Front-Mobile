// TODO: implement getSavingsGoals
import 'package:djembe_bank_mobile/features/dashboard/domain/entities/account_summary.dart';
import 'package:djembe_bank_mobile/features/dashboard/domain/entities/recent_transaction.dart';
import 'package:djembe_bank_mobile/features/dashboard/domain/entities/savings_goal.dart';
import 'package:djembe_bank_mobile/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryMock implements DashboardRepository {
  @override
  Future<List<AccountSummary>> getAccounts() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      AccountSummary(id: '1', name: 'Compte Principal', balance: 2450.80, currency: 'EUR'),
    ];
  }

  @override
  Future<List<RecentTransaction>> getRecentTransactions() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      RecentTransaction(
        id: '1', // <- String
        title: 'Carrefour Market',
        category: 'Shopping',
        date: DateTime.now(),
        amount: -45.90,
      ),
      RecentTransaction(
        id: '2', // <- String
        title: 'Spotify Premium',
        category: 'Entertainment',
        date: DateTime.now().subtract(const Duration(days: 1)),
        amount: -9.99,
      ),
      RecentTransaction(
        id: '3', // <- String
        title: 'Virement Salaire',
        category: 'Income',
        date: DateTime(2026, 2, 28),
        amount: 1250.00,
      ),
    ];
  }

  @override
  Future<List<SavingsGoal>> getSavingsGoals() async {
   return [];
  }
}