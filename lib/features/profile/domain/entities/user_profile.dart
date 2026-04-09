class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? address;
  final String? avatarUrl;
  final String tier; // ex: "Djembé Prestige"

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.address,
    this.avatarUrl,
    required this.tier,
  });

  String get fullName => '$firstName $lastName';
}