import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/routes.dart';

class RutaSociosScreen extends StatelessWidget {
  final String rutaId;

  const RutaSociosScreen({super.key, required this.rutaId});

  @override
  Widget build(final BuildContext context) {
    final socios = List.generate(
      15,
      (final index) => {
        'nombre': 'Socio ${index + 1}',
        'dni': '7000000${index + 1}',
        'visitado': index < 8,
      },
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Socios de la Ruta',
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
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFB03138).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        '8',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB03138),
                        ),
                      ),
                      Text(
                        'Visitados',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: Colors.grey[300],
                  ),
                  Column(
                    children: [
                      const Text(
                        '7',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      Text(
                        'Pendientes',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: socios.length,
                itemBuilder: (final context, final index) {
                  final socio = socios[index];
                  final visitado = socio['visitado'] as bool;
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: visitado
                            ? const Color(0xFFB03138)
                            : Colors.grey,
                        child: Icon(
                          visitado ? Icons.check : Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        socio['nombre'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text('DNI: ${socio['dni']}'),
                      trailing: visitado
                          ? const Chip(
                              label: Text(
                                'Visitado',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              backgroundColor: Color(0xFFB03138),
                            )
                          : const Chip(
                              label: Text(
                                'Pendiente',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              backgroundColor: Colors.orange,
                            ),
                      onTap: () {
                        if (!visitado) {
                          context.push('${Routes.rutaEvidencia}/$rutaId?socioDni=${socio['dni']}');
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
