import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/rutas_bloc.dart';
import '../bloc/rutas_event.dart';
import '../bloc/rutas_state.dart';
import '../../domain/entities/ruta.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/presentation/widgets/ruta_list_item.dart';

class RutasAsesorPage extends StatefulWidget {
  const RutasAsesorPage({super.key});

  @override
  State<RutasAsesorPage> createState() => _RutasAsesorPageState();
}

class _RutasAsesorPageState extends State<RutasAsesorPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<RutasBloc>().add(const GetRutasEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar rutas',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onChanged: (final query) {
                  setState(() {});
                },
              ),
            ),

            const SizedBox(height: 16),

            // Header "Tus Rutas"
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tus Rutas',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // "Mas recientes" con icono de filtro
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mas recientes',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list, size: 24),
                    onPressed: () {
                      //Implementar filtros
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Lista de rutas
            Expanded(
              child: BlocBuilder<RutasBloc, RutasState>(
                builder: (final context, final state) {
                  if (state is RutasLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is RutasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            'Error al cargar rutas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.red[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: const TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<RutasBloc>().add(const GetRutasEvent());
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reintentar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is RutasLoaded) {
                    final rutas = state.rutas;
                    if (rutas.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.map_outlined, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No hay rutas disponibles',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Las rutas aparecerán aquí',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }

                    final displayRutas = _searchController.text.isEmpty
                        ? rutas
                        : _searchRutas(rutas, _searchController.text);

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<RutasBloc>().add(const GetRutasEvent());
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        itemCount: displayRutas.length,
                        itemBuilder: (final context, final index) {
                          final ruta = displayRutas[index];
                          return RutaListItem(
                            title: ruta.nombre,
                            tipo: ruta.tipoRuta ?? '',
                            fechaInfo: _formatFechaInfo(ruta.fechaCreacion),
                            onTap: () {
                              context.push('${Routes.rutaInfo}/${ruta.id}');
                            },
                          );
                        },
                      ),
                    );
                  }
                  return const Center(child: Text('Cargando rutas...'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatFechaInfo(final DateTime? fecha) {
    if (fecha == null) return 'Sin fecha';
    return 'Inicio - Fin';
  }

  List<Ruta> _searchRutas(final List<Ruta> rutas, final String query) {
    final lowerQuery = query.toLowerCase();
    return rutas.where((final ruta) {
      return ruta.nombre.toLowerCase().contains(lowerQuery) ||
          ruta.descripcion.toLowerCase().contains(lowerQuery) ||
          ruta.zona.toLowerCase().contains(lowerQuery) ||
          (ruta.tipoRuta?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }
}
