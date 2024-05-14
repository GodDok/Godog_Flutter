import 'package:flutter/material.dart';

class ProgressWidget extends StatelessWidget {
  const ProgressWidget({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: value,
      backgroundColor: Colors.grey,
      color: Colors.white,
      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
      minHeight: 2.0,
      semanticsLabel: 'semanticsLabel',
      semanticsValue: 'semanticsValue',
    );
  }
}
