import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:djembe_bank_mobile/core/widgets/custom_app_bar.dart';
import '../cubit/circle_cubit.dart';
import '../cubit/circle_state.dart';
import '../../domain/entities/pot.dart';
import '../../domain/entities/friend.dart';

class CirclePage extends StatefulWidget {
  const CirclePage({super.key});

  @override
  State<CirclePage> createState() => _CirclePageState();
}

class _CirclePageState extends State<CirclePage> {
  @override
  void initState() {
    super.initState();
    context.read<CircleCubit>().loadCircle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Djembé Circle',
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
        ],
      ),
      body: BlocBuilder<CircleCubit, CircleState>(
        builder: (context, state) {
          if (state is CircleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CircleError) {
            return Center(child: Text('Erreur : ${state.message}'));
          } else if (state is CircleLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // === Carte des cagnottes actives ===
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Cagnottes actives',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          ...state.pots.map((pot) => _buildPotCard(pot)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // === Section Amis récents ===
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Amis récents',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFriendsList(state.friends),
                  const SizedBox(height: 24),

                  // === Section Parrainage (dans une carte) ===
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Parrainez un ami',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(state.referral.message),
                          const SizedBox(height: 16),
                          _buildReferralCode(state.referral.code),
                        ],
                      ),
                    ),
                  ),
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

  // Widget pour une cagnotte (sans barre de progression, juste nom et montant)
  Widget _buildPotCard(Pot pot) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            pot.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            '${pot.current.toStringAsFixed(0)}€ / ${pot.target.toStringAsFixed(0)}€',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Liste des amis (avatars)
  Widget _buildFriendsList(List<Friend> friends) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: [
        ...friends.map((friend) => _buildFriendAvatar(friend)),
        _buildAddFriendButton(),
      ],
    );
  }

  Widget _buildFriendAvatar(Friend friend) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey.shade300,
          child: Text(
            friend.name[0].toUpperCase(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Text(friend.name, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildAddFriendButton() {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue.shade100,
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.blue),
            onPressed: () {
              // TODO: naviguer vers ajout d'ami
            },
          ),
        ),
        const SizedBox(height: 4),
        const Text('Ajoutez', style: TextStyle(fontSize: 12)),
      ],
    );
  }

  // Widget pour le code de parrainage (bouton de partage)
  Widget _buildReferralCode(String code) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            code,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: partager le code
            },
            icon: const Icon(Icons.share),
            label: const Text('Partager'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}