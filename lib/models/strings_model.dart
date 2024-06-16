class StringsModel {
  final bool isSuccess;
  final String code;
  final String message;
  final List<String> result;

  StringsModel.fromJson(Map<String, dynamic> json)
      : isSuccess = json['isSuccess'],
        code = json['code'],
        message = json['message'],
        result = json['result'] != null ? json['result'].cast<String>() : [];
}
