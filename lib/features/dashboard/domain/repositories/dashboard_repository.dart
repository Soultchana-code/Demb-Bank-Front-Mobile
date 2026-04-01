// features/dashboard/domain/repositories/dashboard_repository.dart
import 'package:djembe_bank_mobile/features/dashboard/domain/entities/account_summary.dart';
import 'package:djembe_bank_mobile/features/dashboard/domain/entities/recent_transaction.dart';
import 'package:djembe_bank_mobile/features/dashboard/domain/entities/savings_goal.dart';

abstract class DashboardRepository {
  Future<List<AccountSummary>> getAccounts();
  Future<List<RecentTransaction>> getRecentTransactions();
  Future<List<SavingsGoal>> getSavingsGoals();
}