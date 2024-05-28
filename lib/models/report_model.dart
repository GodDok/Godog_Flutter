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
      : marginRate = json['marginRate'].toString(),
        totalBudget = json['totalBudget'].toString(),
        rent = json['rent'].toString(),
        loanAmount = json['loanAmount'].toString(),
        otherExpenses = json['otherExpenses'].toString(),
        wages = json['wages'].toString(),
        avgWorkingDaysPerMonth = json['avgWorkingDaysPerMonth'].toString(),
        monthlyProfitTarget = json['monthlyProfitTarget'].toString(),
        location = json['location'].toString(),
        city = json['city'].toString(),
        district = json['district'].toString(),
        category = json['category'].toString(),
        subcategory = json['subcategory'].toString(),
        type = json['type'].toString();
}
