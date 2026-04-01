import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:djembe_bank_mobile/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:djembe_bank_mobile/features/dashboard/presentation/cubit/dashboard_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // On attend que le premier frame soit construit pour être sûr que le BlocProvider est disponible
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

      return Scaffold(
        appBar: AppBar(
          title: const Text('Banque de Djembé'),
          centerTitle: false,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Solde disponible', style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                account != null
                    ? '${account.balance.toStringAsFixed(2)} ${account.currency}'
                    : '-- €',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Text('+ Ajouter'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Text('Envoyer'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Opérations récentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Tout voir'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: transactions.length,
                  separatorBuilder: (_, __) => const Divider(),
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
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        child: Icon(icon, color: Colors.black54),
                      ),
                      title: Text(t.title),
                      subtitle: Text('${_formatDate(t.date)} · ${t.category}'),
                      trailing: Text(amountText, style: TextStyle(fontWeight: FontWeight.bold, color: amountColor)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
            BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: 'Cartes'),
            BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Budget'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Cercle'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      );
    } else {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return "Aujourd'hui";
    } else if (date.year == now.year && date.month == now.month && date.day == now.day - 1) {
      return 'Hier';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}