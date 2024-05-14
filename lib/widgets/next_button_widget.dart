import 'package:flutter/material.dart';

class NextButtonWidget extends StatelessWidget {
  const NextButtonWidget({
    super.key,
    required this.isComplete, required this.onClick,
  });

  final bool isComplete;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: !isComplete ? Colors.grey : Colors.blueAccent,
          ),
          child: IconButton(
            onPressed: () {
              if (isComplete) {
                onClick();
              }
            },
            icon: const Icon(
              Icons.arrow_forward_sharp,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}