import 'package:flutter/material.dart';

import '../widgets/password_toggle_widget.dart';
import 'join_step1_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';
  bool obscureText = true;

  Color getButtonColor() {
    if (email.isNotEmpty && password.isNotEmpty) {
      return Colors.blue;
    } else {
      return Colors.grey;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/main_logo.png',
                    width: 65,
                    height: 65,
                  ),
                  const Text('창신',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                      )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: '이메일',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                  suffixIcon: PasswordToggle(
                    onChanged: (value) {
                      setState(() {
                        obscureText = value; // 상태 동기화
                      });
                    },
                  ),
                ),
                obscureText: obscureText,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              const SizedBox(height: 20.0),
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
                      backgroundColor: getButtonColor()),
                  onPressed: () {
                    // 로그인 버튼 눌렀을 때 실행할 동작
                  },
                  child: const Text(
                    '로그인',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      child: const Text('회원가입'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const JoinStep1Screen(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
