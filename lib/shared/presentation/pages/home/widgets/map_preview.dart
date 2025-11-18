import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapPreviewWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double width;
  final double height;
  final double zoom;

  const MapPreviewWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    this.width = 200,
    this.height = 150,
    this.zoom = 12.0,
  });

  @override
  State<MapPreviewWidget> createState() => _MapPreviewWidgetState();
}

class _MapPreviewWidgetState extends State<MapPreviewWidget> {
  MapboxMap? mapboxMap;

  void _onMapCreated(final MapboxMap map) {
    mapboxMap = map;
    
    // Deshabilitar todos los gestos
    map.gestures.updateSettings(
      GesturesSettings(
        rotateEnabled: false,
        scrollEnabled: false,
        pitchEnabled: false,
        pinchPanEnabled: false,
        doubleTapToZoomInEnabled: false,
        doubleTouchToZoomOutEnabled: false,
        quickZoomEnabled: false,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          const BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: MapWidget(
          onMapCreated: _onMapCreated,
          cameraOptions: CameraOptions(
            center: Point(
              coordinates: Position(widget.longitude, widget.latitude),
            ),
            zoom: widget.zoom,
          ),
          styleUri: MapboxStyles.STANDARD,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
