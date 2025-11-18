import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/routes.dart';
import '../../../../shared/presentation/widgets/info_row.dart';
import '../../../auth/domain/entities/auth_role.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/ruta_approval_status.dart';

class RutaInfoScreen extends StatelessWidget {
  final String rutaId;
  final RutaApprovalStatus approvalStatus; // Estado de aprobación

  const RutaInfoScreen({
    super.key, 
    required this.rutaId,
    this.approvalStatus = RutaApprovalStatus.pendiente, // Por defecto, pendiente
  });

  @override
  Widget build(final BuildContext context) {
    // Obtener el rol del usuario
    final authBloc = context.read<AuthBloc>();
    final authState = authBloc.state;
    AuthRole? userRole;
    if (authState is AuthAuthenticated) {
      userRole = authState.user.authRole;
    }

    // Determinar si es jefe o admin (no pueden editar, solo ver)
    final isJefeOrAdmin = userRole?.isJefeOrAdmin ?? false;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Información de la Ruta',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(
                    thickness: 1,
                    indent: 70,
                    endIndent: 70,
                  ),
                  const SizedBox(height: 24),
                  const InfoRow(
                    label: 'Nombre de la Ruta',
                    value: 'Ruta Centro - Zona A',
                    icon: Icons.map,
                  ),
                  InfoRow(
                    label: 'Estado de Aprobación',
                    value: approvalStatus.displayName,
                    icon: approvalStatus.icon,
                    valueColor: approvalStatus.color,
                  ),
                  const InfoRow(
                    label: 'Estado de la ruta',
                    value: 'Activa',
                    icon: Icons.check_circle,
                  ),
                  const InfoRow(
                    label: 'Tipo de Ruta',
                    value: 'Cobro',
                    icon: Icons.category,
                  ),
                  const InfoRow(
                    label: 'Jefe Asociado',
                    value: 'Carlos Ramirez',
                    icon: Icons.person_outline,
                  ),
                  const InfoRow(
                    label: 'Fecha de la Ruta',
                    value: '01/11/2025',
                    icon: Icons.calendar_today,
                  ),
                  InfoRow(
                    label: 'Número de Socios',
                    value: '15',
                    icon: Icons.people,
                    onTap: () {
                      context.push('${Routes.rutaSocios}/$rutaId');
                    },
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 16.0,
              ),
              child: Row(
                children: [
                  // Solo mostrar botón de editar si NO es jefe/admin y la ruta NO está aprobada
                  if (!isJefeOrAdmin && approvalStatus != RutaApprovalStatus.aprobado) ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.push('${Routes.crearRuta}?rutaId=$rutaId');
                        },
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Editar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.push('${Routes.rutaEvidencia}/$rutaId');
                      },
                      icon: const Icon(Icons.camera_alt, size: 18),
                      label: const Text('Evidencia'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB03138),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
