class BreakEvenData {
  bool isSuccess;
  String code;
  String message;
  BreakEvenResult result;

  BreakEvenData({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  factory BreakEvenData.fromJson(Map<String, dynamic> json) {
    return BreakEvenData(
      isSuccess: json['isSuccess'],
      code: json['code'],
      message: json['message'],
      result: BreakEvenResult.fromJson(json['result']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'code': code,
      'message': message,
      'result': result.toJson(),
    };
  }
}

class BreakEvenResult {
  double marginRate;
  double fixedExpenses;
  double breakEvenAmount;
  double targetRevenue;
  double minimumOperatingAmount;
  double avgDailySalesForTargetProfit;

  BreakEvenResult({
    required this.marginRate,
    required this.fixedExpenses,
    required this.breakEvenAmount,
    required this.targetRevenue,
    required this.minimumOperatingAmount,
    required this.avgDailySalesForTargetProfit,
  });

  factory BreakEvenResult.fromJson(Map<String, dynamic> json) {
    return BreakEvenResult(
      marginRate: json['marginRate'].toDouble(),
      fixedExpenses: json['fixedExpenses'].toDouble(),
      breakEvenAmount: json['breakEvenAmount'].toDouble(),
      targetRevenue: json['targetRevenue'].toDouble(),
      minimumOperatingAmount: json['minimumOperatingAmount'].toDouble(),
      avgDailySalesForTargetProfit:
          json['avgDailySalesForTargetProfit'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'marginRate': marginRate,
      'fixedExpenses': fixedExpenses,
      'breakEvenAmount': breakEvenAmount,
      'targetRevenue': targetRevenue,
      'minimumOperatingAmount': minimumOperatingAmount,
      'avgDailySalesForTargetProfit': avgDailySalesForTargetProfit,
    };
  }
}
