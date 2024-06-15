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
  Future<TokenModel> postLogin(String email, String password) async {
    final response = await dio
        .post("/api/v1/login", data: {'email': email, 'password': password});

    if (response.statusCode == 200) {
      final result = jsonDecode(response.toString());
      return TokenModel.fromJson(result);
    }

    throw Error();
  }
}
