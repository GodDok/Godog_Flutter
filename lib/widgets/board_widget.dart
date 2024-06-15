import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:godog/models/board_list_model.dart';

class Board extends StatelessWidget {
  final BoardResult boardResult;

  const Board({super.key, required this.boardResult});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                boardResult.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "${boardResult.name} · ${boardResult.sectors}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/heart_fill.svg',
                    width: 10,
                    height: 10,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    boardResult.heartCount.toString(),
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
                    boardResult.commentCount.toString(),
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(color: Colors.grey),
      ],
    );
  }
}
