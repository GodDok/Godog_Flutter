class UserNameData {
  final bool isSuccess;
  final String code;
  final String message;
  final String result;

  UserNameData({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  factory UserNameData.fromJson(Map<String, dynamic> json) {
    return UserNameData(
      isSuccess: json['isSuccess'],
      code: json['code'],
      message: json['message'],
      result: json['result'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'code': code,
      'message': message,
      'result': result,
    };
  }
}
