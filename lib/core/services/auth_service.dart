import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import '../model/user_session.dart';
import 'dio_api_manager.dart';
import 'app_secure_prefs.dart';

class AuthService {
  static final AuthService instance = AuthService._();
  AuthService._();

  /// Login with email and password
  /// Saves tokens and returns UserSession on success
  Future<UserSession> login({
    required String email,
    required String password,
  }) async {
    try {
      AppUtility.log('🔐 Starting login for $email');

      // Call login API with DIO
      final response = await DioApiManager.instance.login(
        email: email,
        password: password,
      );

      AppUtility.log('📡 Login response: $response');

      // Extract tokens from response
      final data = response['data'] as Map<String, dynamic>?;

      if (data == null) {
        throw Exception('Invalid login response structure');
      }

      final accessToken = data['token'] as String?;
      final refreshToken = data['refreshToken'] as String?;

      AppUtility.log('🔑 Extracted - accessToken: ${accessToken != null ? "${accessToken.length} chars" : "NULL"}, refreshToken: ${refreshToken != null ? "${refreshToken.length} chars" : "NULL"}');

      if (accessToken == null) {
        throw Exception('No access token in response');
      }

      // Save tokens to secure storage
      AppUtility.log('💾 Saving accessToken to secure storage...');
      await AppSecurePrefs.instance.saveAccessToken(accessToken);

      AppUtility.log('✅ AccessToken saved, verifying...');
      final savedToken = await AppSecurePrefs.instance.getAccessToken();
      AppUtility.log('🔍 Token verification: ${savedToken != null ? "EXISTS (${savedToken.length} chars)" : "MISSING"}');

      if (refreshToken != null) {
        await AppSecurePrefs.instance.saveRefreshToken(refreshToken);
      }

      AppUtility.log('Tokens saved, fetching user profile');

      // Fetch user profile - token will be auto-injected by DIO interceptor
      final userResponse = await DioApiManager.instance.getCurrentUser();

      // Create user session from response
      final userData = userResponse['data'] as Map<String, dynamic>?;

      if (userData == null) {
        // Token saved but profile fetch failed - still consider it partial success
        AppUtility.log('⚠️ Profile fetch failed, but token is valid');
        final user = UserSession(
          id: '',
          name: 'User',
          email: email,
          role: 'User',
        );
        await AppSecurePrefs.instance.saveUserData(user.toMap());
        return user;
      }

      final user = UserSession(
        id: userData['id'] as String? ?? '',
        name: userData['name'] as String? ?? 'User',
        email: userData['email'] as String? ?? email,
        role: userData['role'] as String? ?? 'User',
      );

      // Save user data
      await AppSecurePrefs.instance.saveUserData(user.toMap());

      AppUtility.log('✅ Login successful for ${user.email}');
      return user;
    } catch (e) {
      AppUtility.log('❌ Login error: $e');
      // Clear any partial auth data on error
      await AppSecurePrefs.instance.clearAllAuth();
      rethrow;
    }
  }

  /// Register a new user and auto-login
  Future<UserSession> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      AppUtility.log('🔐 Starting registration for $email');

      final response = await DioApiManager.instance.register(
        name: name,
        email: email,
        password: password,
      );

      AppUtility.log('✅ Registration successful, attempting auto-login');
      return login(email: email, password: password);
    } catch (e) {
      AppUtility.log('❌ Registration error: $e');
      rethrow;
    }
  }

  /// Logout the current user
  /// Clears all tokens and session data
  Future<void> logout() async {
    try {
      AppUtility.log('🔐 Starting logout');
      // Notify server of logout
      await DioApiManager.instance.logout();
    } catch (e) {
      AppUtility.log('⚠️ Server logout failed: $e (will clear local auth)');
      // Continue with local cleanup even if server call fails
    }

    // Clear all local authentication data
    await AppSecurePrefs.instance.clearAllAuth();
    AppUtility.log('✅ Local authentication cleared');
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return AppSecurePrefs.instance.isAuthenticated();
  }

  /// Get stored access token
  Future<String?> getAccessToken() async {
    return AppSecurePrefs.instance.getAccessToken();
  }

  /// Get stored refresh token
  Future<String?> getRefreshToken() async {
    return AppSecurePrefs.instance.getRefreshToken();
  }

  /// Get stored user data
  Future<Map<String, dynamic>?> getUserData() async {
    return AppSecurePrefs.instance.getUserData();
  }
}
