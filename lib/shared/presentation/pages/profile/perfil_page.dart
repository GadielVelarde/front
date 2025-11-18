import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_event.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/theme.dart';
class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: AppColors.background,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (final context, final state) {
          if (state is AuthUnauthenticated) {
            context.go(Routes.login);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (final context, final authState) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'Página de Perfil',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 24),
                    if (authState is AuthLoading)
                      const CircularProgressIndicator()
                    else if (authState is AuthAuthenticated) ...[
                      _buildUserInfo(authState),
                      const SizedBox(height: 32),
                      _buildLogoutButton(context, authState),
                    ] else
                      const Text('No hay sesión activa'),
                    if (authState is AuthError) ...[
                      const SizedBox(height: 16),
                      Text(
                        authState.message,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserInfo(final AuthAuthenticated state) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow('Nombre:', state.user.name),
            const Divider(),
            _buildInfoRow('Email:', state.user.email),
            const Divider(),
            _buildInfoRow('Rol:', state.user.authRole.name.toUpperCase()),
            const Divider(),
            _buildInfoRow('Agencia:', state.user.agencia),
            if (state.user.zona != null) ...[
              const Divider(),
              _buildInfoRow('Zona:', state.user.zona!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(final String label, final String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(final BuildContext context, final AuthAuthenticated state) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () {
          context.read<AuthBloc>().add(const LogoutRequestedEvent());
        },
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text(
          'Cerrar Sesión',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
