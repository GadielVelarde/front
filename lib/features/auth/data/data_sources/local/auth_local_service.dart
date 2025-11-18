import '../../models/user_model.dart';
abstract class AuthLocalService {
  Future<void> saveUser(final UserModel user);
  Future<UserModel?> getUser();
  Future<void> saveToken(final String token);
  Future<String?> getToken();
  Future<void> saveTokenExpiry(final DateTime expiry);
  Future<DateTime?> getTokenExpiry();
  Future<void> setAuthenticated(final bool isAuthenticated);
  Future<bool> isAuthenticated();
  Future<void> clearUserData();
}
