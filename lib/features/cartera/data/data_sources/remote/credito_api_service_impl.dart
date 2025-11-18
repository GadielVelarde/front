import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../models/credito_completo_model.dart';
import 'credito_api_service.dart';

class CreditoApiServiceImpl implements CreditoApiService {
  final Dio _dio;

  CreditoApiServiceImpl(this._dio);

  @override
  Future<List<CreditoCompletoModel>> getCreditosBySocio(final int socioId) async {
    try {
      final response = await _dio.get<dynamic>('/socios/$socioId/creditos');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> jsonList;
        
        // Manejar respuesta como String o List
        if (response.data is String) {
          jsonList = json.decode(response.data as String) as List<dynamic>;
        } else {
          jsonList = response.data as List<dynamic>;
        }
        
        return jsonList
            .map((final e) => CreditoCompletoModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw ServerException(message: 'Error al obtener créditos');
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

  @override
  Future<CreditoCompletoModel> getCreditoDetail(final int creditoId) async {
    try {
      final response = await _dio.get<dynamic>('/creditos/$creditoId');

      if (response.statusCode == 200 && response.data != null) {
        dynamic jsonData;
        
        if (response.data is String) {
          jsonData = json.decode(response.data as String);
        } else {
          jsonData = response.data;
        }
        
        return CreditoCompletoModel.fromJson(jsonData as Map<String, dynamic>);
      }

      throw ServerException(message: 'Error al obtener detalle del crédito');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw AuthException(message: 'No autorizado');
      } else if (e.response?.statusCode == 404) {
        throw ServerException(message: 'Crédito no encontrado');
      } else if (e.response?.statusCode == 500) {
        throw ServerException(message: 'Error del servidor');
      }
      throw ServerException(message: 'Error de conexión: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Error inesperado: ${e.toString()}');
    }
  }
}
