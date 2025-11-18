import 'package:equatable/equatable.dart';
import 'auth_role.dart';
class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final AuthRole authRole; // jefe, asesor, admin
  final String agencia;
  final String? zona;
  final String? token;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.authRole,
    required this.agencia,
    this.zona,
    this.token,
  });

  @override
  List<Object?> get props => [id, email, name, authRole, agencia, zona, token];

  @override
  bool get stringify => true;
}
