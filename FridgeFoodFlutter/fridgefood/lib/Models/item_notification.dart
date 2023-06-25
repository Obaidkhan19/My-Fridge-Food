class ItemNotification {
  ItemNotification({
    this.name,
    this.quantity,
    this.quantityUnit,
    this.expiryDate,
    this.stockId,
    this.status,
    this.fridgeItemId,
    this.recipeNames,
  });

  ItemNotification.fromJson(dynamic json) {
    name = json['Name'];
    quantity = json['Quantity'];
    quantityUnit = json['QuantityUnit'];
    expiryDate = json['ExpiryDate'];
    stockId = json['StockId'];
    status = json['Status'];
    fridgeItemId = json['FridgeItemId'];
    recipeNames =
        json['RecipeNames'] != null ? json['RecipeNames'].cast<String>() : [];
  }
  String? name;
  double? quantity;
  dynamic? quantityUnit;
  String? expiryDate;
  int? stockId;
  String? status;
  int? fridgeItemId;
  List<String>? recipeNames;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Name'] = name;
    map['Quantity'] = quantity;
    map['QuantityUnit'] = quantityUnit;
    map['ExpiryDate'] = expiryDate;
    map['StockId'] = stockId;
    map['Status'] = status;
    map['FridgeItemId'] = fridgeItemId;
    map['RecipeNames'] = recipeNames;
    return map;
  }
}
