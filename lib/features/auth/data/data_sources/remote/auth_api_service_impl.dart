import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../domain/entities/auth_role.dart';
import '../../models/user_model.dart';
import 'auth_api_service.dart';

class AuthApiServiceImpl implements AuthApiService {
  final Dio _dio;

  AuthApiServiceImpl(this._dio);
  
  @override
  Future<AuthResponse?> authenticateUser(final String usuario, final String password) async {
    
    
    try {

      final AuthResponse? authResponse = _authenticateWithHardcodedCredentials(usuario, password);

      if (authResponse != null) {
        return authResponse;
      }

      final response = await _dio.post<dynamic>('/auth/login', data: {
        'username': usuario,
        'password': password,
      });

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> jsonData;
        
        if (response.data is String) {
          jsonData = json.decode(response.data as String) as Map<String, dynamic>;
        } else {
          jsonData = response.data as Map<String, dynamic>;
        }
        
        return AuthResponse.fromJson(jsonData);
      }

      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 403 || e.response?.statusCode == 401) {
        throw AuthException.invalidCredentials();
      }
      else if(e.response?.statusCode == 500){
        throw AuthException.serverError();
      }
    }
    return null;
  }

  AuthResponse? _authenticateWithHardcodedCredentials(final String usuario, final String password) {
    if (usuario == 'jefe@empresa.com' && password == 'password123') {
      return AuthResponse(
        token: 'fake-jwt-token-jefe',
        tokenExpiry: DateTime.now().add(const Duration(hours: 1)),
        user: UserModel(
          id: '1',
          email: usuario,
          name: 'Usuario Jefe',
          authRole: AuthRole.jefe,
          zona: 'Zona 1',
          agencia: 'Agencia 1',
        ),
      );
    }

    if (usuario == 'asesor@empresa.com' && password == 'password123') {
      return AuthResponse(
        token: 'fake-jwt-token-asesor',
        tokenExpiry: DateTime.now().add(const Duration(hours: 1)),
        user: UserModel(
          id: '2',
          email: usuario,
          name: 'Usuario Asesor',
          zona: 'Zona 1',
          agencia: 'Agencia 1',
          authRole: AuthRole.asesor,
        ),
      );
    }

    if (usuario == 'admin@empresa.com' && password == 'password123') {
      return AuthResponse(
        token: 'fake-jwt-token-admin',
        tokenExpiry: DateTime.now().add(const Duration(hours: 1)),
        user: UserModel(
          id: '3',
          email: usuario,
          name: 'Usuario Administrador',
          zona: 'Zona 1',
          agencia: 'Agencia 1',
          authRole: AuthRole.admin,
        ),
      );
    }
    return null;
  }

  @override
  Future<UserModel?> fetchUserData(final String token) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (token.contains('jefe')) {
      return const UserModel(
        id: '1',
        email: 'jefe@empresa.com',
        name: 'Usuario Jefe',
        zona: 'Zona 1',
        agencia: 'Agencia 1',
        authRole: AuthRole.jefe,
      );
    } else if (token.contains('asesor')) {
      return const UserModel(
        id: '2',
        email: 'asesor@empresa.com',
        name: 'Usuario Asesor',
        zona: 'Zona 1',
        agencia: 'Agencia 1',
        authRole: AuthRole.asesor,
      );
    } else if (token.contains('admin')) {
      return const UserModel(
        id: '3',
        email: 'admin@empresa.com',
        name: 'Usuario Administrador',
        zona: 'Zona 1',
        agencia: 'Agencia 1',
        authRole: AuthRole.admin,
      );
    }

    return null;
  }

  @override
  Future<void> invalidateToken(final String token) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<String> refreshAuthToken(final String token) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return '$token-refreshed-${DateTime.now().millisecondsSinceEpoch}';
  }
}
