import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../models/token_model.dart';

abstract class IJoinService {
  IJoinService(this.dio);

  Future<TokenModel?> postSignup(String email, String password, String name,
      String gender, String birthDate);

  final Dio dio;
}

class JoinService extends IJoinService {
  JoinService(super.dio);

  @override
  Future<TokenModel> postSignup(String email, String password, String name,
      String gender, String birthDate) async {
    final response = await dio.post("/api/v1/signup",
        data: {
          'email': email,
          'password': password,
          'name': name,
          'gender': gender,
          'birthDate': birthDate
        },
        options: Options(contentType: Headers.jsonContentType));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.toString());
      return TokenModel.fromJson(result);
    }

    throw Error();
  }
}
