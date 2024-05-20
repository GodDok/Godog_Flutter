class ReportModel {
  final bool isSuccess;
  final String code;
  final String message;
  final Result result;

  ReportModel.fromJson(Map<String, dynamic> json)
      : isSuccess = json['isSuccess'],
        code = json['code'],
        message = json['message'],
        result = Result.fromJson(json['result']);
}

class Result {
  final String marginRate;
  final String totalBudget;
  final String rent;
  final String loanAmount;
  final String otherExpenses;
  final String wages;
  final String avgWorkingDaysPerMonth;
  final String monthlyProfitTarget;
  final String location;
  final String city;
  final String district;
  final String category;
  final String subcategory;
  final String type;

  Result.fromJson(Map<String, dynamic> json)
      : marginRate = json['marginRate'],
        totalBudget = json['totalBudget'],
        rent = json['rent'],
        loanAmount = json['loanAmount'],
        otherExpenses = json['otherExpenses'],
        wages = json['wages'],
        avgWorkingDaysPerMonth = json['avgWorkingDaysPerMonth'],
        monthlyProfitTarget = json['monthlyProfitTarget'],
        location = json['location'],
        city = json['city'],
        district = json['district'],
        category = json['category'],
        subcategory = json['subcategory'],
        type = json['type'];
}
