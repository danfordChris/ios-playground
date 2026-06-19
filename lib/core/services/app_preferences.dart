import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';

/// Secure storage for sensitive auth data (tokens)
class AppSecureStorage extends BaseSecurePreferences {
  static final AppSecureStorage _instance = AppSecureStorage._();
  AppSecureStorage._();

  factory AppSecureStorage() {
    return _instance;
  }
}

/// Regular storage for non-sensitive app data
class AppRegularStorage extends BasePreferences {
  static final AppRegularStorage _instance = AppRegularStorage._();
  AppRegularStorage._();

  factory AppRegularStorage() {
    return _instance;
  }
}
