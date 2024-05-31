import 'package:flutter/material.dart';
import 'package:godog/screens/report/report_input_step1_screen.dart';

class CustomButtonContainer extends StatelessWidget {
  const CustomButtonContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 100,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(242, 242, 242, 0.9),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 15,
            left: 30,
            child: Text(
              "예비창업자 전제윤님 번창하세요",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: InkWell(
              // InkWell을 사용하여 버튼 기능 구현
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ReportInputStep1Screen()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  '시작',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: Center(
        child: CustomButtonContainer(),
      ),
    ),
  ));
}
