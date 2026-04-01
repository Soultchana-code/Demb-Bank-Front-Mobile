import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:djembe_bank_mobile/core/services/secure_storage_service.dart';

class ApiClient {
  static const String baseUrlDev = 'https://dev-api.djembebank.com';
  static const String baseUrlProd = 'https://api.djembebank.com';
  static const String baseUrlEmulator = 'http://10.0.2.2:8000';   // Android Emulator
  static const String baseUrlSimulator = 'http://localhost:8000'; // iOS Simulator

  final Dio dio;
  final SecureStorageService storage;

  ApiClient({required this.storage, required String baseUrl})
      : dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {'Content-Type': 'application/json'},
        )) {
    // Intercepteur principal
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 1. Ajouter l'en-tête X-Tenant-Code
        final tenantCode = await storage.getTenantCode();
        if (tenantCode != null) {
          options.headers['X-Tenant-Code'] = tenantCode;
        } else {
          // Valeur par défaut pour les requêtes avant login (ex: login)
          options.headers['X-Tenant-Code'] = 'SN';
        }

        // 2. Ajouter le token JWT si présent
        final token = await storage.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        // Tentative de rafraîchissement du token en cas de 401
        if (error.response?.statusCode == 401) {
          try {
            final newToken = await _refreshToken();
            await storage.saveTokens(newToken, await storage.getRefreshToken() ?? '');
            // Refaire la requête originale
            final opts = error.requestOptions;
            opts.headers['Authorization'] = 'Bearer $newToken';
            final response = await dio.fetch(opts);
            return handler.resolve(response);
          } catch (e) {
            // Refresh échoué : on laisse l'erreur passer
            // (la page de login sera affichée par le listener du cubit)
          }
        }
        handler.next(error);
      },
    ));

    // Logging en debug
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    }
  }

  Future<String> _refreshToken() async {
    final refreshToken = await storage.getRefreshToken();
    if (refreshToken == null) throw Exception('No refresh token');
    final response = await dio.post(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );
    return response.data['access_token'];
  }
}