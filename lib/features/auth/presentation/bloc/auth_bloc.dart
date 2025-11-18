import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/connectivity_service.dart';
import '../../domain/use_cases/auth_use_cases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final ConnectivityService connectivityService;

  StreamSubscription<bool>? _connectivitySubscription;
  bool _wasConnected;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.checkAuthStatusUseCase,
    required this.connectivityService,
  })  : _wasConnected = connectivityService.isConnected,
        super(const AuthInitial()) {
    on<LoginRequestedEvent>(_onLoginRequested);
    on<LogoutRequestedEvent>(_onLogoutRequested);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<GetCurrentUserEvent>(_onGetCurrentUser);

    _connectivitySubscription = connectivityService.connectionStream.listen(
      (final isConnected) {
        final bool wasPreviouslyDisconnected = !_wasConnected;
        if (isConnected && wasPreviouslyDisconnected) {
          final currentState = state;
          if (currentState is AuthAuthenticated &&
              currentState.user.authRole.isAsesor) {
            add(const CheckAuthStatusEvent());
          }
        }
        _wasConnected = isConnected;
      },
    );
  }
  Future<void> _onLoginRequested(
    final LoginRequestedEvent event,
    final Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await loginUseCase(
      LoginParams(
        usuario: event.usuario,
        password: event.password,
      ),
    );

    result.fold(
      (final failure) => emit(AuthError(
        message: failure.message,
        code: failure.code,
      )),
      (final user) => emit(AuthAuthenticated(user: user)),
    );
  }
  Future<void> _onLogoutRequested(
    final LogoutRequestedEvent event,
    final Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await logoutUseCase(const NoParams());

    result.fold(
      (final failure) => emit(AuthError(
        message: failure.message,
        code: failure.code,
      )),
      (_) => emit(const AuthUnauthenticated(
        message: 'Sesión cerrada correctamente',
      )),
    );
  }
  Future<void> _onCheckAuthStatus(
    final CheckAuthStatusEvent event,
    final Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await checkAuthStatusUseCase(const NoParams());

    await result.fold(
      (final failure) async {
        emit(const AuthUnauthenticated());
      },
      (final isAuthenticated) async {
        if (isAuthenticated) {
          final userResult = await getCurrentUserUseCase(const NoParams());
          userResult.fold(
            (final failure) => emit(const AuthUnauthenticated()),
            (final user) => emit(AuthAuthenticated(user: user)),
          );
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }
  Future<void> _onGetCurrentUser(
    final GetCurrentUserEvent event,
    final Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await getCurrentUserUseCase(const NoParams());

    result.fold(
      (final failure) => emit(AuthError(
        message: failure.message,
        code: failure.code,
      )),
      (final user) => emit(AuthAuthenticated(user: user)),
    );
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
