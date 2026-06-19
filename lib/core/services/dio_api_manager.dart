import 'package:dio/dio.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'app_secure_prefs.dart';

class DioApiManager {
  static final DioApiManager instance = DioApiManager._();

  late final Dio _dio;

  // API Configuration
  static const String apiHost = 'https://carter-unintent-nondissipatedly.ngrok-free.dev';
  static const String apiVersion = '/api/v1';
  static const String baseUrl = '$apiHost$apiVersion';

  DioApiManager._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        contentType: 'application/json',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_AuthInterceptor());
    _dio.interceptors.add(_LoggingInterceptor());
  }

  // ==================== AUTH ENDPOINTS ====================

  /// POST /auth/login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      AppUtility.log('🔐 API: login($email)');
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return response.data;
    } catch (e) {
      AppUtility.log('❌ Login error: $e');
      rethrow;
    }
  }

  /// POST /auth/register
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      AppUtility.log('🔐 API: register($email)');
      final response = await _dio.post(
        '/auth/register',
        data: {'name': name, 'email': email, 'password': password},
      );
      return response.data;
    } catch (e) {
      AppUtility.log('❌ Register error: $e');
      rethrow;
    }
  }

  /// POST /auth/logout
  Future<void> logout() async {
    try {
      AppUtility.log('🔐 API: logout()');
      await _dio.post('/auth/logout');
    } catch (e) {
      AppUtility.log('⚠️ Logout error: $e');
      rethrow;
    }
  }

  /// GET /users/me
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      AppUtility.log('🔐 API: getCurrentUser()');
      final response = await _dio.get('/users/me');
      return response.data;
    } catch (e) {
      AppUtility.log('❌ getCurrentUser error: $e');
      rethrow;
    }
  }

  /// Generic GET request
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response.data;
    } catch (e) {
      AppUtility.log('❌ GET $endpoint error: $e');
      rethrow;
    }
  }

  /// Generic POST request
  Future<dynamic> post(String endpoint, {required dynamic data}) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response.data;
    } catch (e) {
      AppUtility.log('❌ POST $endpoint error: $e');
      rethrow;
    }
  }

  /// Generic PATCH request
  Future<dynamic> patch(String endpoint, {required dynamic data}) async {
    try {
      final response = await _dio.patch(endpoint, data: data);
      return response.data;
    } catch (e) {
      AppUtility.log('❌ PATCH $endpoint error: $e');
      rethrow;
    }
  }

  /// Generic DELETE request
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return response.data;
    } catch (e) {
      AppUtility.log('❌ DELETE $endpoint error: $e');
      rethrow;
    }
  }
}

/// Interceptor for adding Authorization headers
class _AuthInterceptor extends QueuedInterceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      AppUtility.log('🔑 Interceptor: Getting access token for request');
      final token = await AppSecurePrefs.instance.getAccessToken();

      if (token != null && token.isNotEmpty) {
        AppUtility.log('✅ Interceptor: Adding Authorization header (${token.length} chars)');
        options.headers['Authorization'] = 'Bearer $token';
      } else {
        AppUtility.log('⚠️ Interceptor: No token available for Authorization');
      }

      return handler.next(options);
    } catch (e) {
      AppUtility.log('❌ Interceptor error: $e');
      return handler.next(options);
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      AppUtility.log('⚠️ Received 401 Unauthorized - clearing auth');
      await AppSecurePrefs.instance.clearAllAuth();
    }
    return handler.next(err);
  }
}

/// Interceptor for logging requests/responses
class _LoggingInterceptor extends QueuedInterceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    AppUtility.log('📤 ${options.method} ${options.path}');
    if (options.data != null) {
      AppUtility.log('📤 Body: ${options.data}');
    }
    return handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    AppUtility.log('📥 ${response.statusCode} ${response.requestOptions.path}');
    return handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    AppUtility.log('❌ ${err.response?.statusCode} ${err.requestOptions.path}');
    return handler.next(err);
  }
}
