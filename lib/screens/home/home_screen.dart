import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:godog/core/network_service.dart';
import 'package:godog/models/policy_model.dart';
import 'package:godog/models/population_model.dart';
import 'package:godog/screens/home/services/home_service.dart';
import 'package:godog/screens/map/map_screen.dart';
import 'package:godog/widgets/home_widget/jindanbutton.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreen> {
  final List<String> xLabels = [
    "10대",
    "20대",
    "30대",
    "40대",
    "50대",
    "60대",
  ];

  final List<int> maleData = [];
  final List<int> femaleData = [];

  List<Content>? contents;
  PopulationData? populationData; // PopulationData 변수 추가
  int selectedYear = 2024; // 기본값을 2024년으로 설정
  List<int> availableYears = [2022, 2023, 2024]; // 선택 가능한 연도 리스트

  double yearRate = 0.0;
  double quarterRate = 0.0;

  getPolicys(String province) async {
    try {
      final Dio dio = Dio(BaseOptions(baseUrl: 'http://52.78.101.153:8081'));
      final HomeService homeService = HomeService(dio);
      final result = await homeService.getPolicys(province);

      if (result != null) {
        contents = result.content;
        setState(() {});
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

  getPopulation() async {
    try {
      final Dio dio = NetworkService.instance.dio;
      final HomeService homeService = HomeService(dio);
      final result = await homeService.getPopulation();

      if (result != null && result.isSuccess) {
        populationData = result; // PopulationData 저장
        updateDataForYear(selectedYear); // 기본 연도로 데이터 업데이트
        setState(() {});
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

  getBreakEven() async {
    try {
      final Dio dio = NetworkService.instance.dio;
      final HomeService homeService = HomeService(dio);
      final result = await homeService.getBreakEven();

      if (result != null && result.isSuccess) {
        marginRate = result.result.marginRate.toInt().toString();
        fixedExpenses = result.result.fixedExpenses.toInt().toString();
        breakEvenAmount = result.result.breakEvenAmount.toInt().toString();
        targetRevenue = result.result.targetRevenue.toInt().toString();
        minimumOperatingAmount =
            result.result.minimumOperatingAmount.toInt().toString();
        avgDailySalesForTargetProfit =
            result.result.avgDailySalesForTargetProfit.toInt().toString();

        setState(() {});
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

  getCountCity() async {
    try {
      final Dio dio = NetworkService.instance.dio;
      final HomeService homeService = HomeService(dio);
      final result = await homeService.getCountCity();

      if (result != null && result.isSuccess) {
        cityCount = result.result.toInt();
        setState(() {});
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

  getCountAverage() async {
    try {
      final Dio dio = NetworkService.instance.dio;
      final HomeService homeService = HomeService(dio);
      final result = await homeService.getCountAverage();

      if (result != null) {
        averageCount = result.result.toInt();
        setState(() {});
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

  getCompetitionRates() async {
    try {
      final Dio dio = NetworkService.instance.dio;
      final HomeService homeService = HomeService(dio);

      final yearRateResult = await homeService.getCompetitionYearRate();
      final quarterRateResult = await homeService.getCompetitionQuarterRate();

      final yearRateResultIsSuccess =
          yearRateResult != null && yearRateResult.isSuccess;
      final quarterRateResultIsSuccess =
          quarterRateResult != null && quarterRateResult.isSuccess;

      if (yearRateResultIsSuccess && quarterRateResultIsSuccess) {
        yearRate = yearRateResult.result == "NaN"
            ? 0.0
            : double.parse(yearRateResult.result);
        quarterRate = quarterRateResult.result == "NaN"
            ? 0.0
            : double.parse(quarterRateResult.result);
        setState(() {});
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

  void updateDataForYear(int year) {
    maleData.clear();
    femaleData.clear();
    if (populationData != null) {
      final list = populationData!.result
          .where((record) => record.yearAndMonth.contains(year.toString()))
          .toList();

      for (int i = 1; i < list.length - 1; i++) {
        maleData.add(list[i].maleCount);
        femaleData.add(list[i].femaleCount);
        int temp = 0;
        if (list[i].maleCount >= list[i].femaleCount) {
          temp = list[i].maleCount;
        } else {
          temp = list[i].femaleCount;
        }
        if (maxY <= temp) {
          maxY = temp;
        }
      }
    }
    maxY = roundUpToTenThousand(maxY);
    print(maxY);
    setState(() {});
  }

  int roundUpToTenThousand(int value) {
    int factor = 10000;
    return (value + factor - 1) ~/ factor * factor;
  }

  @override
  void initState() {
    super.initState();
    getPolicys("진주시");
    getPopulation();
    getBreakEven();
    getCountCity();
    getCountAverage();
    getCompetitionRates();
  }

  int maxY = 0;
  String marginRate = "";
  String breakEvenAmount = "";
  String targetRevenue = "";
  String fixedExpenses = "";
  String minimumOperatingAmount = "";
  String avgDailySalesForTargetProfit = "";
  int cityCount = 0;
  int averageCount = 0;

  String apptitle = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/images/main_logo.png',
                    width: 55,
                    height: 55,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    "창신",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const CustomButtonContainer(),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(242, 242, 242, 0.9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '분석 리포트',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.place_outlined),
                              GestureDetector(
                                child: const Text(
                                  '진주시 가좌동',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const MapScreen(),
                                      ));
                                },
                              )
                            ],
                          ),
                        ]),
                    const SizedBox(height: 15),
                    const Row(
                      children: [
                        Icon(Icons.accessibility_new_sharp, size: 30),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '유동인구 현황',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    DropdownButton<int>(
                      value: selectedYear,
                      items: availableYears.map((int year) {
                        return DropdownMenuItem<int>(
                          value: year,
                          child: Text(year.toString()),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        setState(() {
                          selectedYear = newValue!;
                          updateDataForYear(selectedYear);
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 400,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: maxY.toDouble(),
                          barTouchData: BarTouchData(
                            enabled: true, // Enable touch
                            touchTooltipData: BarTouchTooltipData(
                              // tooltipBgColor: Colors.blueGrey,
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                                String weekDay;
                                switch (group.x.toInt()) {
                                  case 0:
                                    weekDay = '10대미만';
                                    break;
                                  case 1:
                                    weekDay = '20대';
                                    break;
                                  case 2:
                                    weekDay = '30대';
                                    break;
                                  case 3:
                                    weekDay = '40대';
                                    break;
                                  case 4:
                                    weekDay = '50대';
                                    break;
                                  case 5:
                                    weekDay = '60대이상';
                                    break;
                                  default:
                                    throw Error();
                                }
                                return BarTooltipItem(
                                  '$weekDay\n${rod.toY - 1}',
                                  const TextStyle(color: Colors.white),
                                );
                              },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false, // 상단 타이틀을 숨깁니다.
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 60,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();
                                    if (index >= 0 && index < xLabels.length) {
                                      String label = xLabels[index];
                                      if (label == "10대미만") {
                                        label = "10대\n미만";
                                      } else if (label == "60대이상") {
                                        label = "60대\n이상";
                                      }

                                      return SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        space: 16, // 마진 설정
                                        child: Text(
                                          label,
                                          textAlign:
                                              TextAlign.center, // 레이블을 중앙 정렬
                                          style: const TextStyle(
                                            color: Colors.black, // 텍스트 색상 설정
                                            fontWeight:
                                                FontWeight.bold, // 텍스트 스타일 설정
                                          ),
                                        ),
                                      );
                                    }
                                    return const Text('');
                                  }),
                            ),
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 50,
                                interval: 10000,
                                getTitlesWidget: (value, meta) {
                                  return Text('${value.toInt()}');
                                },
                              ),
                            ),
                          ),
                          gridData: const FlGridData(
                            show: false,
                          ),
                          borderData: FlBorderData(
                            show: false, // 이 부분을 추가하여 그래프 외곽선을 숨깁니다.
                          ),
                          barGroups: List.generate(
                            maleData.length,
                            (index) => BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: maleData[index].toDouble(),
                                  color: Colors.blue,
                                  width: 10,
                                ),
                                BarChartRodData(
                                  toY: femaleData[index].toDouble(),
                                  color:
                                      const Color.fromARGB(255, 231, 112, 151),
                                  width: 10,
                                ),
                              ],
                              barsSpace: 4,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Icon(Icons.attach_money_rounded, size: 30),
                        Text('손익분기점(추정)결과',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    const Divider(
                      // 구분선 추가
                      color: Colors.grey, // 구분선의 색상을 설정합니다.
                      thickness: 1, // 구분선의 두께를 설정합니다.
                      height: 20, // 구분선 위 아래로 추가되는 공간의 높이입니다.
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              '∙ 공헌 이익률  :  ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '$marginRate%',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            const Text(
                              '∙ 고 정 비 계   :  ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '$fixedExpenses원',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            const Text(
                              '∙ 손익 분기점  :  ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '$breakEvenAmount만원',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            const Text(
                              '∙ 목표 매출액  :  ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '$targetRevenue만원',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.info_rounded,
                              color: Color(0xff2592C8),
                              size: 17,
                            ),
                            const SizedBox(width: 10),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff2592C8), // 기본색
                                ),
                                children: <TextSpan>[
                                  const TextSpan(text: '본 점포의 손익 분기점은 '),
                                  TextSpan(
                                    text: breakEvenAmount,
                                    style:
                                        const TextStyle(color: Colors.orange),
                                  ),
                                  const TextSpan(text: ' 만원입니다.'),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff2592C8)), // 기본 텍스트 스타일
                            children: <TextSpan>[
                              const TextSpan(text: '일 평균 '),
                              TextSpan(
                                text: '$minimumOperatingAmount만원',
                                style: const TextStyle(color: Colors.orange),
                              ),
                              const TextSpan(
                                  text:
                                      '(근무일 기준) 이상의 매출을 올려야 손실 없이 점포를 운영할 수 있습니다.'),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff2592C8)), // 기본 텍스트 스타일
                            children: <TextSpan>[
                              const TextSpan(text: '목표이익을 달성하기 위해서는 일 평균  '),
                              TextSpan(
                                text: '$avgDailySalesForTargetProfit만원',
                                style: const TextStyle(
                                    color: Colors.orange), // 숫자 부분 오렌지 색상 적용
                              ),
                              const TextSpan(text: '(근무일 기준) 이상의 매출을 올려야 합니다.'),
                            ],
                          ),
                        ),
                        const Divider(
                          // 구분선 추가
                          color: Colors.grey, // 구분선의 색상을 설정합니다.
                          thickness: 0.4, // 구분선의 두께를 설정합니다.
                          height: 20, // 구분선 위 아래로 추가되는 공간의 높이입니다.
                        ),
                        const Text(
                          '※ 본 내용은 고객이 입력한 근거를 기준으로 작성되었으며, 세금 및 추가정보 등으로 실제와 달라질 수 있으며, 법적효력을 갖는 유권해석이 아니므로 법적 책임소재의 증빙자료로 사용할 수 없음을 알려드립니다.',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Row(
                          children: [
                            Icon(Icons.house_rounded, size: 30),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '경쟁 업소 수',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          // 구분선 추가
                          color: Colors.grey, // 구분선의 색상을 설정합니다.
                          thickness: 1, // 구분선의 두께를 설정합니다.
                          height: 20, // 구분선 위 아래로 추가되는 공간의 높이입니다.
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 0.4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('업소수',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900)),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(cityCount.toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          width: 80,
                                          height: cityCount.toDouble() * 10,
                                          color: Colors.blue,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text('가좌동',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black)),
                                      ],
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(averageCount.toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          width: 80, // 막대의 너비
                                          height: averageCount.toDouble() *
                                              10, // 막대의 높이
                                          color: const Color.fromARGB(
                                              255, 73, 78, 83),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text('진주시 평균',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 0.4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('증감율',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 40),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        yearRate >= 0
                                            ? Image.asset(
                                                'assets/images/up_arrow.png',
                                                width: 70,
                                                height: 80)
                                            : Image.asset(
                                                'assets/images/down_arrow.png',
                                                width: 70,
                                                height: 80),
                                        const SizedBox(height: 20),
                                        Text(
                                          '${yearRate.toInt()}%',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10),
                                        const Text('작년대비 증감율',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    const SizedBox(width: 30),
                                    Column(
                                      children: [
                                        quarterRate >= 0
                                            ? Image.asset(
                                                'assets/images/up_arrow.png',
                                                width: 70,
                                                height: 80)
                                            : Image.asset(
                                                'assets/images/down_arrow.png',
                                                width: 70,
                                                height: 80),
                                        const SizedBox(height: 20),
                                        Text(
                                          '${quarterRate.toInt()}%',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10),
                                        const Text('분기별 증감율',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        const Row(
                          children: [
                            Icon(Icons.document_scanner, size: 30),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '창업 지원 정책',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.grey, // 구분선의 색상을 설정합니다.
                          thickness: 1, // 구분선의 두께를 설정합니다.
                        ),
                        policySection(contents),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _launchUrl(String urlString) async {
  final Uri url = Uri.parse(urlString);

  try {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $urlString';
    }
  } catch (e) {
    print('Exception caught: $e');
  }
}

Widget policySection(List<Content>? contents) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      contents != null
          ? ListView.builder(
              itemCount: contents.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    policyButton(contents[index]),
                    const SizedBox(height: 10),
                  ],
                );
              },
            )
          : const Text("No policies available", style: TextStyle(fontSize: 16)),
    ],
  );
}

Widget policyButton(Content content) {
  return GestureDetector(
    onTap: () => _launchUrl(content.url),
    child: Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(204, 243, 250, 254),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(content.title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 10),
            Text("지역명: ${content.institutionName}",
                style: const TextStyle(fontSize: 15, color: Colors.black)),
            const SizedBox(height: 10),
            Text("접수기간: ${content.deadlineForApplication}",
                style: const TextStyle(fontSize: 15, color: Colors.black)),
            const SizedBox(height: 10),
            Text("소관 기관: ${content.supplyLocation}",
                style: const TextStyle(fontSize: 15, color: Colors.black)),
          ],
        ),
      ),
    ),
  );
}
