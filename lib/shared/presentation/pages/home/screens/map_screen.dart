import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapboxScreen extends StatefulWidget {
  const MapboxScreen({super.key});

  @override
  State<MapboxScreen> createState() => _MapboxScreenState();
}

class _MapboxScreenState extends State<MapboxScreen> {
  MapboxMap? mapController;
  geo.Position? currentPosition;
  bool isLoadingLocation = true;
  String? errorMessage;
  bool hasLocationPermission = false;
  
  final List<Map<String, dynamic>> _nearbysocios = [
    // Ejemplo: {'nombre': 'Juan Pérez', 'lat': -12.0464, 'lng': -77.0428, 'dni': '12345678'},
  ];
  final Set<String> _selectedSociosDni = {};

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    await _requestLocationPermission();
    await _getCurrentLocation();
  }

  Future<void> _requestLocationPermission() async {
    try {
      debugPrint('Solicitando permisos de ubicación...');
      
      // Verificar si el servicio de ubicación está habilitado
      final serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Servicio de ubicación desactivado');
        return;
      }

      // Verificar permisos actuales
      var permission = await geo.Geolocator.checkPermission();
      debugPrint('Permiso actual: $permission');
      
      // Si el permiso está denegado, solicitarlo
      if (permission == geo.LocationPermission.denied) {
        debugPrint('Solicitando permisos...');
        permission = await geo.Geolocator.requestPermission();
        debugPrint('Permiso después de solicitar: $permission');
      }
      
      // Si el permiso fue otorgado, actualizar el estado
      if (permission == geo.LocationPermission.whileInUse || 
          permission == geo.LocationPermission.always) {
        if (mounted) {
          setState(() {
            hasLocationPermission = true;
          });
        }
        debugPrint('Permisos de ubicación otorgados');
      }
    } catch (e) {
      debugPrint('Error al solicitar permisos: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    if (!mounted) return;
    
    try {
      setState(() {
        isLoadingLocation = true;
        errorMessage = null;
      });

      debugPrint('Verificando servicio de ubicación...');
      
      // Verificar si el servicio de ubicación está habilitado
      final serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      debugPrint('Servicio de ubicación habilitado: $serviceEnabled');
      
      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            isLoadingLocation = false;
            errorMessage = 'Los servicios de ubicación están desactivados';
          });
        }
        return;
      }

      // Verificar permisos
      debugPrint('Verificando permisos...');
      var permission = await geo.Geolocator.checkPermission();
      debugPrint('Permiso actual: $permission');
      
      if (permission == geo.LocationPermission.denied) {
        debugPrint('Solicitando permisos...');
        permission = await geo.Geolocator.requestPermission();
        debugPrint('Permiso después de solicitar: $permission');
        
        if (permission == geo.LocationPermission.denied) {
          if (mounted) {
            setState(() {
              isLoadingLocation = false;
              errorMessage = 'Permisos de ubicación denegados';
            });
          }
          return;
        }
      }

      if (permission == geo.LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            isLoadingLocation = false;
            errorMessage = 'Permisos de ubicación denegados permanentemente.\nPor favor, actívalos en la configuración del dispositivo.';
          });
        }
        return;
      }

      if (mounted) {
        setState(() {
          hasLocationPermission = true;
        });
      }

      debugPrint('Obteniendo posición actual...');
      
      // Obtener ubicación con timeout
      final geo.Position position = await geo.Geolocator.getCurrentPosition(
        locationSettings: const geo.LocationSettings(
          accuracy: geo.LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Tiempo de espera agotado al obtener ubicación');
        },
      );
      
      debugPrint('Ubicación obtenida: ${position.latitude}, ${position.longitude}');
      
      if (mounted) {
        setState(() {
          currentPosition = position;
          isLoadingLocation = false;
        });
        
        // Actualizar cámara y agregar marcador si el mapa ya está creado
        if (mapController != null) {
          _centerMapOnPosition(position);
          await _addUserLocationMarker();
        }
      }
    } catch (e, stackTrace) {
      debugPrint('Error al obtener ubicación: $e');
      debugPrint('Stack trace: $stackTrace');
      
      if (mounted) {
        setState(() {
          isLoadingLocation = false;
          errorMessage = 'Error al obtener ubicación.\nIntenta de nuevo más tarde.';
        });
      }
    }
  }

  void _centerMapOnPosition(final geo.Position position) {
    try {
      debugPrint('Centrando mapa en: ${position.latitude}, ${position.longitude}');
      mapController?.setCamera(
        CameraOptions(
          center: Point(
            coordinates: Position(
              position.longitude,
              position.latitude,
            ),
          ),
          zoom: 14.0,
        ),
      );
    } catch (e) {
      debugPrint('Error al centrar el mapa: $e');
    }
  }

  Future<void> _addUserLocationMarker() async {
    if (mapController == null || currentPosition == null) return;
    
    try {
      debugPrint('Agregando marcador de ubicación del usuario en: ${currentPosition!.latitude}, ${currentPosition!.longitude}');
      
      // Crear círculo azul para la ubicación del usuario (más visible que un icono)
      final circleAnnotationManager = await mapController!.annotations.createCircleAnnotationManager();
      
      // Agregar círculo interior azul (ubicación exacta)
      await circleAnnotationManager.create(
        CircleAnnotationOptions(
          geometry: Point(
            coordinates: Position(
              currentPosition!.longitude,
              currentPosition!.latitude,
            ),
          ),
          circleRadius: 8.0,
          circleColor: const Color(0xFF2196F3).toARGB32(), // Azul brillante
          circleStrokeWidth: 3.0,
          circleStrokeColor: Colors.white.toARGB32(),
        ),
      );
      
      // Agregar círculo exterior transparente (área de precisión)
      await circleAnnotationManager.create(
        CircleAnnotationOptions(
          geometry: Point(
            coordinates: Position(
              currentPosition!.longitude,
              currentPosition!.latitude,
            ),
          ),
          circleRadius: 30.0,
          circleColor: const Color(0x402196F3).toARGB32(), // Azul semi-transparente
          circleStrokeWidth: 1.0,
          circleStrokeColor: const Color(0xFF2196F3).toARGB32(),
        ),
      );
      
      debugPrint('Marcador del usuario agregado exitosamente');
    } catch (e, stackTrace) {
      debugPrint('Error al agregar marcador del usuario: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  // ignore: unused_element
  Future<void> _addNearbySociosMarkers(final PointAnnotationManager manager) async {
    // Para cada socio cercano, agregar un marcador
    for (final socio in _nearbysocios) {
      await manager.create(
        PointAnnotationOptions(
          geometry: Point(
            coordinates: Position(
              socio['lng'] as double,
              socio['lat'] as double,
            ),
          ),
          iconSize: 1.2,
          iconColor: Colors.red.toARGB32(),
          iconImage: 'marker',
        ),
      );
    }
  }

  void _toggleSocioSelection(final String dni) {
    setState(() {
      if (_selectedSociosDni.contains(dni)) {
        _selectedSociosDni.remove(dni);
      } else {
        _selectedSociosDni.add(dni);
      }
    });
  }

  void _createRouteWithSelectedSocios() {
    if (_selectedSociosDni.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona al menos un socio para crear una ruta'),
        ),
      );
      return;
    }
    
    debugPrint('Creando ruta con socios: $_selectedSociosDni');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Crear ruta con ${_selectedSociosDni.length} socio(s) seleccionado(s)'),
      ),
    );
  }

  void _onMapCreated(final MapboxMap controller) async {
    debugPrint('Mapa creado');
    mapController = controller;
    
    // Habilitar la capa de ubicación nativa de Mapbox
    try {
      await controller.location.updateSettings(
        LocationComponentSettings(
          enabled: true,
          pulsingEnabled: true,
          pulsingColor: const Color(0xFF2196F3).toARGB32(),
          pulsingMaxRadius: 40.0,
        ),
      );
      debugPrint('Capa de ubicación de Mapbox habilitada');
    } catch (e) {
      debugPrint('Error al habilitar capa de ubicación: $e');
    }
    
    // Si ya tenemos la ubicación, centrar el mapa y agregar marcador
    if (currentPosition != null) {
      _centerMapOnPosition(currentPosition!);
      // Agregar marcador del usuario
      await _addUserLocationMarker();
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Ubicaciones', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if (_selectedSociosDni.isNotEmpty)
            IconButton(
              icon: Badge(
                label: Text('${_selectedSociosDni.length}'),
                child: const Icon(Icons.route),
              ),
              onPressed: _createRouteWithSelectedSocios,
              tooltip: 'Crear ruta',
            ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Mapa principal
            isLoadingLocation
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Caragando mapa...'),
                    ],
                  ),
                )
              : errorMessage != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_off,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () async {
                              await _requestLocationPermission();
                              await _getCurrentLocation();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB03138),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    ),
                  )
                : currentPosition != null && hasLocationPermission
                  ? MapWidget(
                      onMapCreated: _onMapCreated,
                      cameraOptions: CameraOptions(
                        center: Point(
                          coordinates: Position(
                            currentPosition!.longitude,
                            currentPosition!.latitude,
                          ),
                        ),
                        zoom: 14.0,
                      ),
                      styleUri: MapboxStyles.STANDARD,
                    )
                  : const Center(
                      child: Text('No se pudo cargar el mapa correctamente'),
                    ),
            
            // if (_nearbysocios.isNotEmpty)
            //   Positioned(
            //     bottom: 0,
            //     left: 0,
            //     right: 0,
            //     child: _buildNearbySociosPanel(),
            //   ),
          ],
        ),
      ),
      floatingActionButton: currentPosition != null
        ? FloatingActionButton(
            onPressed: () {
              if (currentPosition != null) {
                _centerMapOnPosition(currentPosition!);
              }
            },
            backgroundColor: const Color(0xFFB03138),
            child: const Icon(Icons.my_location, color: Colors.white),
          )
        : null,
    );
  }

  // ignore: unused_element
  Widget _buildNearbySociosPanel() {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Socios cercanos (${_nearbysocios.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_selectedSociosDni.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedSociosDni.clear();
                      });
                    },
                    child: const Text('Limpiar selección'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _nearbysocios.length,
              itemBuilder: (final context, final index) {
                final socio = _nearbysocios[index];
                final dni = socio['dni'] as String;
                final isSelected = _selectedSociosDni.contains(dni);
                
                return CheckboxListTile(
                  value: isSelected,
                  onChanged: (_) => _toggleSocioSelection(dni),
                  title: Text(socio['nombre'] as String),
                  subtitle: Text('DNI: $dni'),
                  secondary: const Icon(Icons.person_pin_circle),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
