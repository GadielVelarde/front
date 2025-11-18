import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../../features/auth/domain/entities/auth_role.dart';
import 'rutas_asesor_page.dart';
import 'rutas_jefe_page.dart';

class RutasPage extends StatelessWidget {
  const RutasPage({super.key});

  @override
  Widget build(final BuildContext context) {
    // Obtener el rol del usuario
    final authBloc = context.read<AuthBloc>();
    final authState = authBloc.state;
    
    if (authState is AuthAuthenticated) {
      final userRole = authState.user.authRole;
      
      // Retornar la página correspondiente según el rol
      if (userRole == AuthRole.jefe) {
        return const RutasJefePage();
      } else {
        return const RutasAsesorPage();
      }
    }
    
    return const RutasAsesorPage();
  }
}
