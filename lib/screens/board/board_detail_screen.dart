import 'dart:async';

import 'package:flutter/material.dart';
import 'package:godog/models/board_comment_model.dart';
import 'package:godog/models/board_list_model.dart';
import 'package:godog/screens/board/services/board_service.dart';
import 'package:intl/intl.dart';

import '../../core/network_service.dart';

class BoardDetailScreen extends StatefulWidget {
  final BoardResult boardResult;

  const BoardDetailScreen({super.key, required this.boardResult});

  @override
  State<BoardDetailScreen> createState() => _BoardDetailScreenState();
}

class _BoardDetailScreenState extends State<BoardDetailScreen> {
  final TextEditingController commentController = TextEditingController();
  List<CommentResult> commentList = [];

  Future<void> getComment() async {
    try {
      final BoardService boardService =
          BoardService(NetworkService.instance.dio);
      final boardListResult =
          await boardService.getComment(widget.boardResult.id.toInt());

      if (boardListResult.isSuccess) {
        setState(() {
          commentList = boardListResult.result;
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(boardListResult.message)));
      }
    } catch (e) {
      print("Error: $e");

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('에러가 발생했습니다.')));
    }
  }

  Future<void> postComment(String comment) async {
    try {
      final BoardService boardService =
          BoardService(NetworkService.instance.dio);
      final result = await boardService.postComment(
          widget.boardResult.id.toInt(), comment);

      if (result.isSuccess) {
        getComment();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result.message)));
      }
    } catch (e) {
      print("Error: $e");

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('에러가 발생했습니다.')));
    }
  }

  Future<void> postHeart() async {
    try {
      final BoardService boardService =
          BoardService(NetworkService.instance.dio);
      final result = await boardService.postHart(widget.boardResult.id.toInt());

      if (result.isSuccess) {
        getComment();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result.message)));
      }
    } catch (e) {
      print("Error: $e");

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('에러가 발생했습니다.')));
    }
  }

  @override
  void initState() {
    super.initState();
    getComment();
  }

  String getRelativeTime(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      DateTime utcDateTime = DateTime.parse(dateTimeString);
      DateTime kstDateTime = utcDateTime.add(const Duration(hours: 9));
      Duration difference = DateTime.now().difference(kstDateTime);

      if (difference.inSeconds < 60) {
        return '${difference.inSeconds}초 전';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}분 전';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}시간 전';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}일 전';
      } else {
        return DateFormat('yyyy-MM-dd').format(dateTime);
      }
    } catch (e) {
      print("Error: $e");
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('게시글 상세'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 3,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Expanded(
                  child: Text(
                    widget.boardResult.title,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: postHeart,
                  icon: const Icon(Icons.favorite),
                ),
              ]),
              const SizedBox(
                height: 1,
              ),
              Text(
                "${widget.boardResult.name} · ${widget.boardResult.sectors}",
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(
                height: 1,
              ),
              Text(
                widget.boardResult.detail,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                '댓글 ${widget.boardResult.commentCount}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: commentList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(
                            child: Text(
                              '${commentList[index].name} · ${commentList[index].sectors}',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Text(
                            getRelativeTime(commentList[index].createTime),
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey),
                          ),
                        ]),
                        Text(
                          commentList[index].comment,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: '댓글을 입력하세요',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      postComment(commentController.text);
                      commentController.clear();
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              )
            ],
          )),
    );
  }
}
