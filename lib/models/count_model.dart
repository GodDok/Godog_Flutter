class CompetitionData {
  bool isSuccess;
  String code;
  String message;
  double result;

  CompetitionData({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  factory CompetitionData.fromJson(Map<String, dynamic> json) {
    return CompetitionData(
      isSuccess: json['isSuccess'],
      code: json['code'],
      message: json['message'],
      result: double.parse(json['result']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'code': code,
      'message': message,
      'result': result.toString(),
    };
  }
}
