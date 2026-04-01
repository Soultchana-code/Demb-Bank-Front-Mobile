import 'package:equatable/equatable.dart';
import 'package:djembe_bank_mobile/features/dashboard/domain/entities/account_summary.dart';
import 'package:djembe_bank_mobile/features/dashboard/domain/entities/recent_transaction.dart';
import 'package:djembe_bank_mobile/features/dashboard/domain/entities/savings_goal.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final List<AccountSummary> accounts;
  final List<RecentTransaction> transactions;
  final List<SavingsGoal> goals;

  const DashboardLoaded({
    required this.accounts,
    required this.transactions,
    required this.goals,
  });

  @override
  List<Object?> get props => [accounts, transactions, goals];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}