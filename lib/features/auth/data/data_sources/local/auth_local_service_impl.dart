import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/user_model.dart';
import 'auth_local_service.dart';
class AuthLocalServiceImpl implements AuthLocalService {
  static const String _userKey = 'user_data';
  static const String _authKey = 'is_authenticated';
  static const String _tokenKey = 'auth_token';
  static const String _tokenExpiryKey = 'auth_token_expiry';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  @override
  Future<void> saveUser(final UserModel user) async {
    try {
      final userJson = user.toJson();
      await _secureStorage.write(key: _userKey, value: jsonEncode(userJson));
    } catch (e) {
      throw Exception('Error al guardar usuario: $e');
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final userString = await _secureStorage.read(key: _userKey);
      
      if (userString == null || userString.isEmpty) {
        return null;
      }
      final Map<String, dynamic> userMap = jsonDecode(userString) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveToken(final String token) async {
    try {
      await _secureStorage.write(key: _tokenKey, value: token);
    } catch (e) {
      throw Exception('Error al guardar token: $e');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: _tokenKey);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveTokenExpiry(final DateTime expiry) async {
    try {
      await _secureStorage.write(
        key: _tokenExpiryKey,
        value: expiry.toIso8601String(),
      );
    } catch (e) {
      throw Exception('Error al guardar expiracion del token: $e');
    }
  }

  @override
  Future<DateTime?> getTokenExpiry() async {
    try {
      final expiryString = await _secureStorage.read(key: _tokenExpiryKey);
      if (expiryString == null || expiryString.isEmpty) {
        return null;
      }
      return DateTime.tryParse(expiryString);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setAuthenticated(final bool isAuthenticated) async {
    try {
      await _secureStorage.write(key: _authKey, value: isAuthenticated.toString());
    } catch (e) {
      throw Exception('Error al guardar estado de autenticación: $e');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final authString = await _secureStorage.read(key: _authKey);
      return authString == 'true';
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> clearUserData() async {
    try {
      await _secureStorage.delete(key: _userKey);
      await _secureStorage.delete(key: _authKey);
      await _secureStorage.delete(key: _tokenKey);
      await _secureStorage.delete(key: _tokenExpiryKey);
    } catch (e) {
      throw Exception('Error al limpiar datos de usuario: $e');
    }
  }
}
