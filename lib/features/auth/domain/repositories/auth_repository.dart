abstract class AuthRepository {
  Future<String> login(String email, String password);
  Future<void> logout();
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    String role = 'user',
  });
}
