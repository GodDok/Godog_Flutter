import 'package:flutter/material.dart';
import 'package:godog/screens/board/services/board_service.dart';

import '../../core/network_service.dart';
import '../../widgets/basic_text_button_widget.dart';

class BoardPostScreen extends StatefulWidget {
  const BoardPostScreen({super.key});

  @override
  State<BoardPostScreen> createState() => _BoardPostScreenState();
}

class _BoardPostScreenState extends State<BoardPostScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  Future<void> submitPost() async {
    try {
      String title = titleController.text;
      String content = contentController.text;

      if (title.isEmpty || content.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('제목과 내용을 모두 입력해주세요.')),
        );
        return;
      } else {
        final BoardService boardService =
            BoardService(NetworkService.instance.dio);
        final result = await boardService.postBoard(title, content);

        if (result.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.message)),
          );

          titleController.clear();
          contentController.clear();

          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.message)),
          );
        }
      }
    } catch (e) {
      print("Error: $e");

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('에러가 발생했습니다.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('게시글 작성'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: '제목',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(),
              ),
              textAlignVertical: TextAlignVertical.top,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: '내용',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
            const SizedBox(height: 16),
            BasicTextButtonWidget(
                text: '완료',
                backgroundColor: Colors.blueAccent,
                textColor: Colors.white,
                onClick: submitPost),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
