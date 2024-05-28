import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:godog/models/map_model.dart';

abstract class IMapService {
  IMapService(this.dio);

  Future<MapData?> getMap();

  final Dio dio;
}

class MapService extends IMapService {
  MapService(super.dio);

  @override
  Future<MapData?> getMap() async {
    final response = await dio.get(
      "/api/v1/map",
    );
    if (response.statusCode == 200) {
      final result = jsonDecode(response.toString());
      return MapData.fromJson(result);
    }

    throw Error();
  }
}
