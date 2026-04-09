import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:djembe_bank_mobile/core/widgets/custom_app_bar.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../domain/entities/user_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profil',
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileError) {
            return Center(child: Text('Erreur : ${state.message}'));
          } else if (state is ProfileLoaded) {
            final user = state.user;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Carte d'en-tête (photo, nom, tier)
                _buildHeaderCard(user),
                const SizedBox(height: 16),
                // Carte Informations personnelles
                _buildInfoCard(user),
                const SizedBox(height: 16),
                // Carte Sécurité
                _buildSecurityCard(),
                const SizedBox(height: 16),
                // Carte Notifications
                _buildNotificationsCard(),
                const SizedBox(height: 16),
                // Carte Préférences
                _buildPreferencesCard(),
                const SizedBox(height: 16),
                // Carte Aide & Support
                _buildSupportCard(),
                const SizedBox(height: 16),
                // Carte Déconnexion
                _buildLogoutCard(context),
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  // Carte d'en-tête
  Widget _buildHeaderCard(UserProfile user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                user.firstName[0].toUpperCase(),
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user.fullName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                user.tier,
                style: TextStyle(color: Colors.blue.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Carte Informations personnelles
  Widget _buildInfoCard(UserProfile user) {
    return _buildSectionCard(
      title: 'Informations personnelles',
      children: [
        _buildInfoTile(Icons.email, 'Email', user.email),
        const Divider(height: 1),
        _buildInfoTile(Icons.phone, 'Téléphone', user.phone),
        const Divider(height: 1),
        _buildInfoTile(Icons.location_on, 'Adresse', user.address ?? 'Non renseigné'),
      ],
    );
  }

  // Carte Sécurité
  Widget _buildSecurityCard() {
    return _buildSectionCard(
      title: 'Sécurité',
      children: [
        _buildSettingsTile(Icons.face, 'FaceID', 'Configurer'),
        const Divider(height: 1),
        _buildSettingsTile(Icons.pin, 'Code PIN', 'Modifier'),
        const Divider(height: 1),
        _buildSettingsTile(Icons.devices, 'Appareils', 'Gérer'),
      ],
    );
  }

  // Carte Notifications
  Widget _buildNotificationsCard() {
    return _buildSectionCard(
      title: 'Notifications',
      children: [
        _buildSettingsTile(Icons.notifications, 'Alertes', 'Activer'),
        const Divider(height: 1),
        _buildSettingsTile(Icons.local_offer, 'Offres', 'Paramétrer'),
        const Divider(height: 1),
        _buildSettingsTile(Icons.receipt, 'Relevés', 'Consulter'),
      ],
    );
  }

  // Carte Préférences
  Widget _buildPreferencesCard() {
    return _buildSectionCard(
      title: 'Préférences',
      children: [
        _buildSettingsTile(Icons.language, 'Langue', 'Français'),
        const Divider(height: 1),
        _buildSettingsTile(Icons.currency_exchange, 'Devise', 'EUR'),
        const Divider(height: 1),
        _buildSettingsTile(Icons.dark_mode, 'Thème', 'Clair'),
      ],
    );
  }

  // Carte Aide & Support
  Widget _buildSupportCard() {
    return _buildSectionCard(
      title: 'Aide & Support',
      children: [
        _buildSettingsTile(Icons.help, 'FAQ', 'Consulter'),
        const Divider(height: 1),
        _buildSettingsTile(Icons.chat, 'Chat', 'Contacter'),
        const Divider(height: 1),
        _buildSettingsTile(Icons.contact_mail, 'Contact', 'Envoyer un email'),
      ],
    );
  }

  // Carte Déconnexion
  Widget _buildLogoutCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text('Déconnexion'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showLogoutDialog(context),
      ),
    );
  }

  // Widget générique pour une carte de section
  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Column(children: children),
        ],
      ),
    );
  }

  // Ligne d'information (email, téléphone, adresse)
  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(label),
      subtitle: Text(value),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  // Ligne de paramètre (avec flèche)
  Widget _buildSettingsTile(IconData icon, String label, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(label),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Navigation vers l'écran correspondant
        Navigator.pushNamed(context, '/profile-settings');
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthCubit>().logout();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }
}