import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:godog/screens/join/services/join_service.dart';

import '../../core/cache_manager.dart';
import '../../core/network_service.dart';
import '../../widgets/basic_text_button_widget.dart';
import '../../widgets/progress_widget.dart';
import '../report/report_input_step1_screen.dart';

class JoinStep3Screen extends StatefulWidget {
  final String email, password;

  const JoinStep3Screen(this.email, this.password, {super.key});

  @override
  State<JoinStep3Screen> createState() => _JoinStep3ScreenState();
}

class _JoinStep3ScreenState extends State<JoinStep3Screen> {
  String selectedGender = "";
  String birthday = "";
  String birthDate = "";
  String name = "";

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
      if (gender == '남자') {
        selectedGender = "MALE";
      } else {
        selectedGender = "FEMALE";
      }
    });
  }

  Color getButtonColor() {
    if (birthday.isNotEmpty && selectedGender.isNotEmpty) {
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
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DatePickerWidget(
                  looping: false,
                  firstDate: DateTime(1900, 1, 1),
                  lastDate: DateTime(2030, 1, 1),
                  initialDate: DateTime.now(),
                  dateFormat: "dd-MMM-yyyy",
                  locale: DatePicker.localeFromString('en'),
                  onChange: (DateTime newDate, _) {
                    setState(() {
                      var month = newDate.month.toString();
                      var day = newDate.day.toString();

                      if (newDate.month.toString().length == 1) {
                        month = "0${newDate.month}";
                      }

                      if (newDate.day.toString().length == 1) {
                        day = "0${newDate.day}";
                      }

                      birthday = "${newDate.year}년 $month월 $day일";
                      birthDate = "${newDate.year}-$month-$day";
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
            const ProgressWidget(value: 1.0),
            const SizedBox(
              height: 30,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '다양한 정보 제공을 위해\n추가 정보를 선택해주세요.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
            ]),
            const SizedBox(
              height: 40,
            ),
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
                          const SizedBox(width: 5.0),
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
                    const SizedBox(width: 20.0),
                    GestureDetector(
                      onTap: () {
                        _selectGender('여자');
                      },
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: selectedGender == "FEMALE"
                                    ? Colors.blue
                                    : Colors.grey,
                                size: 14,
                              ),
                              const SizedBox(width: 5.0),
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
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
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
                        style: const TextStyle(
                          color: Colors.blueAccent,
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
                join(widget.email, widget.password, name, selectedGender,
                    birthDate);
              },
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
