class Log {
  Log({
    this.id,
    this.logData,
    this.date,
    this.fridgeId,
    this.itemId,
    this.quantity,
    this.quantityUnit,
    this.userId,
  });

  Log.fromJson(dynamic json) {
    id = json['Id'];
    logData = json['LogData'];
    date = json['Date'];
    fridgeId = json['FridgeId'];
    itemId = json['ItemId'];
    quantity = json['Quantity'];
    quantityUnit = json['QuantityUnit'];
    userId = json['UserId'];
  }
  int? id;
  String? logData;
  String? date;
  int? fridgeId;
  int? itemId;
  double? quantity;
  dynamic quantityUnit;
  int? userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = id;
    map['LogData'] = logData;
    map['Date'] = date;
    map['FridgeId'] = fridgeId;
    map['ItemId'] = itemId;
    map['Quantity'] = quantity;
    map['QuantityUnit'] = quantityUnit;
    map['UserId'] = userId;
    return map;
  }
}
