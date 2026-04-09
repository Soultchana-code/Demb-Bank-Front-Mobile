import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:djembe_bank_mobile/core/widgets/custom_app_bar.dart';
import '../cubit/cards_cubit.dart';
import '../cubit/cards_state.dart';
import '../../domain/entities/bank_card.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
    context.read<CardsCubit>().loadCards();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Mes Cartes',
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Physique'),
            Tab(text: 'Virtuelle'),
          ],
        ),
      ),
      body: BlocBuilder<CardsCubit, CardsState>(
        builder: (context, state) {
          if (state is CardsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CardsError) {
            return Center(child: Text('Erreur : ${state.message}'));
          } else if (state is CardsLoaded) {
            final cards = state.cards;
            final physicalCard = cards.firstWhere((c) => c.type == 'physical');
            final virtualCard = cards.firstWhere((c) => c.type == 'virtual');
            final currentCard = _selectedIndex == 0 ? physicalCard : virtualCard;
            return _buildCardDetail(currentCard);
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildCardDetail(BankCard card) {
    final isPhysical = card.type == 'physical';
    final gradient = isPhysical
        ? const LinearGradient(
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // === Carte bancaire ===
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DJEMBÉ BANK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    card.cardNumber.length > 4
                        ? card.cardNumber.substring(card.cardNumber.length - 4)
                        : card.cardNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'TITULAIRE',
                            style: TextStyle(color: Colors.white70, fontSize: 10),
                          ),
                          Text(
                            card.holderName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'EXPIRE',
                            style: TextStyle(color: Colors.white70, fontSize: 10),
                          ),
                          Text(
                            card.expiryDate,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),

          // === Actions avec le bon style ===
          _buildActionSection(
            icon: card.isLocked ? Icons.lock : Icons.lock_open,
            title: 'Verrouiller la carte',
            subtitle: card.isLocked ? 'Déverrouiller' : 'Bloquer temporairement',
            trailing: Switch(
              value: card.isLocked,
              onChanged: (value) {
                context.read<CardsCubit>().toggleLock(card.id, card.isLocked);
              },
              activeThumbColor: Colors.blue,
            ),
          ),
          const Divider(height: 1),

          _buildActionSection(
            icon: Icons.settings,
            title: 'Paramètres',
            subtitle: 'Plafonds et sécurité',
            showArrow: true,
          ),
          const Divider(height: 1),

          _buildActionSection(
            icon: Icons.pin,
            title: 'Code PIN',
            subtitle: 'Visualiser ou changer',
            showArrow: true,
            onTap: () => _showPinDialog(card.id),
          ),
          const Divider(height: 1),

          _buildActionSection(
            icon: Icons.apple,
            title: 'Apple Pay',
            subtitle: 'Sans contact',
            showArrow: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    bool showArrow = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: SizedBox(
        width: 40,
        child: Icon(icon, color: Colors.blue.shade700, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      ),
      trailing: trailing ?? (showArrow ? const Icon(Icons.chevron_right, color: Colors.grey) : null),
      onTap: onTap,
    );
  }

  void _showPinDialog(String cardId) {
    final TextEditingController pinController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Changer le code PIN'),
        content: TextField(
          controller: pinController,
          obscureText: true,
          maxLength: 4,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Nouveau PIN (4 chiffres)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final newPin = pinController.text.trim();
              if (newPin.length == 4 && int.tryParse(newPin) != null) {
                context.read<CardsCubit>().changePin(cardId, newPin);
              }
              Navigator.pop(context);
            },
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }
}