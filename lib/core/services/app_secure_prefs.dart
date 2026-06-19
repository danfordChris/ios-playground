import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'app_preferences.dart';

/// Auth-specific preferences wrapper
/// Handles secure token storage and user data with in-memory caching
class AppSecurePrefs {
  static final AppSecurePrefs instance = AppSecurePrefs._();
  AppSecurePrefs._();

  // Keys for storage
  static const String accessTokenKey = 'auth_access_token';
  static const String refreshTokenKey = 'auth_refresh_token';
  static const String userDataKey = 'auth_user_data';

  final _secureStorage = AppSecureStorage();
  final _regularStorage = AppRegularStorage();

  // In-memory token cache (critical for immediate requests after login)
  static String? _cachedAccessToken;
  static String? _cachedRefreshToken;

  // Access Token (JWT) - secure storage + memory cache
  Future<String?> getAccessToken() async {
    try {
      // First check memory cache (instant access for fresh tokens)
      if (_cachedAccessToken != null && _cachedAccessToken!.isNotEmpty) {
        AppUtility.log('📖 Token from MEMORY CACHE (${_cachedAccessToken!.length} chars)');
        return _cachedAccessToken;
      }

      AppUtility.log('📖 Fetching access token from secure storage...');
      final token = await _secureStorage.fetch<String>(accessTokenKey);
      AppUtility.log('📖 Token fetch result: ${token != null ? "EXISTS (${token.length} chars)" : "NULL"}');

      // Cache for future immediate access
      if (token != null && token.isNotEmpty) {
        _cachedAccessToken = token;
      }

      return token;
    } catch (e) {
      AppUtility.log('❌ Error fetching token: $e');
      return null;
    }
  }

  Future<void> saveAccessToken(String token) async {
    try {
      AppUtility.log('💾 Step 1: Saving access token (${token.length} chars) to memory cache');
      _cachedAccessToken = token; // Cache immediately for instant access

      AppUtility.log('💾 Step 2: Writing to secure storage (async)...');
      _secureStorage.save<String>(accessTokenKey, token);

      AppUtility.log('⏳ Step 3: Waiting 200ms for storage persistence...');
      await Future.delayed(const Duration(milliseconds: 200));

      AppUtility.log('🔍 Step 4: Verifying token was written to storage...');
      final saved = await _secureStorage.fetch<String>(accessTokenKey);

      if (saved != null && saved == token) {
        AppUtility.log('✅ Step 5: Token persisted successfully (${saved.length} chars match)');
      } else {
        AppUtility.log('⚠️ Step 5: Storage persistence incomplete, using memory cache');
      }
    } catch (e) {
      AppUtility.log('❌ Error saving token: $e');
      rethrow;
    }
  }

  // Refresh Token - secure storage + memory cache
  Future<String?> getRefreshToken() async {
    try {
      if (_cachedRefreshToken != null && _cachedRefreshToken!.isNotEmpty) {
        return _cachedRefreshToken;
      }

      final token = await _secureStorage.fetch<String>(refreshTokenKey);
      if (token != null && token.isNotEmpty) {
        _cachedRefreshToken = token;
      }

      return token;
    } catch (e) {
      AppUtility.log('❌ Error fetching refresh token: $e');
      return null;
    }
  }

  Future<void> saveRefreshToken(String token) async {
    try {
      _cachedRefreshToken = token; // Cache immediately
      _secureStorage.save<String>(refreshTokenKey, token);
      await Future.delayed(const Duration(milliseconds: 200));
    } catch (e) {
      AppUtility.log('❌ Error saving refresh token: $e');
    }
  }

  // User Data - regular storage
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    _regularStorage.save<Map<String, dynamic>>(userDataKey, userData);
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<Map<String, dynamic>?> getUserData() async =>
      await _regularStorage.fetch<Map<String, dynamic>>(userDataKey);

  // Clear all auth data
  Future<void> clearAllAuth() async {
    AppUtility.log('Clearing all auth data');
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
    _secureStorage.save<String?>(accessTokenKey, null);
    _secureStorage.save<String?>(refreshTokenKey, null);
    _regularStorage.save<Map<String, dynamic>?>(userDataKey, null);
    await Future.delayed(const Duration(milliseconds: 100));
  }

  // Check if authenticated
  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
