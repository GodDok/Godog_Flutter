import 'package:flutter/material.dart';

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
            const LinearProgressIndicator(
              value: 1.0,
              backgroundColor: Colors.grey,
              color: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              minHeight: 2.0,
              semanticsLabel: 'semanticsLabel',
              semanticsValue: 'semanticsValue',
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                const Text(
                  "마진율",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: '',
                          border: OutlineInputBorder(),
                          suffixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('%'),
                            ],
                          )),
                      onChanged: (value) {
                        setState(() {
                          marginRate = value;
                        });

                        inputCompleteConfirmation();
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  "총예산",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: '',
                          border: OutlineInputBorder(),
                          suffixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('만원'),
                            ],
                          )),
                      onChanged: (value) {
                        setState(() {
                          totalBudget = value;
                        });

                        inputCompleteConfirmation();
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  "임대료",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: '',
                          border: OutlineInputBorder(),
                          suffixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('만원'),
                            ],
                          )),
                      onChanged: (value) {
                        setState(() {
                          rent = value;
                        });

                        inputCompleteConfirmation();
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  "대출금",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: '',
                          border: OutlineInputBorder(),
                          suffixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('만원'),
                            ],
                          )),
                      onChanged: (value) {
                        setState(() {
                          loan = value;
                        });
                        inputCompleteConfirmation();
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  "기타경비",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: '',
                          border: OutlineInputBorder(),
                          suffixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('만원'),
                            ],
                          )),
                      onChanged: (value) {
                        setState(() {
                          otherExpenses = value;
                        });
                        inputCompleteConfirmation();
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  "인건비",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: '',
                          border: OutlineInputBorder(),
                          suffixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('만원'),
                            ],
                          )),
                      onChanged: (value) {
                        setState(() {
                          personnelExpenses = value;
                        });
                        inputCompleteConfirmation();
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  "월평균 근무일 수",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: '',
                          border: OutlineInputBorder(),
                          suffixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('일'),
                            ],
                          )),
                      onChanged: (value) {
                        setState(() {
                          averageNumberOfWorkingDaysPerMonth = value;
                        });
                        inputCompleteConfirmation();
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  "목표이일(월)",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: '',
                          border: OutlineInputBorder(),
                          suffixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('만원'),
                            ],
                          )),
                      onChanged: (value) {
                        setState(() {
                          theGoalIs = value;
                        });
                        inputCompleteConfirmation();
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: !isCompletedInput ? Colors.grey : Colors.blueAccent,
                  ),
                  child: IconButton(
                    onPressed: () {
   /*                   if (isCompletedInput) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ReportInputStep2Screen(),
                          ),
                        );
                      }*/
                    },
                    icon: const Icon(
                      Icons.arrow_forward_sharp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
