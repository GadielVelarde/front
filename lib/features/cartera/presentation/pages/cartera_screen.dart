import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/socio_bloc.dart';
import '../bloc/socio_event.dart';
import '../bloc/socio_state.dart';
import '../widgets/socio_list_item.dart';
import '../widgets/socio_summary_card.dart';
import '../../domain/entities/socio.dart';

class CarteraScreen extends StatefulWidget {
  const CarteraScreen({super.key});

  @override
  State<CarteraScreen> createState() => _CarteraScreenState();
}

class _CarteraScreenState extends State<CarteraScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Socio> _filteredSocios = [];
  List<Socio> _allSocios = [];

  @override
  void initState() {
    super.initState();
    context.read<SocioBloc>().add(const GetSociosEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterSocios(final String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSocios = _allSocios;
      } else {
        _filteredSocios = _allSocios.where((final socio) {
          final nombreCompleto = socio.nombreCompleto.toLowerCase();
          final dni = socio.dni.toLowerCase();
          final telefono = socio.numeroTelefono.toLowerCase();
          final searchLower = query.toLowerCase();
          
          return nombreCompleto.contains(searchLower) ||
                 dni.contains(searchLower) ||
                 telefono.contains(searchLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar por nombre, DNI o teléfono',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  _filterSocios('');
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      onChanged: _filterSocios,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.person_add, color: Colors.white,),
                      onPressed: () {
                        context.push(Routes.registerSocio);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SocioSummaryCard(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Socios',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.push(Routes.allSocios);
                    },
                    child: const Text(
                      'Ver todos',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<SocioBloc, SocioState>(
                builder: (final context, final state) {
                  if (state is SocioLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SociosLoaded) {
                    if (_allSocios.isEmpty || _allSocios.length != state.socios.length) {
                      _allSocios = state.socios;
                      _filteredSocios = _searchController.text.isEmpty 
                          ? _allSocios 
                          : _filteredSocios;
                    }
                    
                    final sociosToDisplay = _searchController.text.isEmpty 
                        ? _allSocios 
                        : _filteredSocios;
                    final displayedSocios = sociosToDisplay.take(15).toList();
                    
                    if (displayedSocios.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No se encontraron socios',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<SocioBloc>().add(const GetSociosEvent());
                      },
                      child: ListView.builder(
                        itemCount: displayedSocios.length,
                        itemBuilder: (final context, final index) {
                          final socio = displayedSocios[index];
                          return SocioListItem(socio: socio);
                        },
                      ),
                    );
                  } else if (state is SocioError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const Center(child: Text('No hay socios disponibles'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
