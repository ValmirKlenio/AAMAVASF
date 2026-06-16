import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8000',
      connectTimeout: const Duration(seconds: 10),
    ),
  );
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // ========== Token helpers ==========

  Future<String?> getToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<Options> _authOptions() async {
    final token = await getToken();
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  // ========== Auth ==========

  /// POST /token — Login
  Future<void> login(String email, String senha) async {
    try {
      final response = await _dio.post(
        '/token',
        data: {'username': email, 'password': senha},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      final token = response.data['access_token'];
      await _storage.write(key: 'access_token', value: token);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST /registrar — Cadastro de novo usuário
  Future<void> registrar({
    required String nome,
    required String email,
    required String senha,
    required String cpf,
    required String telefone,
    String? nomeDependente,
    String? dataNascDep,
  }) async {
    try {
      await _dio.post(
        '/registrar',
        data: {
          'nome': nome,
          'email': email,
          'senha': senha,
          'cpf': cpf,
          'telefone': telefone,
          if (nomeDependente != null) 'nome_dependente': nomeDependente,
          if (dataNascDep != null) 'data_nasc_dep': dataNascDep,
        },
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST /usuarios/alterar-senha — Trocar senha
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
      throw _handleError(e);
    }
  }

  // ========== Agendamentos ==========

  /// GET /usuarios/agendamentos — Listar agendamentos do usuário
  Future<List<dynamic>> visualizarAgendamentos() async {
    try {
      final response = await _dio.get(
        '/usuarios/agendamentos',
        options: await _authOptions(),
      );
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST /usuarios/agendar — Criar agendamento
  Future<Map<String, dynamic>> agendar({required int horarioId}) async {
    try {
      final response = await _dio.post(
        '/usuarios/agendar',
        data: {'horario_id': horarioId},
        options: await _authOptions(),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE /usuarios/cancelar/{id} — Cancelar agendamento
  Future<void> cancelarAgendamento(int agendamentoId) async {
    try {
      await _dio.delete(
        '/usuarios/cancelar/$agendamentoId',
        options: await _authOptions(),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ========== Error handler ==========

  String _handleError(DioException e) {
    if (e.response != null &&
        e.response!.data is Map &&
        e.response!.data.containsKey('detail')) {
      return e.response!.data['detail'].toString();
    }
    return 'Erro de conexão: ${e.message}';
  }
}
