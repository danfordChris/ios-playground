import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'app_secure_prefs.dart';

class AppApiManager extends BaseAPIManager {
  static final AppApiManager instance = AppApiManager._();

  // API Configuration
  static const String apiHost = 'https://carter-unintent-nondissipatedly.ngrok-free.dev';
  static const String apiVersion = '/api/v1';
  static const String baseUrl = '$apiHost$apiVersion';

  AppApiManager._()
      : super(
          baseUrl + '/',
          StarterAPIManagement(
            authorization: _authHeadersFuture,
          ),
        );

  /// Provide headers for each request
  static Future<Map<String, String>?> get _authHeadersFuture => _getAuthHeaders();

  /// Get authorization headers with token
  /// This is called for EACH request to ensure fresh token
  static Future<Map<String, String>?> _getAuthHeaders() async {
    try {
      final token = await AppSecurePrefs.instance.getAccessToken();
      if (token != null && token.isNotEmpty) {
        AppUtility.log('✓ Including authorization token in request');
        return {'Authorization': 'Bearer $token'};
      } else {
        AppUtility.log('⚠ No token available for authorization');
        return null;
      }
    } catch (e) {
      AppUtility.log('✗ Error getting auth headers: $e');
      return null;
    }
  }

  @override
  Future<StarterAPIManagement>? get refreshOnUnauthorized => null;

  // ==================== AUTH ENDPOINTS ====================

  /// Login: POST /auth/login
  /// Returns: { "data": { "token": "...", "refreshToken": "..." } }
  Future<APIResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    AppUtility.log('🔐 API: login($email)');
    return apiAuthPost<Map<String, dynamic>>(
      'auth/login',
      body: {'email': email, 'password': password},
    );
  }

  /// Register: POST /auth/register
  Future<APIResponse<Map<String, dynamic>>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    AppUtility.log('🔐 API: register($email)');
    return apiAuthPost<Map<String, dynamic>>(
      'auth/register',
      body: {'name': name, 'email': email, 'password': password},
    );
  }

  /// Logout: POST /auth/logout (requires token)
  Future<APIResponse<void>> logout() async {
    AppUtility.log('🔐 API: logout()');
    return apiAuthPost<void>('auth/logout');
  }

  /// Get current user: GET /users/me (requires token)
  Future<APIResponse<Map<String, dynamic>>> getCurrentUser() async {
    AppUtility.log('🔐 API: getCurrentUser()');
    return apiAuthGet<Map<String, dynamic>>('users/me');
  }

  // ==================== UTILITY METHODS ====================

  /// Manually handle 401 response (unauthorized)
  /// Clears token and logs user out
  // static Future<void> handle401() async {
  //   AppUtility.log('Received 401 Unauthorized - clearing auth');
  //   await AppSecurePrefs.instance.clearAllAuth();
  // }
}
