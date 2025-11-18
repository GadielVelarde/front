import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../models/socios_response_model.dart';
import '../../models/socio_detail_model.dart';
import 'socio_api_service.dart';

class SocioApiServiceImpl implements SocioApiService {
  final Dio _dio;

  SocioApiServiceImpl(this._dio);

  @override
  Future<SociosResponseModel> getSocios() async {
    try {
      final response = await _dio.get<dynamic>('/socios/me');

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> jsonData;
        
        // Manejar respuesta como String o Map
        if (response.data is String) {
          jsonData = json.decode(response.data as String) as Map<String, dynamic>;
        } else {
          jsonData = response.data as Map<String, dynamic>;
        }
        
        return SociosResponseModel.fromJson(jsonData);
      }

      throw ServerException(message: 'Error al obtener socios');
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
  Future<SocioDetailModel> getSocioDetail(final int socioId) async {
    try {
      final response = await _dio.get<dynamic>('/socios/$socioId');

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> jsonData;
        
        // Manejar respuesta como String o Map
        if (response.data is String) {
          jsonData = json.decode(response.data as String) as Map<String, dynamic>;
        } else {
          jsonData = response.data as Map<String, dynamic>;
        }
        
        return SocioDetailModel.fromJson(jsonData);
      }

      throw ServerException(message: 'Error al obtener detalle del socio');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw AuthException(message: 'No autorizado');
      } else if (e.response?.statusCode == 404) {
        throw ServerException(message: 'Socio no encontrado');
      } else if (e.response?.statusCode == 500) {
        throw ServerException(message: 'Error del servidor');
      }
      throw ServerException(message: 'Error de conexión: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Error inesperado: ${e.toString()}');
    }
  }
}
