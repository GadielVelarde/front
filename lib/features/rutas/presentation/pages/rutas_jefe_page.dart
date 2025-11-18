import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/presentation/widgets/date_filter_button.dart';
import '../../../seguimientos/presentation/widgets/seguimientos_filter_sheet.dart';
import '../bloc/rutas_bloc.dart';
import '../bloc/rutas_event.dart';
import '../bloc/rutas_state.dart';
import '../../domain/entities/ruta.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/presentation/widgets/ruta_reporte_card.dart';

class RutasJefePage extends StatefulWidget {
  const RutasJefePage({super.key});

  @override
  State<RutasJefePage> createState() => _RutasJefePageState();
}

class _RutasJefePageState extends State<RutasJefePage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedDate;
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _selectedAsesor;
  String? _selectedArea;

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

    void _showFilters() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (final context) => SeguimientosFilterSheet(
        fromDate: _fromDate,
        toDate: _toDate,
        selectedAsesor: _selectedAsesor,
        selectedArea: _selectedArea,
        onApplyFilters: (final fromDate, final toDate, final asesor, final area) {
          setState(() {
            _fromDate = fromDate;
            _toDate = toDate;
            _selectedAsesor = asesor;
            _selectedArea = area;
          });
        },
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Color(0xFF6C7072),
                    ),
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: const Color(0xFFC7C7C7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (final value) {
                    setState(() {});
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Date Filter and Filter Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Date Filter Button
                  Expanded(
                    child: DateFilterButton(
                      selectedDate: _selectedDate,
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedDate =
                                '${picked.day}/${picked.month}/${picked.year}';
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Filter Button
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB03138),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _showFilters,
                        borderRadius: BorderRadius.circular(8),
                        child: const Icon(
                          Icons.filter_list,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 19),

            // Lista de reportes
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
                        padding: const EdgeInsets.symmetric(horizontal: 23),
                        itemCount: displayRutas.length,
                        itemBuilder: (final context, final index) {
                          final ruta = displayRutas[index];
                          return RutaReporteCard(
                            fecha: '16 de Septiembre',
                            nombreRuta: ruta.nombre,
                            tipoRuta: ruta.tipoRuta ?? 'Ruta Libre',
                            asesor: ruta.asesorAsignado ?? 'Sin asignar',
                            actividad: 'Promocion',
                            resultado: 'Completo',
                            aprobadoPor: 'Jose Rodriguez',
                            socio: 'Luis Millones',
                            estado: 'Aprobada',
                            onVerMas: () {
                              context.push('${Routes.rutaInfo}/${ruta.id}');
                            },
                            onMapa: () {},
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
