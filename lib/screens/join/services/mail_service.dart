import 'package:dio/dio.dart';

abstract class IMailService {
  IMailService(this.dio);

  Future<bool> postMailSend(String email);

  Future<bool> postMailCheck(String email, String authNum);

  final Dio dio;
}

class MailService extends IMailService {
  MailService(super.dio);

  @override
  Future<bool> postMailSend(String email) async {
    final response = await dio.post("api/v1/mailsend",
        data: {'email': email},
        options: Options(contentType: Headers.jsonContentType));

    if (response.statusCode == 200) {
      return true;
    }

    throw Error();
  }

  @override
  Future<bool> postMailCheck(String email, String authNum) async {
    final response = await dio.post("api/v1/mailauthCheck",
        data: {'email': email, 'authNum': authNum},
        options: Options(contentType: Headers.jsonContentType));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
