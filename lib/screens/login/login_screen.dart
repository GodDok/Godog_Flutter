import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:godog/screens/login/services/login_service.dart';
import 'package:godog/widgets/password_input_widget.dart';

import '../../core/cache_manager.dart';
import '../../core/network_service.dart';
import '../../main.dart';
import '../../widgets/basic_text_button_widget.dart';
import '../join/join_step1_screen.dart';
import '../report/report_input_step1_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<void> navigate(BuildContext context) async {
    final isReportCompleted = await CacheManager().getReport();

    if (isReportCompleted != null && isReportCompleted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainPage(),
          fullscreenDialog: true,
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ReportInputStep1Screen(),
          fullscreenDialog: true,
        ),
      );
    }
  }

  String email = '';
  String password = '';
  bool obscureText = true;

  Future<void> login(email, password) async {
    try {
      final Dio dio = NetworkService.instance.dio;
      final LoginService loginService = LoginService(dio);
      final result = await loginService.postLogin(email, password);

      if (result.isSuccess) {
        final cacheManger = CacheManager();
        await cacheManger.saveAccessToken(result.result.accessToken);
        await cacheManger.saveRefreshToken(result.result.refreshToken);

        navigate(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result.message)));
      }
    } catch (e) {
      print("Error: $e");

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('에러가 발생했습니다.')));
    }
  }

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
      body: Padding(
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
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                floatingLabelStyle: TextStyle(color: Colors.blueAccent),
                labelText: '이메일',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            const SizedBox(height: 20.0),
            PasswordInputWidget(
              label: '비밀번호',
              passwordCheckObscureText: obscureText,
              suffixClick: (value) {
                setState(() {
                  obscureText = value; // 상태 동기화
                });
              },
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            const SizedBox(height: 20.0),
            BasicTextButtonWidget(
              text: '로그인',
              backgroundColor: getButtonColor(),
              textColor: Colors.white,
              onClick: () {
                login(email, password);
              },
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
    );
  }
}
