import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../../../config/app_config.dart';
import 'suggestion_item.dart';

class DireccionSearchBottomSheet extends StatefulWidget {
  final void Function(String)? onDireccionSelected;
  final String? selectedDireccion;

  const DireccionSearchBottomSheet({
    super.key,
    this.onDireccionSelected,
    this.selectedDireccion,
  });

  @override
  State<DireccionSearchBottomSheet> createState() =>
      _DireccionSearchBottomSheetState();
}

class _DireccionSearchBottomSheetState
    extends State<DireccionSearchBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final Dio _dio = Dio();
  List<MapboxSuggestion> _suggestions = [];
  bool _isLoading = false;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    if (widget.selectedDireccion != null) {
      _searchController.text = widget.selectedDireccion!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _dio.close();
    super.dispose();
  }

  Future<void> _searchAddress(final String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
        _error = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/${Uri.encodeComponent(query)}.json'
        '?access_token=${AppConfig.mapboxAccessToken}'
        '&country=PE'
        '&language=es' 
        '&limit=5'; 

      final response = await _dio.get<Map<String, dynamic>>(url);

      if (response.statusCode == 200) {
        final data = response.data;
        final features = (data?['features'] as List?) ?? [];

        setState(() {
          _suggestions = features
              .map((final feature) => MapboxSuggestion.fromJson(feature as Map<String, dynamic>))
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Error al buscar direcciones';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error de conexión: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 20.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Buscar Dirección',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Escribe una dirección...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchAddress('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFFF2F4F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (final value) {
                setState(() {}); // Para actualizar el botón clear
                _searchAddress(value);
              },
            ),
            const SizedBox(height: 15),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              )
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (_suggestions.isEmpty && _searchController.text.isNotEmpty)
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('No se encontraron resultados'),
              )
            else if (_suggestions.isNotEmpty)
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _suggestions.length,
                  itemBuilder: (final context, final index) {
                    final suggestion = _suggestions[index];
                    final isSelected =
                        widget.selectedDireccion == suggestion.placeName;
                    return SuggestionItem(widget: widget, context: context, suggestion: suggestion, isSelected: isSelected);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MapboxSuggestion {
  final String text;
  final String? addressNumber; // Número de dirección
  final String placeName;
  final String fullAddress;
  final String? district; // Distrito
  final String? province; // Provincia
  final String? region; // Región/Departamento
  final String? postcode; // Código postal
  final List<double>? coordinates;

  MapboxSuggestion({
    required this.text,
    this.addressNumber,
    required this.placeName,
    required this.fullAddress,
    this.district,
    this.province,
    this.region,
    this.postcode,
    this.coordinates,
  });

  String get displayAddress {
    final parts = <String>[];
    
    // Dirección principal con número
    if (addressNumber != null && addressNumber!.isNotEmpty) {
      parts.add('$text $addressNumber');
    } else {
      parts.add(text);
    }
    
    // Distrito
    if (district != null && district!.isNotEmpty) {
      parts.add(district!);
    }
    
    // Provincia
    if (province != null && province!.isNotEmpty) {
      parts.add(province!);
    }
    
    // Región
    if (region != null && region!.isNotEmpty) {
      parts.add(region!);
    }
    
    return parts.join(', ');
  }
  
  // Getter para mostrar la dirección con número en la UI
  String get streetWithNumber {
    if (addressNumber != null && addressNumber!.isNotEmpty) {
      return '$text $addressNumber';
    }
    return text;
  }

  String get secondaryInfo {
    final parts = <String>[];
    
    if (province != null && province!.isNotEmpty) {
      parts.add(province!);
    }
    
    if (region != null && region!.isNotEmpty) {
      parts.add(region!);
    }
    
    if (postcode != null && postcode!.isNotEmpty) {
      parts.add(postcode!);
    }
    
    return parts.isNotEmpty ? parts.join(' • ') : '';
  }

  factory MapboxSuggestion.fromJson(final Map<String, dynamic> json) {
    String? district;
    String? province;
    String? region;
    String? postcode;

    // Extraer información estructurada del contexto
    if (json['context'] != null && (json['context'] as List).isNotEmpty) {
      final contextList = json['context'] as List;
      
      for (var item in contextList) {
        final id = item['id'] as String? ?? '';
        final text = item['text'] as String? ?? '';
        
        if (id.startsWith('district.') || id.startsWith('locality.')) {
          district = text;
        } else if (id.startsWith('place.')) {
          province = text;
        } else if (id.startsWith('region.')) {
          region = text;
        } else if (id.startsWith('postcode.')) {
          postcode = text;
        }
      }
    }

    // Extraer coordenadas [lng, lat]
    List<double>? coordinates;
    if (json['geometry'] != null && json['geometry']['coordinates'] != null) {
      final coords = json['geometry']['coordinates'] as List;
      coordinates = coords.map<double>((final c) => (c as num).toDouble()).toList();
    }

    final String placeName = (json['place_name'] as String?) ?? '';
    final String text = (json['text'] as String?) ?? '';
    final String? addressNumber = json['address'] as String?;

    return MapboxSuggestion(
      text: text,
      addressNumber: addressNumber,
      placeName: placeName,
      fullAddress: placeName,
      district: district,
      province: province,
      region: region,
      postcode: postcode,
      coordinates: coordinates,
    );
  }
}
