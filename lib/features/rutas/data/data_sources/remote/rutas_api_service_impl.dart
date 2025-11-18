import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../models/ruta_model.dart';
import 'rutas_api_service.dart';

class RutasApiServiceImpl implements RutasApiService {
  final Dio _dio;

  RutasApiServiceImpl(this._dio);

  @override
  Future<List<RutaModel>> fetchRutas({
    final String? zona,
    final String? agencia,
    final String? asesorId,
  }) async {
    try {
      final response = await _dio.get<dynamic>('/routes');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> jsonList;
        
        if (response.data is String) {
          jsonList = json.decode(response.data as String) as List<dynamic>;
        } else {
          jsonList = response.data as List<dynamic>;
        }
        
        return jsonList
            .map((final e) => RutaModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw ServerException(message: 'Error al obtener rutas');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw AuthException(message: 'No autorizado');
      } else if (e.response?.statusCode == 500) {
        throw ServerException(message: 'Error del servidor');
      }
      throw ServerException(message: 'Error de conexión: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<RutaModel?> fetchRutaById(final String id) async {
    try {
      final response = await _dio.get<dynamic>('/routes/$id');

      if (response.statusCode == 200 && response.data != null) {
        dynamic jsonData;
        
        if (response.data is String) {
          jsonData = json.decode(response.data as String);
        } else {
          jsonData = response.data;
        }
        
        return RutaModel.fromJson(jsonData as Map<String, dynamic>);
      }

      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw AuthException(message: 'No autorizado');
      }
      throw ServerException(message: 'Error al obtener ruta: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<RutaModel> createRuta(final RutaModel ruta) async {
    try {
      final requestData = {
        'fecha': DateTime.now().toIso8601String().split('T')[0],
        'tiporuta_id': ruta.tipoRuta != null && ruta.tipoRuta!.isNotEmpty 
            ? int.tryParse(ruta.tipoRuta!) 
            : null,
        'estado': 'Pendiente',
        'permiso': 'TEMP',
        'user_id': ruta.asesorAsignado != null && ruta.asesorAsignado!.isNotEmpty
            ? int.tryParse(ruta.asesorAsignado!) 
            : null,
        'agencia_id': ruta.agencia != 'Sin agencia' && ruta.agencia.isNotEmpty
            ? int.tryParse(ruta.agencia) 
            : null,
        'numero': ruta.nombre,
        'observacion': ruta.descripcion,
      };

      final response = await _dio.post<dynamic>(
        '/routes',
        data: requestData,
      );

      if (response.statusCode == 204 || response.statusCode == 201 || response.statusCode == 200) {
        // Backend retorna 204 No Content, retornamos ruta sin ID ya que el backend no lo proporciona
        return RutaModel(
          id: '', // ID vacío, no lo usaremos
          nombre: ruta.nombre,
          descripcion: ruta.descripcion,
          zona: ruta.zona,
          agencia: ruta.agencia,
          asesorAsignado: ruta.asesorAsignado,
          tipoRuta: ruta.tipoRuta,
          estado: 'Pendiente',
          totalVisitas: 0,
          visitasCompletadas: 0,
          fechaCreacion: DateTime.now(),
        );
      }

      throw ServerException(message: 'Error al crear ruta');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw AuthException(message: 'No autorizado');
      } else if (e.response?.statusCode == 400) {
        final errorMsg = e.response?.data?.toString() ?? 'Datos inválidos';
        throw ServerException(message: 'Datos inválidos: $errorMsg');
      }
      throw ServerException(message: 'Error de conexión: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<RutaModel> updateRuta(final RutaModel ruta) async {
    try {
      final requestData = {
        'nombre': ruta.nombre,
        'descripcion': ruta.descripcion,
        'zona': ruta.zona,
        'agencia': ruta.agencia,
        'asesor_id': ruta.asesorAsignado,
        'tipo_ruta': ruta.tipoRuta,
        'estado': ruta.estado,
      };

      final response = await _dio.put<dynamic>(
        '/routes/${ruta.id}',
        data: requestData,
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        return ruta.copyWith(fechaActualizacion: DateTime.now());
      }

      throw ServerException(message: 'Error al actualizar ruta');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw AuthException(message: 'No autorizado');
      } else if (e.response?.statusCode == 404) {
        throw ServerException(message: 'Ruta no encontrada');
      }
      throw ServerException(message: 'Error de conexión: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<RutaModel> assignAsesor(final String rutaId, final String asesorId) async {
    try {
      // Primero obtenemos la ruta actual
      final ruta = await fetchRutaById(rutaId);
      if (ruta == null) {
        throw ServerException(message: 'Ruta no encontrada');
      }

      // Actualizamos con el nuevo asesor
      final updatedRuta = ruta.copyWith(
        asesorAsignado: asesorId,
        fechaActualizacion: DateTime.now(),
      );

      return await updateRuta(updatedRuta);
    } catch (e) {
      if (e is ServerException || e is AuthException) {
        rethrow;
      }
      throw ServerException(message: 'Error al asignar asesor: ${e.toString()}');
    }
  }
  
  @override
  Future<void> deleteRutafinal(final String id) async {
    try {
      final response = await _dio.delete<dynamic>('/routes/$id');

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw ServerException(message: 'Error al eliminar ruta');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw AuthException(message: 'No autorizado');
      } else if (e.response?.statusCode == 404) {
        throw ServerException(message: 'Ruta no encontrada');
      }
      throw ServerException(message: 'Error de conexión: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Error inesperado: ${e.toString()}');
    }
  }
}
