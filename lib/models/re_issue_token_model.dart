class ReIssueAccessTokenModel {
  final bool isSuccess;
  final String code;
  final String message;
  final Result result;

  ReIssueAccessTokenModel.fromJson(Map<String, dynamic> json)
      : isSuccess = json['isSuccess'],
        code = json['code'],
        message = json['message'],
        result = Result.fromJson(json['result']);
}

class Result {
  final String accessToken;

  Result.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'];
}
