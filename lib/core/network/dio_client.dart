import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  static const String baseUrlDev = 'http://10.0.2.2:8000'; // émulateur Android
  // static const String baseUrlDev = 'http://localhost:8000'; // simulateur iOS
  static const String baseUrlProd = 'https://api.djembebank.com';

  final Dio dio;
  final FlutterSecureStorage storage;

  DioClient(this.storage)
      : dio = Dio(BaseOptions(
          baseUrl: baseUrlDev,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {'Content-Type': 'application/json'},
        )) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Récupérer tenant_code depuis le storage
        final tenantCode = await storage.read(key: 'tenant_code');
        if (tenantCode != null) {
          options.headers['X-Tenant-Code'] = tenantCode;
        } else {
          // Avant login, valeur par défaut
          options.headers['X-Tenant-Code'] = 'SN';
        }

        // Ajouter le token si disponible
        final token = await storage.read(key: 'access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // TODO: implémenter le refresh token
        }
        handler.next(error);
      },
    ));

    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }
}