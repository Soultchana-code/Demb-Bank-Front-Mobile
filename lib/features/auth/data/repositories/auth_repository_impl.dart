import 'package:dio/dio.dart';
import 'package:djembe_bank_mobile/core/network/api_client.dart';
import 'package:djembe_bank_mobile/core/services/secure_storage_service.dart';
import 'package:djembe_bank_mobile/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;
  final SecureStorageService storage;

  AuthRepositoryImpl(this.apiClient, this.storage);

  @override
  Future<String> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post(
        '/api/v1/auth/login',
        data: {
          'username': email,
          'password': password,
          'grant_type': 'password',
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          // Désactiver la désérialisation automatique
          responseType: ResponseType.json,
        ),
      );

      // Récupérer le corps de la réponse en Map
      final Map<String, dynamic> data = response.data;

      final String accessToken = data['access_token'];
      final String refreshToken = data['refresh_token'] ?? '';
      final String tenantCode = data['tenant_code'];

      await storage.saveTokens(accessToken, refreshToken);
      await storage.saveTenantCode(tenantCode);

      return accessToken;
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response!.data as Map)['detail'] ?? e.message
          : e.message;
      throw Exception('Erreur de connexion : $message');
    }
  }

  @override
  Future<void> logout() async {
    await storage.clearTokens();
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    String role = 'user',
  }) async {
    try {
      await apiClient.dio.post(
        '/api/v1/auth/register',
        data: {
          'email': email,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
          'role': role,
        },
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
    } on DioException catch (e) {
      String message;
      if (e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data['detail'] is String) {
          message = data['detail'];
        } else if (data['detail'] is List) {
          message = (data['detail'] as List)
              .map((err) => err['msg'] ?? err.toString())
              .join(', ');
        } else {
          message = 'Erreur inconnue';
        }
      } else {
        message = e.message ?? 'Erreur inconnue';
      }
      throw Exception('Erreur d\'inscription : $message');
    }
  }
}