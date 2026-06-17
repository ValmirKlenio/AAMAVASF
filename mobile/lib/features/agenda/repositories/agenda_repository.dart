import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:mobile/core/config/api_config.dart';

import '../models/agendamento.dart';

class AgendaRepository {
  AgendaRepository({Dio? dio, FlutterSecureStorage? storage})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiConfig.baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          ),
      _storage = storage ?? const FlutterSecureStorage();

  final Dio _dio;
  final FlutterSecureStorage _storage;

  Future<List<Agendamento>> listarAgendamentos() async {
    final token = await _storage.read(key: 'access_token');

    if (token == null || token.isEmpty) {
      throw const AgendaRepositoryException(
        'Sua sessão expirou. Faça login novamente.',
      );
    }

    try {
      final response = await _dio.get<List<dynamic>>(
        '/usuarios/agendamentos',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final data = response.data ?? <dynamic>[];

      return data
          .whereType<Map<String, dynamic>>()
          .map(Agendamento.fromJson)
          .toList();
    } on DioException catch (error) {
      throw AgendaRepositoryException.fromDio(error);
    } on Object {
      throw const AgendaRepositoryException(
        'Não foi possível carregar seus agendamentos.',
      );
    }
  }

  Future<void> cancelarAgendamento(int agendamentoId) async {
    final token = await _storage.read(key: 'access_token');

    if (token == null || token.isEmpty) {
      throw const AgendaRepositoryException(
        'Sua sessão expirou. Faça login novamente.',
      );
    }

    try {
      await _dio.delete<Map<String, dynamic>>(
        '/usuarios/cancelar/$agendamentoId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (error) {
      throw AgendaRepositoryException.fromDio(error);
    } on Object {
      throw const AgendaRepositoryException(
        'Não foi possível cancelar este agendamento.',
      );
    }
  }
}

class AgendaRepositoryException implements Exception {
  final String message;

  const AgendaRepositoryException(this.message);

  factory AgendaRepositoryException.fromDio(DioException error) {
    if (error.response?.statusCode == 401) {
      return const AgendaRepositoryException(
        'Sua sessão expirou. Faça login novamente.',
      );
    }

    final detail = error.response?.data is Map<String, dynamic>
        ? (error.response?.data as Map<String, dynamic>)['detail']?.toString()
        : null;
    if (detail != null && detail.trim().isNotEmpty) {
      return AgendaRepositoryException(detail.trim());
    }

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const AgendaRepositoryException(
        'Não foi possível conectar ao servidor. Verifique sua conexão e tente novamente.',
      );
    }

    return const AgendaRepositoryException(
      'Não foi possível carregar seus agendamentos.',
    );
  }

  @override
  String toString() => message;
}
