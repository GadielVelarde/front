import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(final Params params);
}
class NoParams extends Equatable {
  const NoParams();
  
  @override
  List<Object> get props => [];
}
class LoginParams extends Equatable {
  final String usuario;
  final String password;

  const LoginParams({
    required this.usuario,
    required this.password,
  });

  @override
  List<Object> get props => [usuario, password];
}
class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(final LoginParams params) async {
    if (params.usuario.isEmpty || params.password.isEmpty) {
      return const Left(
        ValidationFailure(message: 'Usuario y contraseña son requeridos'),
      );
    }

    return await repository.login(params.usuario, params.password);
  }
}
class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(final NoParams params) async {
    return await repository.logout();
  }
}
class GetCurrentUserUseCase implements UseCase<User, NoParams> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(final NoParams params) async {
    return await repository.getCurrentUser();
  }
}
class CheckAuthStatusUseCase implements UseCase<bool, NoParams> {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(final NoParams params) async {
    return await repository.isAuthenticated();
  }
}
