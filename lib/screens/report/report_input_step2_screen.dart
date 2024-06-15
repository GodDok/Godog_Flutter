import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:godog/main.dart';
import 'package:godog/screens/report/services/report_service.dart';
import 'package:godog/widgets/report_input_widget.dart';

import '../../core/cache_manager.dart';
import '../../core/network_service.dart';
import '../../widgets/next_button_widget.dart';
import '../../widgets/progress_widget.dart';

class ReportInputStep2Screen extends StatefulWidget {
  final String city;
  final String province;
  final String neighborhood;
  final String category;

  const ReportInputStep2Screen(
    this.city,
    this.province,
    this.neighborhood,
    this.category, {
    super.key,
  });

  @override
  State<ReportInputStep2Screen> createState() => _ReportInputStep2ScreenState();
}

class _ReportInputStep2ScreenState extends State<ReportInputStep2Screen> {
  bool isCompletedInput = false;
  String? marginRate;
  String? totalBudget;
  String? rent;
  String? loan;
  String? otherExpenses;
  String? personnelExpenses;
  String? averageNumberOfWorkingDaysPerMonth;
  String? theGoalIs;

  createReport() async {
    try {
      final Dio dio = NetworkService.instance.dio;
      final ReportService reportService = ReportService(dio);
      final result = await reportService.postReport(
        marginRate!,
        totalBudget!,
        rent!,
        loan!,
        otherExpenses!,
        personnelExpenses!,
        averageNumberOfWorkingDaysPerMonth!,
        theGoalIs!,
        widget.city,
        widget.province,
        widget.neighborhood,
        widget.category,
      );

      if (result.isSuccess) {
        final cacheManger = CacheManager();
        await cacheManger.saveReport(true);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message)),
        );
      }
    } catch (e) {
      print("Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('에러가 발생했습니다.')),
      );
    }
  }

  inputCompleteConfirmation() {
    setState(() {
      isCompletedInput = (marginRate ?? "").isNotEmpty &&
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "손익분기점 계산",
          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProgressWidget(value: 1.0),
            const SizedBox(height: 30),
            ReportInputWidget(
              onChanged: (value) {
                setState(() {
                  marginRate = value;
                });
                inputCompleteConfirmation();
              },
              suffixText: '%',
              text: '마진율',
            ),
            const SizedBox(height: 20),
            ReportInputWidget(
              onChanged: (value) {
                setState(() {
                  totalBudget = value;
                });
                inputCompleteConfirmation();
              },
              suffixText: '만원',
              text: '총예산',
            ),
            const SizedBox(height: 20),
            ReportInputWidget(
              onChanged: (value) {
                setState(() {
                  rent = value;
                });
                inputCompleteConfirmation();
              },
              suffixText: '만원',
              text: '임대료',
            ),
            const SizedBox(height: 20),
            ReportInputWidget(
              onChanged: (value) {
                setState(() {
                  loan = value;
                });
                inputCompleteConfirmation();
              },
              suffixText: '만원',
              text: '대출금',
            ),
            const SizedBox(height: 20),
            ReportInputWidget(
              onChanged: (value) {
                setState(() {
                  otherExpenses = value;
                });
                inputCompleteConfirmation();
              },
              suffixText: '만원',
              text: '기타경비',
            ),
            const SizedBox(height: 20),
            ReportInputWidget(
              onChanged: (value) {
                setState(() {
                  personnelExpenses = value;
                });
                inputCompleteConfirmation();
              },
              suffixText: '만원',
              text: '인건비',
            ),
            const SizedBox(height: 20),
            ReportInputWidget(
              onChanged: (value) {
                setState(() {
                  averageNumberOfWorkingDaysPerMonth = value;
                });
                inputCompleteConfirmation();
              },
              suffixText: '일',
              text: '월평균 근무일 수',
            ),
            const SizedBox(height: 20),
            ReportInputWidget(
              onChanged: (value) {
                setState(() {
                  theGoalIs = value;
                });
                inputCompleteConfirmation();
              },
              suffixText: '만원',
              text: '목표이익(월)',
            ),
            const SizedBox(height: 50),
            Center(
              child: NextButtonWidget(
                isComplete: isCompletedInput,
                onClick: () {
                  createReport();
                },
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
