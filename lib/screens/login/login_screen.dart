import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:godog/screens/login/services/login_service.dart';
import 'package:godog/widgets/password_input_widget.dart';
import '../../core/cache_manager.dart';
import '../../core/network_service.dart';
import '../../widgets/basic_text_button_widget.dart';
import '../join/join_step1_screen.dart';
import '../report/report_input_step1_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';
  bool obscureText = true;

  Future<void> login(email, password) async {
    final Dio dio = NetworkService.instance.dio;
    final LoginService loginService = LoginService(dio);
    final result = await loginService.postLogin(email, password);

    final cacheManger = CacheManager();
    cacheManger.saveAccessToken(result.result.accessToken);
    cacheManger.saveRefreshToken(result.result.refreshToken);

    print("로그인 성공");

    // 화면 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReportInputStep1Screen(),
      ),
    );
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