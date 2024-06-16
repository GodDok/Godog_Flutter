class ReIssueAccessTokenModel {
  final bool isSuccess;
  final String code;
  final String message;
  final Result result;

  ReIssueAccessTokenModel.fromJson(Map<String, dynamic> json)
      : isSuccess = json['isSuccess'],
        code = json['code'],
        message = json['message'],
        result = json['result'] != null
            ? Result.fromJson(json['result'])
            : Result.empty();
}

class Result {
  final String accessToken;

  Result({required this.accessToken});

  Result.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'] ?? '';

  Result.empty()
      : accessToken = '';
}
