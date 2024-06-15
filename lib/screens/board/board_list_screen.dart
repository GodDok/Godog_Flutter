import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    try {
      final BoardService boardService =
          BoardService(NetworkService.instance.dio);
      final boardListResult = await boardService.getBoardList();

      if (boardListResult.isSuccess) {
        setState(() {
          boardList = boardListResult.result;
          filteredList = boardListResult.result;
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
        title: const Text(
          '창업 커뮤니티',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0.0), // 조정 가능한 값입니다.
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BoardPostScreen(),
              ),
            ).then((value) => {getBoardList()});
          },
          backgroundColor: const Color(0xFF4E7FFF),
          elevation: 0,
          // 그림자 없애기
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // 완전히 둥글게
          ),
          child: SvgPicture.asset(
            'assets/icons/pencil.svg',
            width: 30,
            height: 30,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: '제목을 입력하세요',
                hintStyle: const TextStyle(color: Colors.grey),
                // Hint 색상 설정
                contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                // 시작 패딩 설정
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide:
                      const BorderSide(color: Color(0xFF4E7FFF), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide:
                      const BorderSide(color: Color(0xFF4E7FFF), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide:
                      const BorderSide(color: Color(0xFF4E7FFF), width: 2),
                ),
                suffixIcon: GestureDetector(
                  child: const Icon(
                    Icons.search,
                    color: Color(0xFF4E7FFF),
                    size: 30,
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
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                itemCount: filteredList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
