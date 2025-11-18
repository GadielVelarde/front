import 'package:flutter/material.dart';

class RutaListItem extends StatelessWidget {
  final String title;
  final String tipo;
  final String fechaInfo;
  final String? imagePath;
  final VoidCallback? onTap;

  const RutaListItem({
    super.key,
    required this.title,
    required this.tipo,
    required this.fechaInfo,
    this.imagePath,
    this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail/Imagen placeholder
              Container(
                width: 78,
                height: 77,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (final context, final error, final stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.map_outlined,
                                size: 32,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.map_outlined,
                          size: 32,
                          color: Colors.grey,
                        ),
                      ),
              ),
              
              const SizedBox(width: 15),
              
              // Información de la ruta
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        height: 1.29,
                        letterSpacing: -0.41,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 5),
                    
                    // Tipo
                    Text(
                      tipo,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        height: 1,
                      ),
                    ),
                    
                    const SizedBox(height: 5),
                    
                    // Fecha información
                    Text(
                      fechaInfo,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Botón de flecha para navegar
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Colors.grey,
                ),
                onPressed: onTap,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Divider
          Container(
            height: 1,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }
}
