import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:djembe_bank_mobile/core/widgets/custom_app_bar.dart';
import '../cubit/budget_cubit.dart';
import '../cubit/budget_state.dart';
import '../../domain/entities/savings_goal.dart';
import '../../domain/entities/category_spending.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  @override
  void initState() {
    super.initState();
    context.read<BudgetCubit>().loadBudget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Mon Budget',
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
        ],
      ),
      body: BlocBuilder<BudgetCubit, BudgetState>(
        builder: (context, state) {
          if (state is BudgetLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BudgetError) {
            return Center(child: Text('Erreur : ${state.message}'));
          } else if (state is BudgetLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Carte principale : titre centré + graphique + liste des dépenses
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Titre centré
                          Center(
                            child: Text(
                              'Dépenses de ${_getMonthName(state.month)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Graphique circulaire
                          _buildPieChart(state.spending),
                          const SizedBox(height: 24),
                          // Liste des dépenses
                          ...state.spending.map((cat) => _buildSpendingItem(cat)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Section Objectifs d'épargne
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Objectifs d\'épargne',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...state.goals.map((goal) => _buildSavingsGoalCard(goal)),
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  // Élément de dépense : catégorie à gauche, montant à droite
  Widget _buildSpendingItem(CategorySpending cat) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            cat.category,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            '${cat.amount.toStringAsFixed(0)}€',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Graphique circulaire pour les dépenses
  Widget _buildPieChart(List<CategorySpending> spending) {
    final total = spending.fold(0.0, (sum, item) => sum + item.amount);
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: spending.map((cat) {
            final percentage = (cat.amount / total) * 100;
            return PieChartSectionData(
              value: cat.amount,
              title: '${percentage.toStringAsFixed(0)}%',
              color: _getColorForCategory(cat.category),
              radius: 80,
              titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            );
          }).toList(),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

  // Couleur associée à chaque catégorie de dépense
  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Shopping':
        return Colors.blue;
      case 'Alimentation':
        return Colors.green;
      case 'Transport':
        return Colors.orange;
      case 'Loisirs':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // Carte d'objectif d'épargne (stylisée)
  Widget _buildSavingsGoalCard(SavingsGoal goal) {
    final percent = ((goal.current / goal.target) * 100).toStringAsFixed(0);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(goal.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text('Objectif: ${goal.target.toStringAsFixed(0)}€', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${goal.current.toStringAsFixed(0)}€', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('$percent%', style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: goal.current / goal.target,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return months[month - 1];
  }
}