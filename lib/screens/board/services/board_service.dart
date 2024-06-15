import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:godog/models/board_comment_model.dart';
import 'package:godog/models/board_list_model.dart';
import '../../../core/cache_manager.dart';
import '../../../models/string_result_model.dart';

abstract class IBoardService {
  IBoardService(this.dio);

  Future<BoardListModel> getBoardList();

  Future<BoardCommentModel> getComment(int id);

  Future<StringResultModel> postComment(int id, String comment);

  Future<StringResultModel> postBoard(String title, String detail);

  Future<StringResultModel> postHart(int id);

  final Dio dio;
}

class BoardService extends IBoardService {
  BoardService(super.dio);

  @override
  Future<BoardListModel> getBoardList() async {
    final accessToken = await CacheManager().getAccessToken();

    final response = await dio.get("/api/v1/board",
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.toString());
      return BoardListModel.fromJson(result);
    }

    throw Error();
  }

  @override
  Future<BoardCommentModel> getComment(int id) async {
    final accessToken = await CacheManager().getAccessToken();

    final response = await dio.get(
      "/api/v1/board/comment/$id",
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.toString());
      return BoardCommentModel.fromJson(result);
    }

    throw Error();
  }

  @override
  Future<StringResultModel> postBoard(String title, String detail) async {
    final accessToken = await CacheManager().getAccessToken();

    final response = await dio.post("/api/v1/board",
        data: {'title': title, 'detail': detail},
        options: Options(
            contentType: Headers.jsonContentType,
            headers: {'Authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.toString());
      return StringResultModel.fromJson(result);
    }

    throw Error();
  }

  @override
  Future<StringResultModel> postComment(int id, String comment) async {
    final accessToken = await CacheManager().getAccessToken();

    final response = await dio.post("/api/v1/board/comment/$id",
        data: {'comment': comment},
        options: Options(
            contentType: Headers.jsonContentType,
            headers: {'Authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.toString());
      return StringResultModel.fromJson(result);
    }

    throw Error();
  }

  @override
  Future<StringResultModel> postHart(int id) async {
    final accessToken = await CacheManager().getAccessToken();

    final response = await dio.post("/api/v1/heart/$id",
        options: Options(
            contentType: Headers.jsonContentType,
            headers: {'Authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.toString());
      return StringResultModel.fromJson(result);
    }

    throw Error();
  }
}
