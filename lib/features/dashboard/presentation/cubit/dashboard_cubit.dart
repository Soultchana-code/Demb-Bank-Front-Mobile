import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:djembe_bank_mobile/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository repository;

  DashboardCubit(this.repository) : super(const DashboardInitial());

  Future<void> loadDashboard() async {
    emit(const DashboardLoading());
    try {
      final accounts = await repository.getAccounts();
      final transactions = await repository.getRecentTransactions();
      final goals = await repository.getSavingsGoals();

      emit(DashboardLoaded(
        accounts: accounts,
        transactions: transactions,
        goals: goals,
      ));
    } catch (e, stack) {
      // Log pour debug
      print('Erreur dans DashboardCubit: $e');
      print(stack);
      emit(DashboardError(e.toString()));
    }
  }
}