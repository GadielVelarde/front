import 'package:flutter/material.dart';

/// Widget reutilizable para mostrar un item de socio en listas
/// Usado en pantallas de seguimiento para mostrar información básica del socio
class SocioListItem extends StatelessWidget {
  final String name;
  final String phone;
  final String area;
  final String? avatarUrl;
  final VoidCallback? onTap;

  const SocioListItem({
    super.key,
    required this.name,
    required this.phone,
    required this.area,
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
                          errorBuilder: (final context, final error,final stackTrace) =>
                              const Icon(Icons.person, size: 40, color: Colors.white),
                        ),
                      )
                    : const Icon(Icons.person, size: 40, color: Colors.white),
              ),
              const SizedBox(width: 16),
              // Información del socio
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF191C1F),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      phone,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Color(0xFF858587),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      area,
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
