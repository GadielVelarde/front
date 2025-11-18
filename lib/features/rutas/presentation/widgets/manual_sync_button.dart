import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/rutas_bloc.dart';
import '../bloc/rutas_state.dart';
import '../bloc/rutas_event.dart';

/// Botón para sincronización manual
/// Muestra un spinner cuando está sincronizando y se desactiva cuando no hay conexión
class ManualSyncButton extends StatelessWidget {
  const ManualSyncButton({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<RutasBloc, RutasState>(
      builder: (final context, final state) {
        if (state is! RutasLoaded) return const SizedBox.shrink();

        final isSyncing = state.syncStatus == 'syncing';
        final isOffline = !state.isConnected;
        final hasUnsyncedItems = state.unsyncedCount > 0;

        return IconButton(
          icon: isSyncing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : Icon(
                  Icons.sync,
                  color: isOffline
                      ? Colors.grey
                      : hasUnsyncedItems
                          ? Colors.orange
                          : null,
                ),
          tooltip: isOffline
              ? 'Sin conexión'
              : isSyncing
                  ? 'Sincronizando...'
                  : hasUnsyncedItems
                      ? 'Sincronizar ${state.unsyncedCount} cambio${state.unsyncedCount > 1 ? 's' : ''}'
                      : 'Sincronizar ahora',
          onPressed: isOffline || isSyncing
              ? null
              : () {
                  // Disparar evento de sincronización manual
                  context.read<RutasBloc>().add(const ManualSyncEvent());

                  // Mostrar snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            hasUnsyncedItems
                                ? 'Sincronizando ${state.unsyncedCount} cambio${state.unsyncedCount > 1 ? 's' : ''}...'
                                : 'Sincronizando cambios...',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.blue.shade700,
                    ),
                  );
                },
        );
      },
    );
  }
}
