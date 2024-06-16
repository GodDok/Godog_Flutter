class CompetitionRate {
  final bool isSuccess;
  final String code;
  final String message;
  final String result;

  CompetitionRate({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  // JSON 데이터를 Dart 객체로 변환하기 위한 factory 생성자
  factory CompetitionRate.fromJson(Map<String, dynamic> json) {
    return CompetitionRate(
      isSuccess: json['isSuccess'],
      code: json['code'],
      message: json['message'],
      result: json['result'],
    );
  }

  // Dart 객체를 JSON 데이터로 변환하기 위한 메서드
  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'code': code,
      'message': message,
      'result': result,
    };
  }
}
