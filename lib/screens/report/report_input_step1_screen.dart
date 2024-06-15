import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:godog/screens/report/report_input_step2_screen.dart';
import 'package:godog/screens/report/services/report_service.dart';

import '../../core/network_service.dart';
import '../../widgets/next_button_widget.dart';
import '../../widgets/progress_widget.dart';

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

  var neighborhoodList = [];

  // 대분류 업종
  var category = [
    "과학·기술",
    "교육",
    "보건의료",
    "부동산",
    "소매",
    "수리·개인",
    "숙박",
    "시설관리·임대",
    "예술·스포츠",
    "음식"
  ];

  // 소분류 업종
  var industryList = [""];

  List<String> filteredList = [];

  final Dio dio = NetworkService.instance.dio;

  getCity() async {
    try {
      final ReportService reportService = ReportService(dio);
      final cityResult = await reportService.getCity();

      if (cityResult.isSuccess) {
        setState(() {
          provinceList = cityResult.result;
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(cityResult.message)));
      }
    } catch (e) {
      print("Error: $e");

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('에러가 발생했습니다.')));
    }
  }

  getCategory() async {
    try {
      final ReportService reportService = ReportService(dio);
      final categoryResult = await reportService.getCategory();

      if (categoryResult.isSuccess) {
        setState(() {
          category = categoryResult.result;
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(categoryResult.message)));
      }
    } catch (e) {
      print("Error: $e");

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('에러가 발생했습니다.')));
    }
  }

  @override
  initState() {
    super.initState();
    getCity();
    getCategory();
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
      neighborhoodList = [];
      neighborhood = null;
    });

    inputCompleteConfirmation();
  }

  getDistrict(String province) async {
    try {
      final ReportService reportService = ReportService(dio);
      final districtResult = await reportService.getDistrict(province);

      if (districtResult.isSuccess) {
        setState(() {
          neighborhoodList = districtResult.result;
        });
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

  void handleProvinceSelection(String province) {
    getDistrict(province);

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
    return category.map((tag) => getChip(tag)).toList();
  }

  selectDetailIndustry(String selectedIndustry) {
    setState(() {
      detailIndustry = selectedIndustry;
    });

    inputCompleteConfirmation();
  }

  getStore(String type) async {
    try {
      final ReportService reportService = ReportService(dio);
      var result = await reportService.getStore(type);

      if (result.isSuccess) {
        setState(() {
          industryList = result.result;
          filteredList = industryList;

          showModalBottomSheet(
              backgroundColor: Colors.white,
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter bottomState) {
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: '상세 업종을 입력하세요',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              suffixIcon: Icon(Icons.search),
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
                          const SizedBox(height: 20),
                          Expanded(
                            child: ListView.separated(
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    selectDetailIndustry(filteredList[index]);
                                    Navigator.pop(context);
                                  },
                                  child: ListTile(
                                    title: Text(filteredList[index],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600)),
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                              itemCount: filteredList.length,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              });
        });
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

  getChip(name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            getStore(name);
            industry = name;
          });

          inputCompleteConfirmation();
        },
        child: Chip(
          label: Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: industry == name ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor:
              industry == name ? Colors.blueAccent : const Color(0xffe5e5e5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  String? search;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "지역 및 업종 선택",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const ProgressWidget(value: 0.5),
            const SizedBox(height: 30),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(10),
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
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
                                      : Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: cityList.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 10),
                      ),
                    ),
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
                                      : Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: provinceList.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 10),
                      ),
                    ),
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
                                            : Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: neighborhoodList.length,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const SizedBox(height: 10),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
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
            const SizedBox(height: 10),
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
                    builder: (context) => ReportInputStep2Screen(
                        "경남",
                        this.province!,
                        this.neighborhood!,
                        this.detailIndustry!),
                  ),
                );
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
