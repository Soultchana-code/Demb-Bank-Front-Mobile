class BankCard {
  final String id;
  final String cardNumber;
  final String holderName;
  final String expiryDate;
  final String type;
  final bool isLocked;

  BankCard({
    required this.id,
    required this.cardNumber,
    required this.holderName,
    required this.expiryDate,
    required this.type,
    required this.isLocked,
  });
}