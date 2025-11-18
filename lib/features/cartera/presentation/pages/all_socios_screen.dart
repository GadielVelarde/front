import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/socio_bloc.dart';
import '../bloc/socio_state.dart';
import '../widgets/socio_list_item.dart';
import '../../domain/entities/socio.dart';

class AllSociosScreen extends StatefulWidget {
  const AllSociosScreen({super.key});

  @override
  State<AllSociosScreen> createState() => _AllSociosScreenState();
}

class _AllSociosScreenState extends State<AllSociosScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Socio> _filteredSocios = [];
  List<Socio> _allSocios = [];

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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text(
          'Todos los Socios',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
                      icon: const Icon(Icons.person_add, color: Colors.white),
                      onPressed: () {
                        context.push(Routes.registerSocio);
                      },
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
                    
                    if (sociosToDisplay.isEmpty) {
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
                    
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${sociosToDisplay.length} ${sociosToDisplay.length == 1 ? "socio encontrado" : "socios encontrados"}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: sociosToDisplay.length,
                            itemBuilder: (final context, final index) {
                              final socio = sociosToDisplay[index];
                              return SocioListItem(socio: socio);
                            },
                          ),
                        ),
                      ],
                    );
                  } else if (state is SocioError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${state.message}',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
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
