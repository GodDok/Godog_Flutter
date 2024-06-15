import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:godog/screens/join/services/mail_service.dart';

import '../../core/network_service.dart';
import '../../widgets/basic_text_button_widget.dart';
import '../../widgets/next_button_widget.dart';
import '../../widgets/progress_widget.dart';
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

  late Dio dio;
  late MailService mailService;

  @override
  void initState() {
    super.initState();
    dio = NetworkService.instance.dio;
    mailService = MailService(dio);
  }

  Future<void> mailSend(email) async {
    try {
      final result = await mailService.postMailSend(email);

      if (result) {
        // 타이머 시작
        onStartPressed();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('에러가 발생했습니다.')));
      }
    } catch (e) {
      print("Error: $e");

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('에러가 발생했습니다.')));
    }
  }

  Future<void> mailCheck(email, authNum) async {
    try {
      final result = await mailService.postMailCheck(email, authNum);

      if (result) {
        // 인증 완료 처리
        flutterDialog();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('에러가 발생했습니다.')));
      }
    } catch (e) {
      print("Error: $e");

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('에러가 발생했습니다.')));
    }
  }

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
  Timer? timer;

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
    timer?.cancel();
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
    setState(() {
      isCompletedCertification = true;
    });
  }

  void flutterDialog() {
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
            const ProgressWidget(value: 0.3),
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
              keyboardType: TextInputType.emailAddress,
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
                keyboardType: TextInputType.number,
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
              BasicTextButtonWidget(
                text: '인증번호 받기',
                backgroundColor: getVerificationNumberButtonColor(),
                textColor: Colors.white,
                onClick: () {
                  // 이메일 인증 요청
                  mailSend(email);

                  setState(() {
                    isProgressCertification = true;
                  });
                },
              )
            else
              BasicTextButtonWidget(
                text: !isCompletedCertification ? '인증' : '완료',
                backgroundColor: getVerificationButtonColor(),
                textColor:
                    !isCompletedCertification ? Colors.white : Colors.black,
                onClick: () {
                  if (!isCompletedCertification) {
                    mailCheck(email, certificationNum);
                  }
                },
              ),
            Expanded(child: Container()),
            NextButtonWidget(
                isComplete: isCompletedCertification,
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JoinStep2Screen(email),
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
