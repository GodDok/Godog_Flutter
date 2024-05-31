/// isSuccess : true
/// code : "COMMON200"
/// message : "성공입니다."
/// result : "테스트3글이 작성되었습니다"

class StringResultModel {
  bool isSuccess;
  String code;
  String message;
  String result;

  StringResultModel.fromJson(dynamic json)
      : isSuccess = json['isSuccess'],
        code = json['code'],
        message = json['message'],
        result = json['result'];
}
