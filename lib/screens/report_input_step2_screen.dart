import 'package:flutter/material.dart';
import 'package:godog/screens/login_screen.dart';
import 'package:godog/widgets/report_input_widget.dart';
import '../widgets/next_button_widget.dart';
import '../widgets/progress_widget.dart';

class ReportInputStep2Screen extends StatefulWidget {
  const ReportInputStep2Screen({super.key});

  @override
  State<ReportInputStep2Screen> createState() => _ReportInputStep2ScreenState();
}

class _ReportInputStep2ScreenState extends State<ReportInputStep2Screen> {
  bool isCompletedInput = false; // 입력 완료 상태 유무
  String? marginRate;
  String? totalBudget;
  String? rent;
  String? loan;
  String? otherExpenses;
  String? personnelExpenses;
  String? averageNumberOfWorkingDaysPerMonth;
  String? theGoalIs;

  inputCompleteConfirmation() {
    // 입력 완료 여부 확인
    setState(() {
      isCompletedInput = (marginRate ?? "").isNotEmpty &&
          (totalBudget ?? "").isNotEmpty &&
          (totalBudget ?? "").isNotEmpty &&
          (rent ?? "").isNotEmpty &&
          (loan ?? "").isNotEmpty &&
          (otherExpenses ?? "").isNotEmpty &&
          (personnelExpenses ?? "").isNotEmpty &&
          (averageNumberOfWorkingDaysPerMonth ?? "").isNotEmpty &&
          (theGoalIs ?? "").isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: const Color(0xfff5f5f5),
        title: const Text(
          "손익분기점 계산",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const ProgressWidget(value: 1.0),
            const SizedBox(
              height: 30,
            ),
            ReportInputWidget(
                onChanged: (value) {
                  setState(() {
                    marginRate = value;
                  });

                  inputCompleteConfirmation();
                },
                suffixText: '%',
                text: '마진율'),
            const SizedBox(
              height: 20,
            ),
            ReportInputWidget(
                onChanged: (value) {
                  setState(() {
                    totalBudget = value;
                  });

                  inputCompleteConfirmation();
                },
                suffixText: '만원',
                text: '총예산'),
            const SizedBox(
              height: 20,
            ),
            ReportInputWidget(
                onChanged: (value) {
                  setState(() {
                    rent = value;
                  });

                  inputCompleteConfirmation();
                },
                suffixText: '만원',
                text: '임대료'),
            const SizedBox(
              height: 20,
            ),
            ReportInputWidget(
                onChanged: (value) {
                  setState(() {
                    loan = value;
                  });

                  inputCompleteConfirmation();
                },
                suffixText: '만원',
                text: '대출금'),
            const SizedBox(
              height: 20,
            ),
            ReportInputWidget(
                onChanged: (value) {
                  setState(() {
                    otherExpenses = value;
                  });

                  inputCompleteConfirmation();
                },
                suffixText: '만원',
                text: '기타경비'),
            const SizedBox(
              height: 20,
            ),
            ReportInputWidget(
                onChanged: (value) {
                  setState(() {
                    personnelExpenses = value;
                  });

                  inputCompleteConfirmation();
                },
                suffixText: '만원',
                text: '인건비'),
            const SizedBox(
              height: 20,
            ),
            ReportInputWidget(
                onChanged: (value) {
                  setState(() {
                    averageNumberOfWorkingDaysPerMonth = value;
                  });

                  inputCompleteConfirmation();
                },
                suffixText: '일',
                text: '월평균 근무일 수'),
            const SizedBox(
              height: 20,
            ),
            ReportInputWidget(
                onChanged: (value) {
                  setState(() {
                    theGoalIs = value;
                  });

                  inputCompleteConfirmation();
                },
                suffixText: '만원',
                text: '목표이일(월)'),
            const SizedBox(
              height: 20,
            ),
            Expanded(child: Container()),
            NextButtonWidget(
                isComplete: isCompletedInput,
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                }),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
