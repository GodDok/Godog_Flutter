/// isSuccess : true
/// code : "COMMON200"
/// message : "성공입니다."
/// result : [{"id":4,"title":"테스트3","detail":"테스트3","name":"dsfdsfsdf","sectors":"광고 대행업","heartCount":0,"commentCount":0,"createTime":"2024-05-28T15:05:37"},{"id":3,"title":"테스트2","detail":"테스트2","name":"dsfdsfsdf","sectors":"광고 대행업","heartCount":0,"commentCount":0,"createTime":"2024-05-28T15:05:31"},{"id":2,"title":"테스트1","detail":"테스트1","name":"dsfdsfsdf","sectors":"광고 대행업","heartCount":0,"commentCount":0,"createTime":"2024-05-28T15:05:24"},{"id":1,"title":"string","detail":"string","name":"dsfdsfsdf","sectors":"광고 대행업","heartCount":1,"commentCount":4,"createTime":"2024-05-28T15:03:50"}]

class BoardListModel {
  bool isSuccess = false;
  String code = "";
  String message = "";
  List<BoardResult> result = [];

  BoardListModel.fromJson(dynamic json) {
    isSuccess = json['isSuccess'];
    code = json['code'];
    message = json['message'];
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result.add(BoardResult.fromJson(v));
      });
    }
  }
}

/// id : 4
/// title : "테스트3"
/// detail : "테스트3"
/// name : "dsfdsfsdf"
/// sectors : "광고 대행업"
/// heartCount : 0
/// commentCount : 0
/// createTime : "2024-05-28T15:05:37"

class BoardResult {
  num id;
  String title;
  String detail;
  String name;
  String sectors;
  num heartCount;
  num commentCount;
  String createTime;

  BoardResult.fromJson(dynamic json)
      : id = json['id'],
        title = json['title'],
        detail = json['detail'],
        name = json['name'],
        sectors = json['sectors'],
        heartCount = json['heartCount'],
        commentCount = json['commentCount'],
        createTime = json['createTime'];
}
