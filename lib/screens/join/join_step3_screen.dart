import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:dio/dio.dart';

import '../../core/cache_manager.dart';
import '../../core/network_service.dart';
import '../../widgets/basic_text_button_widget.dart';
import '../../widgets/progress_widget.dart';
import '../report/report_input_step1_screen.dart';
import 'services/join_service.dart';

class JoinStep3Screen extends StatefulWidget {
  final String email, password;

  const JoinStep3Screen(this.email, this.password, {Key? key}) : super(key: key);

  @override
  State<JoinStep3Screen> createState() => _JoinStep3ScreenState();
}

class _JoinStep3ScreenState extends State<JoinStep3Screen> {
  String selectedGender = "";
  String birthday = "날짜를 선택해주세요"; // 초기 문구 설정
  String birthDate = "";
  String name = "";
  DateTime? selectedDate; // 선택된 날짜를 저장할 변수

  Future<void> join(String email, String password, String name, String gender,
      String birthDate) async {
    try {
      final Dio dio = NetworkService.instance.dio;
      final JoinService joinService = JoinService(dio);
      final result = await joinService.postSignup(
          email, password, name, gender, birthDate);

      if (result.isSuccess) {
        final cacheManger = CacheManager();
        await cacheManger.saveAccessToken(result.result.accessToken);
        await cacheManger.saveRefreshToken(result.result.refreshToken);

        // 화면 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ReportInputStep1Screen(),
          ),
        );
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

  void _selectGender(String gender) {
    setState(() {
      selectedGender = gender == '남자' ? "MALE" : "FEMALE";
    });
  }

  Color getButtonColor() {
    return (selectedDate != null && selectedGender.isNotEmpty)
        ? Colors.blue
        : Colors.grey;
  }

  void flutterDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DatePickerWidget(
                looping: false,
                firstDate: DateTime(1900, 1, 1),
                lastDate: DateTime(2030, 1, 1),
                initialDate: selectedDate ?? DateTime.now(), // 초기 선택된 날짜 설정
                dateFormat: "dd-MMM-yyyy",
                locale: DatePicker.localeFromString('ko'), // 한글로 설정
                onChange: (DateTime newDate, _) {
                  setState(() {
                    selectedDate = newDate; // 선택된 날짜 업데이트
                  });
                },
                pickerTheme: const DateTimePickerTheme(
                  backgroundColor: Colors.white,
                  itemTextStyle: TextStyle(color: Colors.black, fontSize: 19),
                  dividerColor: Colors.blue,
                ),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  final newDate = selectedDate ?? DateTime.now();

                  var month = newDate.month.toString().padLeft(2, '0');
                  var day = newDate.day.toString().padLeft(2, '0');

                  birthday = "${newDate.year}년 $month월 $day일";
                  birthDate = "${newDate.year}-$month-$day";
                });
              },
              child: const Text(
                "확인",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
            const ProgressWidget(value: 1.0),
            const SizedBox(height: 30),
            const Text(
              '다양한 정보 제공을 위해\n추가 정보를 선택해주세요.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '이름',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 150,
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: '',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '성별',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _selectGender('남자');
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: selectedGender == "MALE"
                                ? Colors.blue
                                : Colors.grey,
                            size: 14,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '남자',
                            style: TextStyle(
                              color: selectedGender == "MALE"
                                  ? Colors.blue
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        _selectGender('여자');
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: selectedGender == "FEMALE"
                                ? Colors.blue
                                : Colors.grey,
                            size: 14,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '여자',
                            style: TextStyle(
                              color: selectedGender == "FEMALE"
                                  ? Colors.blue
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '출생년도',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: flutterDialog,
                  child: Container(
                    height: 30,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        birthday,
                        style: TextStyle(
                          color: selectedDate != null
                              ? Colors.blueAccent
                              : Colors.black54,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Expanded(child: Container()),
            BasicTextButtonWidget(
              text: '확인',
              backgroundColor: getButtonColor(),
              textColor: Colors.white,
              onClick: () {
                if (selectedDate != null && selectedGender.isNotEmpty) {
                  join(widget.email, widget.password, name, selectedGender,
                      birthDate);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('정보를 모두 입력해주세요.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
