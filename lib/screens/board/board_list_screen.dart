import 'package:flutter/material.dart';
import 'package:godog/core/network_service.dart';
import 'package:godog/models/board_list_model.dart';
import 'package:godog/screens/board/board_detail_screen.dart';
import 'package:godog/screens/board/board_post_screen.dart';
import 'package:godog/screens/board/services/board_service.dart';

import '../../widgets/board_widget.dart';

class BoardListScreen extends StatefulWidget {
  const BoardListScreen({super.key});

  @override
  State<BoardListScreen> createState() => _BoardListScreenState();
}

class _BoardListScreenState extends State<BoardListScreen> {
  List<BoardResult> filteredList = [];
  List<BoardResult> boardList = [];

  getBoardList() async {
    final BoardService boardService = BoardService(NetworkService.instance.dio);
    final boardListResult = await boardService.getBoardList();

    setState(() {
      boardList = boardListResult.result;
      filteredList = boardListResult.result;
    });
  }

  @override
  void initState() {
    super.initState();
    getBoardList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('창업 커뮤니티'),
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BoardPostScreen(),
            ),
          ).then((value) => {getBoardList()});
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: '제목을 입력하세요',
                border: const OutlineInputBorder(),
                suffixIcon: GestureDetector(
                  child: const Icon(
                    Icons.search,
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  filteredList = boardList
                      .where((item) => item.title.contains(value))
                      .toList();
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BoardDetailScreen(
                                boardResult: filteredList[index],
                              ),
                            ),
                          );
                        },
                        child: Board(
                          boardResult: filteredList[index],
                        ));
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Column(children: [
                        SizedBox(
                          height: 10,
                        ),
                      ]),
                  itemCount: filteredList.length),
            ),
          ],
        ),
      ),
    );
  }
}
