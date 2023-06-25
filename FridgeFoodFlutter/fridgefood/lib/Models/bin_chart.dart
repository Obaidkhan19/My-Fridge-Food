class Chart {
  Chart({
    this.fridgeItemId,
    this.totalQuantity,
    this.name,
    this.quantityUnit,
  });

  Chart.fromJson(dynamic json) {
    fridgeItemId = json['FridgeItemId'];
    totalQuantity = json['TotalQuantity'];
    name = json['Name'];
    quantityUnit = json['QuantityUnit'];
  }
  int? fridgeItemId;
  double? totalQuantity;
  String? name;
  String? quantityUnit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['FridgeItemId'] = fridgeItemId;
    map['TotalQuantity'] = totalQuantity;
    map['Name'] = name;
    map['QuantityUnit'] = quantityUnit;
    return map;
  }
}
