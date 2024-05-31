class MapData {
  final double longitude;
  final double latitude;
  final int deposit;
  final int monthly;
  final int premium;
  final int area;
  final String contents;
  final String locationUrl;

  MapData({
    required this.longitude,
    required this.latitude,
    required this.deposit,
    required this.monthly,
    required this.premium,
    required this.area,
    required this.contents,
    required this.locationUrl,
  });

  factory MapData.fromJson(Map<String, dynamic> json) {
    return MapData(
      longitude: double.parse(json['longitude']),
      latitude: double.parse(json['latitude']),
      deposit: int.parse(json['deposit']),
      monthly: int.parse(json['monthly']),
      premium: int.parse(json['premium']),
      area: int.parse(json['area']),
      contents: json['contents'],
      locationUrl: json['locationurl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'longitude': longitude.toString(),
      'latitude': latitude.toString(),
      'deposit': deposit.toString(),
      'monthly': monthly.toString(),
      'premium': premium.toString(),
      'area': area.toString(),
      'contents': contents,
      'locationurl': locationUrl,
    };
  }
}
