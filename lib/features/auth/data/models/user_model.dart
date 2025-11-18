import '../../domain/entities/auth_role.dart';
import '../../domain/entities/user.dart';
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.authRole,
    required super.agencia,
    super.zona,
    super.token,
  });

  factory UserModel.fromJson(final Map<String, dynamic> json) {
    // Soportar múltiples formatos de respuesta del backend
    final roleStr = json['auth_role'] as String? ?? json['role'] as String? ?? json['rol'] as String? ?? 'asesor';
    
    return UserModel(
      id: (json['id'] ?? json['codusu'] ?? '').toString(),
      email: json['email'] as String? ?? '',
      name: (json['name'] as String? ?? json['nombre'] as String? ?? json['cnomusu'] as String? ?? '').trim(),
      authRole: AuthRole.fromString(roleStr),
      agencia: json['agencia'] as String? ?? '',
      zona: json['zona'] as String? ?? json['area'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'auth_role': authRole.toJson(),
      'agencia': agencia,
      'zona': zona,
      'token': token,
    };
  }
  factory UserModel.fromEntity(final User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      authRole: user.authRole,
      agencia: user.agencia,
      zona: user.zona,
      token: user.token,
    );
  }
}
