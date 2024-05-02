import 'dart:async';

import 'package:flutter/material.dart';

import 'join_step2_screen.dart';

class JoinStep1Screen extends StatefulWidget {
  const JoinStep1Screen({super.key});

  @override
  State<JoinStep1Screen> createState() => _JoinStep1ScreenState();
}

class _JoinStep1ScreenState extends State<JoinStep1Screen> {
  String email = '';
  String certificationNum = ''; // 인증번호
  bool isProgressCertification = false; // 인증 진행 상태 유무
  bool isCompletedCertification = false; // 인증 완료 상태 유무

  Color getVerificationNumberButtonColor() {
    if (email.isNotEmpty) {
      return Colors.blue;
    } else {
      return Colors.grey;
    }
  }

  Color getVerificationButtonColor() {
    if (isCompletedCertification) {
      return Colors.grey.shade100;
    }
    if (certificationNum.isNotEmpty) {
      return Colors.blue;
    } else {
      return Colors.grey;
    }
  }

  // 타이머
  static const threeMinutes = 180;
  int totalSeconds = threeMinutes;
  bool isRunning = false;
  late Timer timer;

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        if (!isCompletedCertification) isProgressCertification = false;
        certificationNum = '';
        isRunning = false;
        totalSeconds = 180;
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds -= 1;
      });
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );

    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel();
    isRunning = false;
    totalSeconds = 180;
  }

  String format(int seconds) {
    var duration =
        Duration(seconds: seconds).toString().split(".").first.substring(2);

    return duration;
  }

  // 인증 번호 확인
  certificationConfirmation() {
    // 인증 확인 로직 추가할 예정
    setState(() {
      isCompletedCertification = true;
    });
  }

  void FlutterDialog() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "인증되었습니다.",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      child: const Text(
                        "확인",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        certificationConfirmation();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

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
              value: 0.3,
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '로그인에 사용할\n아이디를 입력해주세요.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: '아이디(이메일) 입력',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                onPausePressed();

                setState(() {
                  email = value;
                  certificationNum = '';
                  isProgressCertification = false;
                  isCompletedCertification = false;
                });
              },
            ),
            const SizedBox(height: 20.0),
            if (isProgressCertification)
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '인증번호 입력',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    certificationNum = value;
                  });
                },
              ),
            if (isProgressCertification && !isCompletedCertification)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    '남은 시간 ',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    format(totalSeconds),
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20.0),
            if (!isProgressCertification)
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      backgroundColor: getVerificationNumberButtonColor()),
                  onPressed: () {
                    // 이메일 인증 보내기 요청할 예정
                    onStartPressed();

                    setState(() {
                      isProgressCertification = true;
                    });
                  },
                  child: const Text(
                    '인증번호 받기',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      backgroundColor: getVerificationButtonColor()),
                  onPressed: () {
                    if (!isCompletedCertification) FlutterDialog();
                  },
                  child: Text(
                    !isCompletedCertification ? '인증' : '완료',
                    style: TextStyle(
                        color: !isCompletedCertification
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: !isCompletedCertification
                        ? Colors.grey
                        : Colors.blueAccent,
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (isCompletedCertification) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const JoinStep2Screen(),
                          ),
                        );
                      }
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
