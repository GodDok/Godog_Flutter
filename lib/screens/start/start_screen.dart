import 'package:flutter/material.dart';
import 'package:godog/screens/report/report_input_step1_screen.dart';
import '../../core/cache_manager.dart';
import '../../main.dart';
import '../../widgets/basic_text_button_widget.dart';
import '../login/login_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  Future<void> navigate(BuildContext context) async {
    final accessToken = await CacheManager().getAccessToken();
    final isReportCompleted = await CacheManager().getReport();

    if (accessToken != null) {
      if (isReportCompleted != null && isReportCompleted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
            fullscreenDialog: true,
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ReportInputStep1Screen(),
            fullscreenDialog: true,
          ),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
          fullscreenDialog: true,
        ),
      );
    }
  }

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
              onClick: () => navigate(context),
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
