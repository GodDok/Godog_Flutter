import 'package:flutter/material.dart';
import '../../widgets/basic_text_button_widget.dart';
import '../login/login_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Image.asset('assets/images/main_logo.png'),
                const Text('창신',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    )),
              ],
            ),
            const Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '창업인들에게\n용기를',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            BasicTextButtonWidget(
              text: '로그인',
              backgroundColor: Colors.blueAccent,
              textColor: Colors.white,
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                      fullscreenDialog: true),
                );
              },
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
