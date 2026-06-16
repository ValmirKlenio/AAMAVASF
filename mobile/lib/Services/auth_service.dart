import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8000', // troque pelo IP correto
      connectTimeout: const Duration(seconds: 10),
    ),
  );
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

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

  String _handleError(DioException e) {
    if (e.response != null &&
        e.response!.data is Map &&
        e.response!.data.containsKey('detail')) {
      return e.response!.data['detail'];
    }
    return 'Erro de conexão: ${e.message}';
  }
}
