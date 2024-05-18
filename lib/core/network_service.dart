import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:godog/core/cache_manager.dart';
import 'package:godog/models/re_issue_token_model.dart';

class NetworkService {
  static NetworkService? _instace;

  static NetworkService get instance {
    if (_instace != null) return _instace!;
    _instace = NetworkService._init();
    return _instace!;
  }

  final String _baseUrl = 'http://10.0.2.2:8080';
  late final Dio dio;

  NetworkService._init() {
    dio = Dio(BaseOptions(baseUrl: _baseUrl));

    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await CacheManager().getAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401 || e.response?.statusCode == 302) {
            try {
              final cacheManager = CacheManager();
              final refreshToken = await cacheManager.getRefreshToken();

              if (refreshToken != null) {
                final refreshResponse = await reIssueAccessToken(refreshToken);

                final accessToken = refreshResponse.result.accessToken;
                cacheManager.saveAccessToken(accessToken);

                final options = e.requestOptions;

                options.headers
                    .addAll({'authorization': 'Bearer $accessToken'});

                final response = await dio.fetch(options);

                return handler.resolve(response);
              } else {
                return handler.reject(e);
              }
            } catch (err) {
              if (kDebugMode) {
                print(err);
              }
              return handler.reject(e);
            }
          }

          return handler.reject(e);
        },
      ),
    );
  }

  Future<ReIssueAccessTokenModel> reIssueAccessToken(
      String refreshToken) async {
    final response = await dio.post("/reIssueAccessToken",
        data: {'refreshToken': refreshToken},
        options: Options(contentType: Headers.jsonContentType));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.toString());
      return ReIssueAccessTokenModel.fromJson(result);
    }

    throw Error();
  }
}
