import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:godog/models/strings_model.dart';
import '../../../core/cache_manager.dart';
import '../../../models/report_model.dart';

abstract class IReportService {
  IReportService(this.dio);

  Future<StringsModel> getCity();

  Future<StringsModel> getDistrict(String district);

  Future<StringsModel> getStore(String type);

  Future<StringsModel> getCategory();

  Future<ReportModel> postReport(
      String marginRate,
      String totalBudget,
      String rent,
      String loanAmount,
      String otherExpenses,
      String wages,
      String avgWorkingDaysPerMonth,
      String monthlyProfitTarget,
      String location,
      String city,
      String district,
      String type);

  final Dio dio;
}

class ReportService extends IReportService {
  ReportService(super.dio);

  @override
  Future<ReportModel> postReport(
      String marginRate,
      String totalBudget,
      String rent,
      String loanAmount,
      String otherExpenses,
      String wages,
      String avgWorkingDaysPerMonth,
      String monthlyProfitTarget,
      String location,
      String city,
      String district,
      String type) async {
    try {
      final accessToken = await CacheManager().getAccessToken();

      final response = await dio.post(
        "/api/v1/reports",
        data: {
          'marginRate': marginRate,
          'totalBudget': totalBudget,
          'rent': rent,
          'loanAmount': loanAmount,
          'otherExpenses': otherExpenses,
          'wages': wages,
          'avgWorkingDaysPerMonth': avgWorkingDaysPerMonth,
          'monthlyProfitTarget': monthlyProfitTarget,
          'location': location,
          'city': city,
          'district': district,
          'type': type,
        },
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.toString());
        return ReportModel.fromJson(result);
      } else {
        throw Exception("Failed to post report");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final result = jsonDecode(e.response.toString());
        return ReportModel.fromJson(result);
      } else {
        throw Exception("Network error");
      }
    }
  }

  @override
  Future<StringsModel> getCity() async {
    try {
      final response = await dio.get(
        "/api/v1/region/city/경남",
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.toString());
        return StringsModel.fromJson(result);
      } else {
        throw Exception("Failed to fetch city");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final result = jsonDecode(e.response.toString());
        return StringsModel.fromJson(result);
      } else {
        throw Exception("Network error");
      }
    }
  }

  @override
  Future<StringsModel> getDistrict(String district) async {
    try {
      final response = await dio.get(
        "/api/v1/region/district/$district",
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.toString());
        return StringsModel.fromJson(result);
      } else {
        throw Exception("Failed to fetch district");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final result = jsonDecode(e.response.toString());
        return StringsModel.fromJson(result);
      } else {
        throw Exception("Network error");
      }
    }
  }

  @override
  Future<StringsModel> getCategory() async {
    try {
      final response = await dio.get(
        "/api/v1/store/category",
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.toString());
        return StringsModel.fromJson(result);
      } else {
        throw Exception("Failed to fetch category");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final result = jsonDecode(e.response.toString());
        return StringsModel.fromJson(result);
      } else {
        throw Exception("Network error");
      }
    }
  }

  @override
  Future<StringsModel> getStore(String type) async {
    try {
      final response = await dio.get(
        "/api/v1/store/type/$type",
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.toString());
        return StringsModel.fromJson(result);
      } else {
        throw Exception("Failed to fetch store");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final result = jsonDecode(e.response.toString());
        return StringsModel.fromJson(result);
      } else {
        throw Exception("Network error");
      }
    }
  }
}
