import 'package:dio/dio.dart';

import 'package:mobile/core/config/api_config.dart';

import '../models/servico.dart';

class ServicosRepository {
  ServicosRepository({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiConfig.baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  final Dio _dio;

  Future<List<Servico>> listarServicos() async {
    try {
      final response = await _dio.get<List<dynamic>>('/servicos');
      final data = response.data ?? <dynamic>[];

      return data
          .whereType<Map<String, dynamic>>()
          .map(Servico.fromJson)
          .toList();
    } on DioException catch (error) {
      throw ServicosRepositoryException.fromDio(error);
    } on Object {
      throw const ServicosRepositoryException(
        'Não foi possível carregar os serviços no momento.',
      );
    }
  }
}

class ServicosRepositoryException implements Exception {
  final String message;

  const ServicosRepositoryException(this.message);

  factory ServicosRepositoryException.fromDio(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return const ServicosRepositoryException(
        'Não foi possível conectar ao servidor. Verifique sua conexão e tente novamente.',
      );
    }

    return const ServicosRepositoryException(
      'Não foi possível carregar os serviços no momento.',
    );
  }

  @override
  String toString() => message;
}
