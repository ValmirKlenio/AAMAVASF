import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/horario_disponivel.dart';

class AgendamentoRepository {
  AgendamentoRepository({Dio? dio, FlutterSecureStorage? storage})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'http://10.0.2.2:8000',
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          ),
      _storage = storage ?? const FlutterSecureStorage();

  final Dio _dio;
  final FlutterSecureStorage _storage;

  Future<List<HorarioDisponivel>> listarHorariosDisponiveis(
    int servicoId,
  ) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/servicos/$servicoId/horarios',
      );
      final data = response.data ?? <dynamic>[];

      return data
          .whereType<Map<String, dynamic>>()
          .map(HorarioDisponivel.fromJson)
          .where(
            (horario) =>
                horario.temVagas &&
                horario.datahoraInicio.isAfter(DateTime.now()),
          )
          .toList();
    } on DioException catch (error) {
      throw AgendamentoRepositoryException.fromDio(
        error,
        fallback: 'Nao foi possivel carregar os horarios disponiveis.',
      );
    } on Object {
      throw const AgendamentoRepositoryException(
        'Nao foi possivel carregar os horarios disponiveis.',
      );
    }
  }

  Future<void> agendar(int horarioId) async {
    final token = await _storage.read(key: 'access_token');

    if (token == null || token.isEmpty) {
      throw const AgendamentoRepositoryException(
        'Sua sessao expirou. Faca login novamente.',
      );
    }

    try {
      await _dio.post<Map<String, dynamic>>(
        '/usuarios/agendar',
        data: {'horario_id': horarioId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (error) {
      throw AgendamentoRepositoryException.fromDio(
        error,
        fallback: 'Nao foi possivel confirmar o agendamento.',
      );
    } on Object {
      throw const AgendamentoRepositoryException(
        'Nao foi possivel confirmar o agendamento.',
      );
    }
  }
}

class AgendamentoRepositoryException implements Exception {
  final String message;

  const AgendamentoRepositoryException(this.message);

  factory AgendamentoRepositoryException.fromDio(
    DioException error, {
    required String fallback,
  }) {
    if (error.response?.statusCode == 401) {
      return const AgendamentoRepositoryException(
        'Sua sessao expirou. Faca login novamente.',
      );
    }

    final detail = error.response?.data is Map<String, dynamic>
        ? (error.response?.data as Map<String, dynamic>)['detail']?.toString()
        : null;
    if (detail != null && detail.trim().isNotEmpty) {
      return AgendamentoRepositoryException(detail.trim());
    }

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const AgendamentoRepositoryException(
        'Nao foi possivel conectar ao servidor. Verifique sua conexao e tente novamente.',
      );
    }

    return AgendamentoRepositoryException(fallback);
  }

  @override
  String toString() => message;
}
