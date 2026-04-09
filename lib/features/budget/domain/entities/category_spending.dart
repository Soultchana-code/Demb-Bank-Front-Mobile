class CategorySpending {
  final String category;
  final double amount;
  final String icon; // nom d'icône (optionnel)

  CategorySpending({
    required this.category,
    required this.amount,
    this.icon = '',
  });
}