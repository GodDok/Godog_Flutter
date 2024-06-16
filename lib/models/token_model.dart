class TokenModel {
  final bool isSuccess;
  final String code;
  final String message;
  final Result result;

  TokenModel.fromJson(Map<String, dynamic> json)
      : isSuccess = json['isSuccess'],
        code = json['code'],
        message = json['message'],
        result = json['result'] != null
            ? Result.fromJson(json['result'])
            : Result.empty();
}

class Result {
  final String accessToken;
  final String refreshToken;

  Result({required this.accessToken, required this.refreshToken});

  Result.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'] ?? '',
        refreshToken = json['refreshToken'] ?? '';

  Result.empty()
      : accessToken = '',
        refreshToken = '';
}