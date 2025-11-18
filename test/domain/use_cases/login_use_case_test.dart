import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:seguimiento_norandino/core/errors/failures.dart';
import 'package:seguimiento_norandino/features/auth/data/models/user_model.dart';
import 'package:seguimiento_norandino/features/auth/domain/entities/auth_role.dart';
import 'package:seguimiento_norandino/features/auth/domain/entities/user.dart';
import 'package:seguimiento_norandino/features/auth/domain/repositories/auth_repository.dart';
import 'package:seguimiento_norandino/features/auth/domain/use_cases/auth_use_cases.dart';
@GenerateMocks([AuthRepository])
import 'login_use_case_test.mocks.dart';

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository as AuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  final tUser = const UserModel(
    id: '1',
    email: tEmail,
    name: 'Test User',
    authRole: AuthRole.asesor,
    agencia: 'Test Agency',
  );

  group('LoginUseCase', () {
    test('should validate that usuario is not empty', () async {
      const params = LoginParams(usuario: '', password: tPassword);
      final result = await useCase(params);
      expect(result, isA<Left<Failure, User>>());
      result.fold(
        (final failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, contains('requeridos'));
        },
        (_) => fail('Should return Left with ValidationFailure'),
      );
      verifyNever(mockRepository.login(any, any));
    });

    test('should validate that password is not empty', () async {
      const params = LoginParams(usuario: tEmail, password: '');
      final result = await useCase(params);
      expect(result, isA<Left<Failure, User>>());
      result.fold(
        (final failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, contains('requeridos'));
        },
        (_) => fail('Should return Left with ValidationFailure'),
      );
      verifyNever(mockRepository.login(any, any));
    });

    test('should call repository.login when validation passes', () async {
      const params = LoginParams(usuario: tEmail, password: tPassword);
      when(mockRepository.login(any, any))
          .thenAnswer((_) async => Right(tUser));
      await useCase(params);
      verify(mockRepository.login(tEmail, tPassword));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return UserModel when login is successful', () async {
      const params = LoginParams(usuario: tEmail, password: tPassword);
      when(mockRepository.login(any, any))
          .thenAnswer((_) async => Right(tUser));
      final result = await useCase(params);
      expect(result, isA<Right<Failure, User>>());
      result.fold(
        (_) => fail('Should return Right with UserModel'),
        (final user) {
          expect(user, equals(tUser));
          expect(user.email, equals(tEmail));
        },
      );
    });

    test('should return AuthFailure when credentials are invalid', () async {
      const params = LoginParams(usuario: tEmail, password: 'wrong_password');
      const failure = AuthFailure(
        message: 'Usuario o contraseña incorrectos',
        code: 'AUTH_INVALID_CREDENTIALS',
      );
      when(mockRepository.login(any, any))
          .thenAnswer((_) async => const Left(failure));
      final result = await useCase(params);
      expect(result, isA<Left<Failure, User>>());
      result.fold(
        (final fail) {
          expect(fail, isA<AuthFailure>());
          expect(fail.message, contains('incorrectos'));
        },
        (_) => fail('Should return Left with AuthFailure'),
      );
    });

    test('should return NetworkFailure when there is no connection', () async {
      const params = LoginParams(usuario: tEmail, password: tPassword);
      const failure = NetworkFailure(
        message: 'No hay conexión a internet',
      );
      when(mockRepository.login(any, any))
          .thenAnswer((_) async => const Left(failure));
      final result = await useCase(params);
      expect(result, isA<Left<Failure, User>>());
      result.fold(
        (final fail) {
          expect(fail, isA<NetworkFailure>());
          expect(fail.message, contains('conexión'));
        },
        (_) => fail('Should return Left with NetworkFailure'),
      );
    });
  });
}

