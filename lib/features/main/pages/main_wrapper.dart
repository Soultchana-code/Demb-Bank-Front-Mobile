import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:djembe_bank_mobile/injection/injection_container.dart' as di;
import 'package:djembe_bank_mobile/features/cards/presentation/pages/cards_page.dart';
import 'package:djembe_bank_mobile/features/cards/presentation/cubit/cards_cubit.dart';

import 'package:djembe_bank_mobile/features/budget/presentation/pages/budget_page.dart';
import 'package:djembe_bank_mobile/features/circle/presentation/pages/circle_page.dart';
import 'package:djembe_bank_mobile/features/budget/presentation/cubit/budget_cubit.dart';
import 'package:djembe_bank_mobile/features/circle/presentation/cubit/circle_cubit.dart';

import 'package:djembe_bank_mobile/features/profile/presentation/pages/profile_page.dart';
import 'package:djembe_bank_mobile/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:djembe_bank_mobile/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:djembe_bank_mobile/features/dashboard/presentation/cubit/dashboard_cubit.dart';
// ... autres imports

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      BlocProvider(
        create: (_) => di.getIt<DashboardCubit>()..loadDashboard(),
        child: const DashboardPage(),
      ),
      BlocProvider(
        create: (_) => di.getIt<CardsCubit>()..loadCards(),
        child: const CardsPage(),
      ),
      BlocProvider(
        create: (_) => di.getIt<BudgetCubit>()..loadBudget(),
        child: const BudgetPage(),
      ),
      BlocProvider(
        create: (_) => di.getIt<CircleCubit>()..loadCircle(),
        child: const CirclePage(),
      ),
      BlocProvider(
        create: (_) => di.getIt<ProfileCubit>()..loadProfile(),
        child: const ProfilePage(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: 'Cartes'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Budget'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Cercle'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}