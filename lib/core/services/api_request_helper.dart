import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'app_api_manager.dart';
import 'app_secure_prefs.dart';

/// API Request Helper
/// Handles token injection, refresh, and error handling for all API requests
class ApiRequestHelper {
  /// Make an authenticated GET request with automatic token handling
  static Future<APIResponse<T>> authenticatedGet<T>(
    String endpoint, {
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final token = await _getValidToken();
      if (token == null) {
        throw Exception('No valid authentication token');
      }

      AppUtility.log('📤 GET $endpoint with token (${token.length} chars)');
      final response = await AppApiManager.instance.apiAuthGet<T>(endpoint);

      if (response.statusCode == 401) {
        AppUtility.log('⚠ Received 401, clearing auth');
        await AppSecurePrefs.instance.clearAllAuth();
      }

      return response;
    } catch (e) {
      AppUtility.log('❌ GET request failed: $e');
      rethrow;
    }
  }

  /// Make an authenticated POST request with automatic token handling
  static Future<APIResponse<T>> authenticatedPost<T>(
    String endpoint, {
    required dynamic body,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final token = await _getValidToken();
      if (token == null) {
        throw Exception('No valid authentication token');
      }

      AppUtility.log('📤 POST $endpoint with token (${token.length} chars)');
      final response = await AppApiManager.instance.apiAuthPost<T>(
        endpoint,
        body: body,
      );

      if (response.statusCode == 401) {
        AppUtility.log('⚠ Received 401, clearing auth');
        await AppSecurePrefs.instance.clearAllAuth();
      }

      return response;
    } catch (e) {
      AppUtility.log('❌ POST request failed: $e');
      rethrow;
    }
  }

  /// Make an authenticated PATCH request with automatic token handling
  static Future<APIResponse<T>> authenticatedPatch<T>(
    String endpoint, {
    required dynamic body,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final token = await _getValidToken();
      if (token == null) {
        throw Exception('No valid authentication token');
      }

      AppUtility.log('📤 PATCH $endpoint with token (${token.length} chars)');
      final response = await AppApiManager.instance.apiAuthPatch<T>(
        endpoint,
        body: body,
      );

      if (response.statusCode == 401) {
        AppUtility.log('⚠ Received 401, clearing auth');
        await AppSecurePrefs.instance.clearAllAuth();
      }

      return response;
    } catch (e) {
      AppUtility.log('❌ PATCH request failed: $e');
      rethrow;
    }
  }

  /// Make an authenticated DELETE request with automatic token handling
  static Future<APIResponse<T>> authenticatedDelete<T>(
    String endpoint, {
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final token = await _getValidToken();
      if (token == null) {
        throw Exception('No valid authentication token');
      }

      AppUtility.log('📤 DELETE $endpoint with token (${token.length} chars)');
      final response = await AppApiManager.instance.apiAuthDelete<T>(endpoint);

      if (response.statusCode == 401) {
        AppUtility.log('⚠ Received 401, clearing auth');
        await AppSecurePrefs.instance.clearAllAuth();
      }

      return response;
    } catch (e) {
      AppUtility.log('❌ DELETE request failed: $e');
      rethrow;
    }
  }

  /// Get valid access token, refresh if needed
  static Future<String?> _getValidToken() async {
    try {
      AppUtility.log('🔑 Retrieving access token from secure storage...');
      final token = await AppSecurePrefs.instance.getAccessToken();

      if (token != null && token.isNotEmpty) {
        AppUtility.log('✓ Access token available (${token.length} chars)');
        return token;
      }

      AppUtility.log('⚠ No access token found - token is NULL or EMPTY');
      return null;
    } catch (e) {
      AppUtility.log('❌ Error getting token: $e');
      return null;
    }
  }
}
