import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:godog/models/break_even_model.dart';
import 'package:godog/models/count_model.dart';
import 'package:godog/models/policy_model.dart';
import 'package:godog/models/population_model.dart';

abstract class IHomeService {
  IHomeService(this.dio);

  Future<PopulationData?> getPopulation();
  Future<PolicyModel?> getPolicys();
  Future<BreakEvenData?> getBreakEven();
  Future<CompetitionData?> getCountCity();
  Future<CompetitionData?> getCountAverage();

  final Dio dio;
}

class HomeService extends IHomeService {
  HomeService(super.dio);

  @override
  Future<PopulationData?> getPopulation() async {
    final response = await dio.get(
      "/api/v1/population/gender",
    );
    if (response.statusCode == 200) {
      final result = jsonDecode(response.toString());
      return PopulationData.fromJson(result);
    }

    throw Error();
  }

  @override
  Future<BreakEvenData?> getBreakEven() async {
    final response = await dio.post(
      "/api/v1/break-even",
    );
    if (response.statusCode == 200) {
      final result = jsonDecode(response.toString());
      return BreakEvenData.fromJson(result);
    }

    throw Error();
  }

  @override
  Future<CompetitionData?> getCountCity() async {
    final response = await dio.get(
      "/api/v1/competitors/count",
    );
    if (response.statusCode == 200) {
      final result = jsonDecode(response.toString());
      return CompetitionData.fromJson(result);
    }

    throw Error();
  }

  @override
  Future<CompetitionData?> getCountAverage() async {
    final response = await dio.get(
      "/api/v1/competitors/average",
    );
    if (response.statusCode == 200) {
      final result = jsonDecode(response.toString());
      return CompetitionData.fromJson(result);
    }

    throw Error();
  }

  @override
  Future<PolicyModel?> getPolicys() async {
    final response = await dio.get(
      "/api/v1/getAllPolicies",
    );
    if (response.statusCode == 200) {
      final result = jsonDecode(response.toString());
      return PolicyModel.fromJson(result);
    }

    throw Error();
  }
}
