import 'package:flutter/material.dart';
import 'package:godog/screens/report_input_step2_screen.dart';
import '../widgets/next_button_widget.dart';
import '../widgets/progress_widget.dart';

class ReportInputStep1Screen extends StatefulWidget {
  const ReportInputStep1Screen({super.key});

  @override
  State<ReportInputStep1Screen> createState() => _ReportInputStep1ScreenState();
}

class _ReportInputStep1ScreenState extends State<ReportInputStep1Screen> {
  bool isCompletedInput = false; // 입력 완료 상태 유무
  String? city = "경남";
  String? province;
  String? neighborhood;
  String? industry;

  var cityList = ["경남"];

  var provinceList = [
    "창원시",
    "진주시",
    "김해시",
    "양산시",
    "거제시",
    "통영시",
    "사천시",
    "밀양시",
    "의령군",
    "함안군"
  ];

  var neighborhoodList = [
    "성북동",
    "중앙동",
    "상봉동",
    "천전동",
    "상대동",
    "하대동",
    "상평동",
    "가호동",
    "신안동",
    "평거동"
  ];

  var industryList = [
    "소비",
    "음식",
    "수리・개인",
    "교육",
    "부동산",
    "예술・스포츠",
    "숙박",
    "과학・기술",
    "보건의료",
    "시설관리・임대"
  ];

  List<String> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = industryList;
  }

  String? detailIndustry;

  inputCompleteConfirmation() {
    // 입력 완료 여부 확인
    setState(() {
      isCompletedInput = (province ?? "").isNotEmpty &&
          (city ?? "").isNotEmpty &&
          (neighborhood ?? "").isNotEmpty &&
          (detailIndustry ?? "").isNotEmpty;
    });
  }

  void handleCitySelection(String city) {
    setState(() {
      this.city = city;
      province = null;
      neighborhood = null;
    });

    inputCompleteConfirmation();
  }

  void handleProvinceSelection(String province) {
    setState(() {
      this.province = province;
      neighborhood = null;
    });

    inputCompleteConfirmation();
  }

  void handleNeighborhoodSelection(String neighborhood) {
    setState(() {
      this.neighborhood = neighborhood;
    });

    inputCompleteConfirmation();
  }

  generateIndustry() {
    return industryList.map((tag) => getChip(tag)).toList();
  }

  selectDetailIndustry(String selectedIndustry) {
    setState(() {
      detailIndustry = selectedIndustry;
    });

    inputCompleteConfirmation();
  }

  getChip(name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            industry = name;
          });

          showModalBottomSheet(
              backgroundColor: Colors.white,
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter bottomState) {
                    return SizedBox(
                      height: 600,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: '상세 업종을 입력하세요',
                                border: const OutlineInputBorder(),
                                suffixIcon: GestureDetector(
                                  child: const Icon(
                                    Icons.search,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                bottomState(() {
                                  setState(() {
                                    filteredList = industryList
                                        .where((item) => item
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                        .toList();
                                  });
                                });
                              },
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Expanded(
                              child: ListView.separated(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        selectDetailIndustry(
                                            filteredList[index]);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        filteredList[index],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const Column(children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Divider(
                                              height: 1,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            )
                                          ]),
                                  itemCount: filteredList.length),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              });

          inputCompleteConfirmation();
        },
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: industry == name
                    ? Colors.blueAccent
                    : const Color(0xffe5e5e5)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                name,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: industry == name ? Colors.white : Colors.black),
              ),
            )),
      ),
    );
  }

  String? search;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: const Color(0xfff5f5f5),
        title: const Text(
          "지역 및 업종 선택",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const ProgressWidget(value: 0.5),
            const SizedBox(
              height: 30,
            ),
            Container(
              color: Colors.white,
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                            child: GestureDetector(
                                onTap: () {
                                  handleCitySelection(cityList[index]);
                                },
                                child: Text(
                                  cityList[index],
                                  style: TextStyle(
                                      color: city == cityList[index]
                                          ? Colors.blueAccent
                                          : Colors.black),
                                )));
                      },
                      itemCount: cityList.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        height: 10,
                      ),
                    ),
                  )),
                  const Stack(
                    alignment: Alignment.center,
                    children: [
                      VerticalDivider(
                        color: Colors.grey,
                        width: 1,
                      ),
                      Icon(Icons.play_arrow_sharp, color: Colors.blueAccent),
                    ],
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                            child: GestureDetector(
                                onTap: () {
                                  handleProvinceSelection(provinceList[index]);
                                },
                                child: Text(
                                  provinceList[index],
                                  style: TextStyle(
                                      color: province == provinceList[index]
                                          ? Colors.blueAccent
                                          : Colors.black),
                                )));
                      },
                      itemCount: provinceList.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        height: 10,
                      ),
                    ),
                  )),
                  const Stack(
                    alignment: Alignment.center,
                    children: [
                      VerticalDivider(
                        color: Colors.grey,
                        width: 1,
                      ),
                      Icon(Icons.play_arrow_sharp, color: Colors.blueAccent),
                    ],
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: province == null
                        ? const SizedBox()
                        : ListView.separated(
                            itemBuilder: (BuildContext context, int index) {
                              return Center(
                                  child: GestureDetector(
                                      onTap: () {
                                        handleNeighborhoodSelection(
                                            neighborhoodList[index]);
                                      },
                                      child: Text(
                                        neighborhoodList[index],
                                        style: TextStyle(
                                            color: neighborhood ==
                                                    neighborhoodList[index]
                                                ? Colors.blueAccent
                                                : Colors.black),
                                      )));
                            },
                            itemCount: neighborhoodList.length,
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(
                              height: 10,
                            ),
                          ),
                  )),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Row(
              children: [
                Text(
                  '희망업종선택',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: [...generateIndustry()],
            ),
            Expanded(child: Container()),
            NextButtonWidget(
                isComplete: isCompletedInput,
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReportInputStep2Screen(),
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
