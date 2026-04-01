import 'package:equatable/equatable.dart';

class RecentTransaction extends Equatable {
  final String id;
  final String title;
  final String category;
  final DateTime date;
  final double amount;

  const RecentTransaction({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
  });

  @override
  List<Object?> get props => [id, title, category, date, amount];
}