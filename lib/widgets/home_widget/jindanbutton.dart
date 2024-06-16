import 'package:flutter/material.dart';
import 'package:godog/screens/report/report_input_step1_screen.dart';

class CustomButtonContainer extends StatelessWidget {
  final String? userName;

  const CustomButtonContainer({super.key, this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 100,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
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
          Positioned(
            top: 15,
            left: 30,
            child: Text(
              "예비창업자 ${userName ?? '사용자'}님 번창하세요",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: InkWell(
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
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: const Text(
                  '진단하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
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
