import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/budget_repository.dart';
import 'budget_state.dart';

class BudgetCubit extends Cubit<BudgetState> {
  final BudgetRepository repository;

  BudgetCubit(this.repository) : super(BudgetInitial());

  Future<void> loadBudget({int? year, int? month}) async {
    final now = DateTime.now();
    final y = year ?? now.year;
    final m = month ?? now.month;
    emit(BudgetLoading());
    try {
      final spending = await repository.getMonthlySpending(y, m);
      final goals = await repository.getSavingsGoals();
      emit(BudgetLoaded(spending: spending, goals: goals, year: y, month: m));
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }
}