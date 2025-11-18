import 'package:equatable/equatable.dart';
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}
class LoginRequestedEvent extends AuthEvent {
  final String usuario;
  final String password;

  const LoginRequestedEvent({
    required this.usuario,
    required this.password,
  });

  @override
  List<Object?> get props => [usuario, password];
}
class LogoutRequestedEvent extends AuthEvent {
  const LogoutRequestedEvent();
}
class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}
class GetCurrentUserEvent extends AuthEvent {
  const GetCurrentUserEvent();
}
class RefreshTokenEvent extends AuthEvent {
  const RefreshTokenEvent();
}
