class StoreModel {
  final int? id;
  final String longitude;
  final String latitude;
  final String deposit;
  final String monthly;
  final String premium;
  final String area;
  final String contents;
  final String storeName;
  final String maintenanceCost;
  final String floor;
  final String joinDate;
  final String pictureUrl;

  StoreModel({
    required this.id,
    required this.longitude,
    required this.latitude,
    required this.deposit,
    required this.monthly,
    required this.premium,
    required this.area,
    required this.contents,
    required this.storeName,
    required this.maintenanceCost,
    required this.floor,
    required this.joinDate,
    required this.pictureUrl,
  });

  // JSON 데이터를 Store 객체로 변환하는 factory constructor
  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      deposit: json['deposit'],
      monthly: json['monthly'],
      premium: json['premium'],
      area: json['area'],
      contents: json['contents'],
      storeName: json['storeName'],
      maintenanceCost: json['maintenanceCost'],
      floor: json['floor'],
      joinDate: json['joinDate'],
      pictureUrl: json['pictureUrl'],
    );
  }

  // Store 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'longitude': longitude,
      'latitude': latitude,
      'deposit': deposit,
      'monthly': monthly,
      'premium': premium,
      'area': area,
      'contents': contents,
      'storeName': storeName,
      'maintenanceCost': maintenanceCost,
      'floor': floor,
      'joinDate': joinDate,
      'pictureUrl': pictureUrl,
    };
  }
}
