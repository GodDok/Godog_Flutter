import 'package:flutter/material.dart';

class JoinStep2Screen extends StatefulWidget {
  const JoinStep2Screen({super.key});

  @override
  State<JoinStep2Screen> createState() => _JoinStep2ScreenState();
}

class _JoinStep2ScreenState extends State<JoinStep2Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const LinearProgressIndicator(
              value: 0.7,
              backgroundColor: Colors.grey,
              color: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              minHeight: 2.0,
              semanticsLabel: 'semanticsLabel',
              semanticsValue: 'semanticsValue',
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
