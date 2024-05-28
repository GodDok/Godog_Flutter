class PopulationData {
  bool isSuccess;
  String code;
  String message;
  List<PopulationRecord> result;

  PopulationData({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  factory PopulationData.fromJson(Map<String, dynamic> json) {
    return PopulationData(
      isSuccess: json['isSuccess'],
      code: json['code'],
      message: json['message'],
      result: List<PopulationRecord>.from(
          json['result'].map((x) => PopulationRecord.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'code': code,
      'message': message,
      'result': List<dynamic>.from(result.map((x) => x.toJson())),
    };
  }
}

class PopulationRecord {
  int id;
  String yearAndMonth;
  String regionName;
  String ageGroup;
  int maleCount;
  int femaleCount;

  PopulationRecord({
    required this.id,
    required this.yearAndMonth,
    required this.regionName,
    required this.ageGroup,
    required this.maleCount,
    required this.femaleCount,
  });

  factory PopulationRecord.fromJson(Map<String, dynamic> json) {
    return PopulationRecord(
      id: json['id'],
      yearAndMonth: json['yearAndMonth'],
      regionName: json['regionName'],
      ageGroup: json['ageGroup'],
      maleCount: json['maleCount'],
      femaleCount: json['femaleCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'yearAndMonth': yearAndMonth,
      'regionName': regionName,
      'ageGroup': ageGroup,
      'maleCount': maleCount,
      'femaleCount': femaleCount,
    };
  }
}
