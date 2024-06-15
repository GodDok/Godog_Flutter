import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:godog/models/break_even_model.dart';
import 'package:godog/models/competition_model.dart';
import 'package:godog/models/count_model.dart';
import 'package:godog/models/policy_model.dart';
import 'package:godog/models/population_model.dart';
import 'package:godog/models/user_model.dart';

import '../../../core/cache_manager.dart';

abstract class IHomeService {
  IHomeService(this.dio);

  Future<PopulationData?> getPopulation();
  Future<PolicyModel?> getPolicys(String province); // 매개변수 추가
  Future<BreakEvenData?> getBreakEven();
  Future<CompetitionData?> getCountCity();
  Future<CompetitionData?> getCountAverage();
  Future<CompetitionRate?> getCompetitionYearRate();
  Future<CompetitionRate?> getCompetitionQuarterRate();
  Future<UserNameData?> getUserName();

  final Dio dio;
}

class HomeService extends IHomeService {
  HomeService(super.dio);

  @override
  Future<PopulationData?> getPopulation() async {
    final accessToken = await CacheManager().getAccessToken();

    final response = await dio.get("/api/v1/population/gender",
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.toString());
      return PopulationData.fromJson(result);
    }

    throw Error();
  }

  @override
  Future<BreakEvenData?> getBreakEven() async {
    final accessToken = await CacheManager().getAccessToken();

    final response = await dio.post("/api/v1/break-even",
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.toString());
      return BreakEvenData.fromJson(result);
    }

    throw Error();
  }

  @override
  Future<CompetitionData?> getCountCity() async {
    final accessToken = await CacheManager().getAccessToken();

    final response = await dio.get("/api/v1/competitors/count",
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.toString());
      return CompetitionData.fromJson(result);
    }

    throw Error();
  }

  @override
  Future<CompetitionData?> getCountAverage() async {
    final accessToken = await CacheManager().getAccessToken();

    final response = await dio.get("/api/v1/competitors/average",
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.toString());
      return CompetitionData.fromJson(result);
    }

    throw Error();
  }

  @override
  Future<UserNameData?> getUserName() async {
    final accessToken = await CacheManager().getAccessToken();

    final response = await dio.get("/api/v1/myname",
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.toString());
      return UserNameData.fromJson(result);
    }

    throw Error();
  }

  @override
  Future<PolicyModel?> getPolicys(String province) async {
    final accessToken = await CacheManager().getAccessToken();

    final response = await dio.get(
        "/api/v1/searchQualifiesAllCondition?categories=$province",
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.toString());
      return PolicyModel.fromJson(result);
    }

    throw Error();
  }

  @override
  Future<CompetitionRate?> getCompetitionYearRate() async {
    final accessToken = await CacheManager().getAccessToken();

    final response = await dio.get("/api/v1/competitors/year-rate",
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.toString());
      return CompetitionRate.fromJson(result);
    }

    throw Error();
  }

  @override
  Future<CompetitionRate?> getCompetitionQuarterRate() async {
    final accessToken = await CacheManager().getAccessToken();

    final response = await dio.get("/api/v1/competitors/quarter-rate",
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.toString());
      return CompetitionRate.fromJson(result);
    }

    throw Error();
  }
}
