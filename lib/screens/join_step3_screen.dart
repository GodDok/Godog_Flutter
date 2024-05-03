import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class JoinStep3Screen extends StatefulWidget {
  const JoinStep3Screen({super.key});

  @override
  State<JoinStep3Screen> createState() => _JoinStep3ScreenState();
}

class _JoinStep3ScreenState extends State<JoinStep3Screen> {
  String selectedGender = "";
  String birthday = "";

  void _selectGender(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  Color getButtonColor() {
    if (birthday.isNotEmpty && selectedGender.isNotEmpty) {
      return Colors.blue;
    } else {
      return Colors.grey;
    }
  }

  void FlutterDialog() {
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
                      birthday = "${newDate.year}년 ${newDate.month}월 ${newDate.day}일";
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
                            color: selectedGender == '남자'
                                ? Colors.blue
                                : Colors.grey,
                            size: 14,
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            '남자',
                            style: TextStyle(
                              color: selectedGender == '남자'
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
                                color: selectedGender == '여자'
                                    ? Colors.blue
                                    : Colors.grey,
                                size: 14,
                              ),
                              const SizedBox(width: 5.0),
                              Text(
                                '여자',
                                style: TextStyle(
                                  color: selectedGender == '여자'
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
                  onTap: FlutterDialog,
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
                  '확인',
                  style: TextStyle(color: Colors.white),
                ),
              ),
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
