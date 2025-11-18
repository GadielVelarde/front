import 'package:flutter/material.dart';

/// Widget reutilizable para mostrar un item de seguimiento
/// Usado para mostrar información resumida de un seguimiento en listas
class SeguimientoListItem extends StatelessWidget {
  final String socioName;
  final String fecha;
  final String resultado;
  final String? avatarUrl;
  final VoidCallback? onTap;

  const SeguimientoListItem({
    super.key,
    required this.socioName,
    required this.fecha,
    required this.resultado,
    this.avatarUrl,
    this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  color: const Color(0xFFC7C7C7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: avatarUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (final context, final error, final tackTrace) =>
                              const Icon(Icons.person, size: 40, color: Colors.white),
                        ),
                      )
                    : const Icon(Icons.person, size: 40, color: Colors.white),
              ),
              const SizedBox(width: 16),
              // Información del seguimiento
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      socioName,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF191C1F),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fecha,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Color(0xFF858587),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      resultado,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Color(0xFF858587),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFFABABAD),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
