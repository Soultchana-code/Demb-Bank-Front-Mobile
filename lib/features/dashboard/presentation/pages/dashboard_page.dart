import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:djembe_bank_mobile/core/widgets/custom_app_bar.dart';
import 'package:djembe_bank_mobile/features/dashboard/domain/entities/savings_goal.dart';

import 'package:djembe_bank_mobile/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:djembe_bank_mobile/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:djembe_bank_mobile/features/transactions/presentation/pages/transactions_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = BlocProvider.of<DashboardCubit>(context, listen: false);
      cubit.loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DashboardCubit>().state;

    if (state is DashboardLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (state is DashboardError) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Erreur : ${state.message}', style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.read<DashboardCubit>().loadDashboard(),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    } else if (state is DashboardLoaded) {
      final account = state.accounts.isNotEmpty ? state.accounts.first : null;
      final transactions = state.transactions;
      final goals = state.goals;

      return Scaffold(
        appBar: CustomAppBar(
          title: 'Djembé Bank',
          actions: [
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Carte de solde (nouveau design) ===
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'Solde disponible',
                        style: TextStyle(fontSize: 14, color: Colors.grey, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        account != null
                            ? '${account.balance.toStringAsFixed(2)} ${account.currency}'
                            : '-- €',
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.add_circle_outline),
                              label: const Text('+ Ajouter'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                backgroundColor: Colors.blue.shade50,
                                foregroundColor: Colors.blue.shade700,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.send_outlined),
                              label: const Text('Envoyer'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                backgroundColor: Colors.blue.shade700,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // === Deuxième rangée d'actions (Virement, Recharger, Scanner, Plus) ===
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _quickAction(Icons.swap_horiz, 'Virement', () {}),
                    _quickAction(Icons.add_circle_outline, 'Recharger', () {}),
                    _quickAction(Icons.qr_code_scanner, 'Scanner', () {}),
                    _quickAction(Icons.more_horiz, 'Plus', () {}),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // === Opérations récentes ===
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Opérations récentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TransactionsPage()),
                      );
                    },
                    child: const Text('Tout voir', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: transactions.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.5),
                  itemBuilder: (context, index) {
                    final t = transactions[index];
                    final isNegative = t.amount < 0;
                    final amountColor = isNegative ? Colors.red : Colors.green;
                    final amountText = '${isNegative ? '-' : '+'}${t.amount.abs().toStringAsFixed(2)} €';
                    IconData icon;
                    switch (t.category.toLowerCase()) {
                      case 'shopping':
                        icon = Icons.shopping_cart;
                        break;
                      case 'entertainment':
                        icon = Icons.music_note;
                        break;
                      case 'income':
                        icon = Icons.work;
                        break;
                      default:
                        icon = Icons.receipt;
                    }
                    return _buildOperation(
                      icon: icon,
                      title: t.title,
                      subtitle: '${_formatDate(t.date)} · ${t.category}',
                      amount: amountText,
                      amountColor: amountColor,
                    );
                  },
                ),
              ),

              // === Bloc d'épargne (dernier, après la liste) ===
              if (goals.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildSavingsCard(goals.first),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      );
    } else {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
  }

  // Widget pour les actions rapides (icône ronde + texte)
  Widget _quickAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: Colors.blue.shade700),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
        ],
      ),
    );
  }

  // Widget pour chaque ligne d'opération
  Widget _buildOperation({
    required IconData icon,
    required String title,
    required String subtitle,
    required String amount,
    required Color amountColor,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade100,
        child: Icon(icon, color: Colors.blue.shade700, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: Text(amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: amountColor)),
    );
  }

  // Widget pour l'objectif d'épargne (sans barre de progression)
  Widget _buildSavingsCard(SavingsGoal goal) {
    final percent = ((goal.current / goal.target) * 100).toStringAsFixed(0);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Mon Épargne', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Objectif: ${goal.target.toStringAsFixed(0)}€', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            Text('${goal.current.toStringAsFixed(0)}€ ($percent%)', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Formater la date (court, sans année)
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return "Aujourd'hui";
    } else if (date.year == now.year && date.month == now.month && date.day == now.day - 1) {
      return 'Hier';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}