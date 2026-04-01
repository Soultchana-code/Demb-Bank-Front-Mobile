import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:djembe_bank_mobile/injection/injection_container.dart' as di;

import 'package:djembe_bank_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:djembe_bank_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:djembe_bank_mobile/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:djembe_bank_mobile/features/dashboard/presentation/cubit/dashboard_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.configureDependencies(useMocks: false);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupérer l'instance unique de AuthCubit (singleton)
    final authCubit = di.getIt<AuthCubit>();

    return BlocProvider.value(
      value: authCubit,
      child: MaterialApp(
        title: 'Djembé Bank',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late Future<bool> _hasTokenFuture;

  @override
  void initState() {
    super.initState();
    final storage = const FlutterSecureStorage();
    _hasTokenFuture = storage.read(key: 'access_token').then((token) => token != null);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasTokenFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final hasToken = snapshot.data ?? false;

        if (hasToken) {
          // Créer le BlocProvider avec le cubit, sans appeler loadDashboard ici
          return BlocProvider(
            create: (_) => di.getIt<DashboardCubit>(),
            child: const DashboardPage(),
          );
        } else {
          // AuthCubit est déjà fourni globalement
          return const LoginPage();
        }
      },
    );
  }
}