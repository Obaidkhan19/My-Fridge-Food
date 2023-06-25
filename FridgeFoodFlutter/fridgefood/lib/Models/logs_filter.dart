class LogFilter {
  LogFilter({
    this.id,
    this.logData,
    this.date,
    this.quantity,
    this.userId,
    this.qunatityUnit,
    this.fridgeItemId,
    this.fridgeId,
    this.totalQuantity,
  });

  LogFilter.fromJson(dynamic json) {
    id = json['Id'];
    logData = json['LogData'];
    date = json['Date'];
    quantity = json['Quantity'];
    userId = json['UserId'];
    qunatityUnit = json['QunatityUnit'];
    fridgeItemId = json['FridgeItemId'];
    fridgeId = json['FridgeId'];
    totalQuantity = json['TotalQuantity'];
  }
  int? id;
  String? logData;
  String? date;
  double? quantity;
  int? userId;
  String? qunatityUnit;
  int? fridgeItemId;
  int? fridgeId;
  double? totalQuantity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = id;
    map['LogData'] = logData;
    map['Date'] = date;
    map['Quantity'] = quantity;
    map['UserId'] = userId;
    map['QunatityUnit'] = qunatityUnit;
    map['FridgeItemId'] = fridgeItemId;
    map['FridgeId'] = fridgeId;
    map['TotalQuantity'] = totalQuantity;
    return map;
  }
}
