import '../../models/user_model.dart';
import '../../../domain/entities/auth_role.dart';

class AuthResponse {
  final UserModel user;
  final String token;
  final DateTime tokenExpiry;

  AuthResponse({
    required this.user,
    required this.token,
    required this.tokenExpiry,
  });

  factory AuthResponse.fromJson(final Map<String, dynamic> json) {
    // Nuevo formato: {"token": "...", "expiresIn": 1233.15, "usuario": {...}}
    final token = json['token'] as String;
    final expiresIn = json['expiresIn'] as num;
    final usuarioData = json['usuario'] as Map<String, dynamic>;
    
    // Calcular la fecha de expiración
    final tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn.toInt()));
    
    // Extraer datos del usuario
    final user = UserModel(
      id: usuarioData['id'].toString(),
      email: usuarioData['email'] as String? ?? '',
      name: (usuarioData['cnomusu'] as String? ?? '').trim(),
      authRole: AuthRole.fromString(usuarioData['rol'] as String? ?? 'ASESOR'),
      agencia: usuarioData['agencia'] as String? ?? '',
      zona: usuarioData['area'] as String?,
      token: token,
    );
    
    return AuthResponse(
      user: user,
      token: token,
      tokenExpiry: tokenExpiry,
    );
  }
}
abstract class AuthApiService {
  Future<AuthResponse?> authenticateUser(final String usuario, final String password);
  Future<UserModel?> fetchUserData(final String token);
  Future<void> invalidateToken(final String token);
  Future<String> refreshAuthToken(final String token);
}
