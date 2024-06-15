import 'package:flutter/material.dart';

import '../../widgets/basic_text_button_widget.dart';
import '../../widgets/next_button_widget.dart';
import '../../widgets/password_input_widget.dart';
import '../../widgets/progress_widget.dart';
import 'join_step3_screen.dart';

class JoinStep2Screen extends StatefulWidget {
  final String email;

  const JoinStep2Screen(this.email, {super.key});

  @override
  State<JoinStep2Screen> createState() => _JoinStep2ScreenState();
}

class _JoinStep2ScreenState extends State<JoinStep2Screen> {
  String password = '';
  String passwordCheck = '';
  bool passwordObscureText = true;
  bool passwordCheckObscureText = true;

  bool checkPasswordMatch() {
    if (password.isNotEmpty && passwordCheck.isNotEmpty) {
      if (password == passwordCheck) {
        return true;
      } else {
        return false;
      }
    }

    return false;
  }

  bool isPasswordSettingComplete = false;

  Color getVerificationPasswordButtonColor() {
    if (isPasswordSettingComplete) return Colors.grey.shade100;
    if (checkPasswordMatch()) {
      return Colors.blue;
    } else {
      return Colors.grey;
    }
  }

  void flutterDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "비밀번호가 설정되었습니다.",
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
                        setState(() {
                          isPasswordSettingComplete = true;
                        });
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
            const ProgressWidget(value: 0.7),
            const SizedBox(
              height: 30,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '로그인에 사용할\n비밀번호를 입력해주세요.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            PasswordInputWidget(
              label: '비밀번호 입력',
              passwordCheckObscureText: passwordObscureText,
              suffixClick: (value) {
                setState(() {
                  passwordObscureText = value; // 상태 동기화
                });
              },
              onChanged: (value) {
                setState(() {
                  isPasswordSettingComplete = false;
                  password = value;
                });
              },
            ),
            const SizedBox(height: 20.0),
            PasswordInputWidget(
              label: '비밀번호 확인',
              passwordCheckObscureText: passwordCheckObscureText,
              suffixClick: (value) {
                setState(() {
                  passwordCheckObscureText = value; // 상태 동기화
                });
              },
              onChanged: (value) {
                setState(() {
                  isPasswordSettingComplete = false;
                  passwordCheck = value;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  '비밀번호 일치',
                  style: TextStyle(
                      fontSize: 12,
                      color: checkPasswordMatch() ? Colors.red : Colors.grey),
                ),
                const SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.check,
                  color: checkPasswordMatch() ? Colors.red : Colors.grey,
                  size: 10,
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            BasicTextButtonWidget(
              text: '확인',
              backgroundColor: getVerificationPasswordButtonColor(),
              textColor:
                  !isPasswordSettingComplete ? Colors.white : Colors.black,
              onClick: () {
                if (!isPasswordSettingComplete) flutterDialog();
              },
            ),
            Expanded(child: Container()),
            NextButtonWidget(
                isComplete: isPasswordSettingComplete,
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          JoinStep3Screen(widget.email, password),
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
