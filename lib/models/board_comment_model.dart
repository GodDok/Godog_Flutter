/// isSuccess : true
/// code : "COMMON200"
/// message : "성공입니다."
/// result : [{"id":4,"name":"dsfdsfsdf","sectors":"광고 대행업","comment":"댓글3","createTime":"2024-05-28T15:15:47"},{"id":3,"name":"dsfdsfsdf","sectors":"광고 대행업","comment":"댓글2","createTime":"2024-05-28T15:15:43"},{"id":2,"name":"dsfdsfsdf","sectors":"광고 대행업","comment":"댓글1","createTime":"2024-05-28T15:15:41"},{"id":1,"name":"dsfdsfsdf","sectors":"광고 대행업","comment":"댓글","createTime":"2024-05-28T15:15:37"}]

class BoardCommentModel {
  bool isSuccess = false;
  String code = "";
  String message = "";
  List<CommentResult> result = [];

  BoardCommentModel.fromJson(dynamic json) {
    isSuccess = json['isSuccess'];
    code = json['code'];
    message = json['message'];
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result.add(CommentResult.fromJson(v));
      });
    }
  }
}

/// id : 4
/// name : "dsfdsfsdf"
/// sectors : "광고 대행업"
/// comment : "댓글3"
/// createTime : "2024-05-28T15:15:47"

class CommentResult {
  num id;
  String name;
  String sectors;
  String comment;
  String createTime;

  CommentResult.fromJson(dynamic json)
      : id = json['id'],
        name = json['name'],
        sectors = json['sectors'],
        comment = json['comment'],
        createTime = json['createTime'];
}
