import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart'; // 패키지 이름 수정
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
        setState(() {
          widget.boardResult.heartCount = widget.boardResult.heartCount + 1;
        });
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
        title: const Text('게시글 상세', style: TextStyle(fontWeight: FontWeight.bold),),
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
                Image.asset(
                  'assets/images/profile.png', // 확장자명을 .svg로 수정
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 10), // 프로필 이미지와 이름 사이 간격 추가
                Text(
                  widget.boardResult.name,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ]),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.boardResult.title,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.boardResult.detail,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: postHeart,
                    child: SvgPicture.asset(
                      'assets/icons/heart_fill.svg',
                      width: 10,
                      height: 10,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.boardResult.heartCount}',
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  SvgPicture.asset(
                    'assets/icons/ellipsis_message.svg',
                    width: 10,
                    height: 10,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${commentList.length}',
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                height: 1,
                color: Colors.black,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: commentList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(children: [
                          ClipOval(
                            child: Image.asset(
                              'assets/images/profile.png',
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              commentList[index].name,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            getRelativeTime(commentList[index].createTime),
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey),
                          ),
                        ]),
                        const SizedBox(width: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Text(
                            commentList[index].comment,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 20,
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
