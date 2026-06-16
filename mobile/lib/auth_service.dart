import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'models/usuario.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8000',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<void> clearToken() async {
    await _storage.delete(key: 'access_token');
  }

  Future<Options> _authOptions() async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      throw const AuthException(
        'Sua sessão expirou. Faça login novamente.',
        requiresLogin: true,
      );
    }

    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  Future<void> login(String email, String senha) async {
    try {
      final response = await _dio.post(
        '/token',
        data: {'username': email, 'password': senha},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final data = response.data;
      final token = data is Map ? data['access_token']?.toString() : null;

      if (token == null || token.isEmpty) {
        throw const AuthException(
          'Não foi possível iniciar a sessão. Tente novamente.',
        );
      }

      await _storage.write(key: 'access_token', value: token);
    } on DioException catch (e) {
      throw _handleLoginError(e);
    } on AuthException {
      rethrow;
    }
  }

  Future<bool> registrar({
    required String nome,
    required String email,
    required String senha,
    required String cpf,
    required String telefone,
    required String nomeDependente,
    required String dataNascDep,
  }) async {
    try {
      final response = await _dio.post(
        '/registrar',
        data: {
          'nome': nome,
          'email': email,
          'senha': senha,
          'cpf': cpf,
          'telefone': telefone,
          'nome_dependente': nomeDependente,
          'data_nasc_dep': dataNascDep,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      final data = response.data;
      final token = data is Map ? data['access_token']?.toString() : null;

      if (token == null || token.isEmpty) {
        return false;
      }

      await _storage.write(key: 'access_token', value: token);
      return true;
    } on DioException catch (e) {
      throw _handleRegisterError(e);
    }
  }

  Future<Usuario> buscarUsuarioLogado() async {
    try {
      final response = await _dio.get(
        '/usuarios/me',
        options: await _authOptions(),
      );

      return Usuario.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final error = _handleSessionError(e);

      if (error.requiresLogin) {
        await clearToken();
      }

      throw error;
    }
  }

  Future<void> alterarSenha({
    required String senhaAtual,
    required String novaSenha,
  }) async {
    try {
      await _dio.post(
        '/usuarios/alterar-senha',
        data: {'senha_atual': senhaAtual, 'nova_senha': novaSenha},
        options: await _authOptions(),
      );
    } on DioException catch (e) {
      throw _handleSessionError(e);
    }
  }

  Future<List<dynamic>> visualizarAgendamentos() async {
    try {
      final response = await _dio.get(
        '/usuarios/agendamentos',
        options: await _authOptions(),
      );
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw _handleSessionError(e);
    }
  }

  Future<Map<String, dynamic>> agendar({required int horarioId}) async {
    try {
      final response = await _dio.post(
        '/usuarios/agendar',
        data: {'horario_id': horarioId},
        options: await _authOptions(),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleSessionError(e);
    }
  }

  Future<void> cancelarAgendamento(int agendamentoId) async {
    try {
      await _dio.delete(
        '/usuarios/cancelar/$agendamentoId',
        options: await _authOptions(),
      );
    } on DioException catch (e) {
      throw _handleSessionError(e);
    }
  }

  AuthException _handleLoginError(DioException e) {
    if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
      return AuthException(
        e.response?.statusCode == 401
            ? 'Sua sessão expirou. Faça login novamente.'
            : 'E-mail ou senha inválidos.',
        requiresLogin: e.response?.statusCode == 401,
      );
    }

    return _handleCommonError(e);
  }

  AuthException _handleRegisterError(DioException e) {
    final detail = _detailFromResponse(e);

    if (detail == 'Email already registered') {
      return const AuthException('Este e-mail já está cadastrado.');
    }

    if (detail == 'CPF already registered') {
      return const AuthException('Este CPF já está cadastrado.');
    }

    if (e.response?.statusCode == 400 || e.response?.statusCode == 409) {
      return AuthException(
        detail != null && detail.isNotEmpty
            ? detail
            : 'Não foi possível concluir o cadastro.',
      );
    }

    return _handleCommonError(e);
  }

  AuthException _handleSessionError(DioException e) {
    if (e.response?.statusCode == 401) {
      return const AuthException(
        'Sua sessão expirou. Faça login novamente.',
        requiresLogin: true,
      );
    }

    final detail = _detailFromResponse(e);

    if (detail != null && detail.isNotEmpty) {
      return AuthException(detail);
    }

    return _handleCommonError(e);
  }

  AuthException _handleCommonError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const AuthException(
        'Não foi possível conectar ao servidor. Verifique sua conexão e tente novamente.',
      );
    }

    return const AuthException(
      'Não foi possível completar a solicitação. Tente novamente.',
    );
  }

  String? _detailFromResponse(DioException e) {
    final data = e.response?.data;

    if (data is Map && data.containsKey('detail')) {
      return data['detail']?.toString();
    }

    return null;
  }
}

class AuthException implements Exception {
  final String message;
  final bool requiresLogin;

  const AuthException(this.message, {this.requiresLogin = false});

  @override
  String toString() => message;
}
