import 'package:flutter/material.dart';
import 'package:godog/models/board_list_model.dart';

class Board extends StatelessWidget {
  final BoardResult boardResult;

  const Board({super.key, required this.boardResult});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(
                  5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    boardResult.title,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                            "${boardResult.name} · ${boardResult.sectors}"),
                      ),
                      const Icon(Icons.favorite),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(boardResult.heartCount.toString()),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(Icons.chat_bubble),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(boardResult.commentCount.toString()),
                    ],
                  )
                ],
              )),
        )
      ],
    );
  }
}
