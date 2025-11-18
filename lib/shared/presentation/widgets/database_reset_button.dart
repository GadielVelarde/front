import 'package:flutter/material.dart';
import '../../../core/database/database_helper.dart';

/// Widget temporal para resetear la base de datos
/// Útil durante desarrollo cuando cambias el esquema de la BD
class DatabaseResetButton extends StatelessWidget {
  const DatabaseResetButton({super.key});

  @override
  Widget build(final BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        // Mostrar diálogo de confirmación
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (final context) => AlertDialog(
            title: const Text('⚠️ Resetear Base de Datos'),
            content: const Text(
              'Esto eliminará TODA la base de datos local y se creará una nueva.\n\n'
              '¿Estás seguro?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Sí, Resetear'),
              ),
            ],
          ),
        );

        if (confirmed == true && context.mounted) {
          try {
            // Mostrar loading
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (final context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );

            // Eliminar la base de datos
            final dbHelper = DatabaseHelper();
            await dbHelper.deleteDatabase();

            // Crear nueva base de datos con el esquema actualizado
            await dbHelper.database;

            if (context.mounted) {
              // Cerrar loading
              Navigator.pop(context);

              // Mostrar éxito
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Base de datos reseteada exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              // Cerrar loading si está abierto
              Navigator.pop(context);

              // Mostrar error
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('❌ Error: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        }
      },
      icon: const Icon(Icons.delete_forever),
      label: const Text('Resetear BD'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
    );
  }
}
