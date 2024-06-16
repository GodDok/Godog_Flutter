import 'package:flutter/material.dart';
import '../../widgets/basic_text_button_widget.dart';
import '../../widgets/next_button_widget.dart';
import '../../widgets/password_input_widget.dart';
import '../../widgets/progress_widget.dart';
import 'join_step3_screen.dart';

class JoinStep2Screen extends StatefulWidget {
  final String email;

  const JoinStep2Screen(this.email, {Key? key}) : super(key: key);

  @override
  _JoinStep2ScreenState createState() => _JoinStep2ScreenState();
}

class _JoinStep2ScreenState extends State<JoinStep2Screen> {
  String password = '';
  String passwordCheck = '';
  bool passwordObscureText = true;
  bool passwordCheckObscureText = true;
  bool isPasswordSettingComplete = false;

  bool checkPasswordMatch() {
    if (password.isNotEmpty && passwordCheck.isNotEmpty) {
      return password == passwordCheck;
    }
    return false;
  }

  void showPasswordConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "비밀번호가 설정되었습니다.",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
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
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        isPasswordSettingComplete = true;
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      "확인",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
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
            ProgressWidget(value: 0.7),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '로그인에 사용할\n비밀번호를 입력해주세요.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 20),
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
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '비밀번호 일치',
                  style: TextStyle(fontSize: 12, color: checkPasswordMatch() ? Colors.red : Colors.grey),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.check,
                  color: checkPasswordMatch() ? Colors.red : Colors.grey,
                  size: 10,
                )
              ],
            ),
            SizedBox(height: 10),
            BasicTextButtonWidget(
              text: '확인',
              backgroundColor: getVerificationPasswordButtonColor(),
              textColor: isPasswordSettingComplete ? Colors.black : Colors.white,
              onClick: () {
                if (!isPasswordSettingComplete) {
                  showPasswordConfirmationDialog();
                }
              },
            ),
            Expanded(child: Container()),
            NextButtonWidget(
              isComplete: isPasswordSettingComplete,
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JoinStep3Screen(widget.email, password),
                  ),
                );
              },
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Color getVerificationPasswordButtonColor() {
    if (isPasswordSettingComplete) {
      return Colors.grey.shade100;
    }
    if (checkPasswordMatch()) {
      return Colors.blueAccent;
    } else {
      return Colors.grey;
    }
  }
}
