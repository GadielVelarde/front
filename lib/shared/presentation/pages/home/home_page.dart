import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import 'widgets/home_header.dart';
import 'screens/asesor_home_page.dart';
import 'screens/jefe_home_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (final context, final authState) {
        if (authState is! AuthAuthenticated) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = authState.user;
        final isJefeOrAdmin = user.authRole.isJefeOrAdmin;

        return Container(
          color: Colors.white,
          child: SafeArea(
            child: Column(
              children: [
                HomeHeader(userName: user.name),
                Expanded(
                  child: isJefeOrAdmin ? const JefeHomePage() : const AsesorHomePage(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
