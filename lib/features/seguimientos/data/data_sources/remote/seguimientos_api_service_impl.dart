import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../models/seguimiento_model.dart';
import 'seguimientos_api_service.dart';

class SeguimientosApiServiceImpl implements SeguimientosApiService {
  final Dio _dio;

  SeguimientosApiServiceImpl(this._dio);

  @override
  Future<List<SeguimientoModel>> fetchSeguimientos({
    final String? rutaId,
    final String? asesorId,
    final String? estado,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (rutaId != null) queryParams['ruta_id'] = rutaId;
      if (asesorId != null) queryParams['asesor_id'] = asesorId;
      if (estado != null) queryParams['estado'] = estado;

      final response = await _dio.get<dynamic>(
        '/seguimientos',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> jsonList;
        
        if (response.data is String) {
          jsonList = json.decode(response.data as String) as List<dynamic>;
        } else {
          jsonList = response.data as List<dynamic>;
        }
        
        return jsonList
            .map((final e) => SeguimientoModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw ServerException(message: 'Error al obtener seguimientos');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw AuthException(message: 'No autorizado');
      } else if (e.response?.statusCode == 400) {
        throw ServerException(message: 'Parámetros inválidos');
      }
      throw ServerException(message: 'Error de conexión: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<SeguimientoModel?> fetchSeguimientoById(final String id) async {
    try {
      final response = await _dio.get<dynamic>('/seguimientos/$id');

      if (response.statusCode == 200 && response.data != null) {
        dynamic jsonData;
        
        if (response.data is String) {
          jsonData = json.decode(response.data as String);
        } else {
          jsonData = response.data;
        }
        
        return SeguimientoModel.fromJson(jsonData as Map<String, dynamic>);
      }

      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw AuthException(message: 'No autorizado');
      }
      throw ServerException(message: 'Error al obtener seguimiento: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> createSeguimiento(final SeguimientoModel seguimiento) async {
    try {
      final requestData = {
        'tipo_visita': seguimiento.tipoVisita,
        'ruta_id': seguimiento.rutaId,
        'nombre_ruta': seguimiento.nombreRuta,
        'asesor_id': seguimiento.asesorId,
        'nombre_asesor': seguimiento.nombreAsesor,
        'cliente_id': seguimiento.clienteId,
        'nombre_cliente': seguimiento.nombreCliente,
        'observaciones': seguimiento.observaciones,
        'fecha_programada': seguimiento.fechaProgramada?.toIso8601String(),
        'estado': 'pendiente',
        'requiere_accion': seguimiento.requiereAccion,
        'accion_requerida': seguimiento.accionRequerida,
      };

      final response = await _dio.post<dynamic>(
        '/seguimientos',
        data: requestData,
      );

      if (response.statusCode == 201 && response.data != null) {
        dynamic jsonData;
        
        if (response.data is String) {
          jsonData = json.decode(response.data as String);
        } else {
          jsonData = response.data;
        }
        
        // El backend devuelve un mapa con 'id' y 'message'
        if (jsonData is Map<String, dynamic> && jsonData.containsKey('id')) {
          return {
            'id': jsonData['id'].toString(),
            'message': jsonData['message']?.toString(),
          };
        }
      }

      throw ServerException(message: 'Error al crear seguimiento');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw AuthException(message: 'No autorizado');
      } else if (e.response?.statusCode == 400) {
        throw ServerException(message: 'Datos inválidos');
      }
      throw ServerException(message: 'Error de conexión: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<SeguimientoModel> updateSeguimiento(final SeguimientoModel seguimiento) async {
    try {
      final requestData = {
        'observaciones': seguimiento.observaciones,
        'estado': seguimiento.estado,
        'ubicacion_latitud': seguimiento.ubicacionLatitud,
        'ubicacion_longitud': seguimiento.ubicacionLongitud,
      };

      final response = await _dio.put<dynamic>(
        '/seguimientos/${seguimiento.id}',
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return seguimiento;
      }

      throw ServerException(message: 'Error al actualizar seguimiento');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw AuthException(message: 'No autorizado');
      } else if (e.response?.statusCode == 404) {
        throw ServerException(message: 'Seguimiento no encontrado');
      }
      throw ServerException(message: 'Error de conexión: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteSeguimiento(final String id) async {
    try {
      final response = await _dio.delete<dynamic>('/seguimientos/$id');

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw ServerException(message: 'Error al eliminar seguimiento');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw AuthException(message: 'No autorizado');
      } else if (e.response?.statusCode == 404) {
        throw ServerException(message: 'Seguimiento no encontrado');
      }
      throw ServerException(message: 'Error de conexión: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<SeguimientoModel> completeSeguimiento(
    final String id, {
    final String? observaciones,
    final double? montoRecaudado,
  }) async {
    try {
      final requestData = <String, dynamic>{};
      if (observaciones != null) requestData['observaciones'] = observaciones;
      if (montoRecaudado != null) requestData['monto_recaudado'] = montoRecaudado;

      final response = await _dio.post<dynamic>(
        '/seguimientos/$id/complete',
        data: requestData,
      );

      if (response.statusCode == 200 && response.data != null) {
        dynamic jsonData;
        
        if (response.data is String) {
          jsonData = json.decode(response.data as String);
        } else {
          jsonData = response.data;
        }
        
        return SeguimientoModel.fromJson(jsonData as Map<String, dynamic>);
      }

      throw ServerException(message: 'Error al completar seguimiento');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw AuthException(message: 'No autorizado');
      } else if (e.response?.statusCode == 404) {
        throw ServerException(message: 'Seguimiento no encontrado');
      } else if (e.response?.statusCode == 400) {
        throw ServerException(message: 'Seguimiento ya completado o datos inválidos');
      }
      throw ServerException(message: 'Error de conexión: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Error inesperado: ${e.toString()}');
    }
  }
}
