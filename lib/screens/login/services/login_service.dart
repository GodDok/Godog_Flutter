import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:godog/models/token_model.dart';

abstract class ILoginService {
  ILoginService(this.dio);

  Future<TokenModel?> postLogin(String email, String password);

  final Dio dio;
}

class LoginService extends ILoginService {
  LoginService(super.dio);

  @override
  Future<TokenModel?> postLogin(String email, String password) async {
    try {
      final response = await dio.post(
        "/api/v1/login",
        data: {'email': email, 'password': password},
      );

      final result = jsonDecode(response.toString());
      return TokenModel.fromJson(result);
    } on DioException catch (e) {
      if (e.response != null) {
        final result = jsonDecode(e.response.toString());
        return TokenModel.fromJson(result);
      } else {
        throw Exception("Network error");
      }
    }
  }
}
