import 'package:flutter/material.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String _searchQuery = '';
  String _selectedFilter = 'Tous'; // 'Tous', 'Ce mois', 'Entrées', 'Sorties'

  // Données mockées (à remplacer par un vrai repository plus tard)
  final List<Map<String, dynamic>> _allTransactions = [
    {'title': 'Carrefour Market', 'date': DateTime.now(), 'category': 'Shopping', 'amount': -45.90},
    {'title': 'Spotify Premium', 'date': DateTime.now().subtract(const Duration(days: 1)), 'category': 'Entertainment', 'amount': -9.99},
    {'title': 'Virement Salaire', 'date': DateTime(2026, 2, 28), 'category': 'Income', 'amount': 1250.00},
    {'title': 'Carrefour Market', 'date': DateTime.now().subtract(const Duration(days: 1)), 'category': 'Shopping', 'amount': -44.50},
    {'title': 'Netflix', 'date': DateTime(2026, 2, 25), 'category': 'Entertainment', 'amount': -12.99},
    {'title': 'Loyer', 'date': DateTime(2026, 2, 1), 'category': 'Housing', 'amount': -500.00},
  ];

  List<Map<String, dynamic>> get _filteredTransactions {
    var list = _allTransactions.where((t) {
      // Filtre par recherche
      if (_searchQuery.isNotEmpty && !t['title'].toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      // Filtre par type
      if (_selectedFilter == 'Entrées' && t['amount'] >= 0) return false;
      if (_selectedFilter == 'Sorties' && t['amount'] < 0) return false;
      if (_selectedFilter == 'Ce mois') {
        final now = DateTime.now();
        if (t['date'].year != now.year || t['date'].month != now.month) return false;
      }
      return true;
    }).toList();
    // Trier par date décroissante
    list.sort((a, b) => b['date'].compareTo(a['date']));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opérations'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher une opération...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          // Filtres
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['Tous', 'Ce mois', 'Entrées', 'Sorties'].map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedFilter = filter);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(),
          // Liste groupée par date
          Expanded(
            child: ListView.builder(
              itemCount: _groupedTransactions().length,
              itemBuilder: (context, index) {
                final group = _groupedTransactions()[index];
                final dateLabel = group['label'];
                final transactions = group['transactions'] as List<Map<String, dynamic>>;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        dateLabel,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    ...transactions.map((t) => _buildTransactionTile(t)),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _groupedTransactions() {
    final Map<String, List<Map<String, dynamic>>> groups = {};
    for (var t in _filteredTransactions) {
      String label;
      final date = t['date'] as DateTime;
      final now = DateTime.now();
      if (date.year == now.year && date.month == now.month && date.day == now.day) {
        label = "AUJOURD'HUI";
      } else if (date.year == now.year && date.month == now.month && date.day == now.day - 1) {
        label = 'HIER';
      } else {
        label = '${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)} ${date.year}';
      }
      groups.putIfAbsent(label, () => []).add(t);
    }
    // Trier les groupes : AUJOURD'HUI, HIER, puis dates décroissantes
    final keys = groups.keys.toList();
    keys.sort((a, b) {
      if (a == "AUJOURD'HUI") return -1;
      if (b == "AUJOURD'HUI") return 1;
      if (a == 'HIER') return -1;
      if (b == 'HIER') return 1;
      // Comparer les dates (formats "DD MONTH YYYY")
      return b.compareTo(a);
    });
    return keys.map((key) => {'label': key, 'transactions': groups[key]!}).toList();
  }

  String _monthName(int month) {
    const months = ['JAN', 'FÉV', 'MAR', 'AVR', 'MAI', 'JUN', 'JUL', 'AOÛ', 'SEP', 'OCT', 'NOV', 'DÉC'];
    return months[month - 1];
  }

  Widget _buildTransactionTile(Map<String, dynamic> t) {
    final amount = t['amount'] as double;
    final isNegative = amount < 0;
    final amountColor = isNegative ? Colors.red : Colors.green;
    final amountText = '${isNegative ? '-' : '+'}${amount.abs().toStringAsFixed(2)} €';
    IconData icon;
    switch (t['category'].toLowerCase()) {
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
      title: Text(t['title']),
      subtitle: Text('${_formatDate(t['date'])} · ${t['category']}'),
      trailing: Text(amountText, style: TextStyle(fontWeight: FontWeight.bold, color: amountColor)),
    );
  }

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