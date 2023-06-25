// class Item {
//   List<AllItem> itemsList = [];

//   Item.fromJson(dynamic json) {
//     List<dynamic> itemList = json as List<dynamic>;
//     for (dynamic itemData in itemList) {
//       AllItem item = AllItem.fromJson(itemData);
//       itemsList.add(item);
//     }
//   }
// }

class AllItem {
  AllItem({
    this.itemId,
    this.name,
    this.image,
    this.category,
    this.itemFreezingTime,
    this.itemFridgeTime,
    this.itemUnit,
    this.fridgeItemId,
    this.lowStockReminder,
    this.lowStockReminderUnit,
    this.dailyConsumption,
    this.dailyConsumptionUnit,
    this.expiryReminder,
    this.userFreezingTime,
    this.userFridgeTime,
    this.quantity,
    this.quantityUnit,
    this.purchaseDate,
    this.expiryDate,
    this.isFrozen,
    this.stockId,
    this.status,
    this.recipeNames,
  });

  AllItem.fromJson(dynamic json) {
    itemId = json['ItemId'];
    name = json['Name'];
    image = json['Image'];
    category = json['Category'];
    itemFreezingTime = json['ItemFreezingTime'];
    itemFridgeTime = json['ItemFridgeTime'];
    itemUnit = json['ItemUnit'];
    fridgeItemId = json['FridgeItemId'];
    lowStockReminder = json['LowStockReminder'];
    lowStockReminderUnit = json['LowStockReminderUnit'];
    dailyConsumption = json['DailyConsumption'];
    dailyConsumptionUnit = json['DailyConsumptionUnit'];
    expiryReminder = json['ExpiryReminder'];
    userFreezingTime = json['UserFreezingTime'];
    userFridgeTime = json['UserFridgeTime'];
    quantity = json['Quantity'];
    quantityUnit = json['QuantityUnit'];
    purchaseDate = json['PurchaseDate'];
    expiryDate = json['ExpiryDate'];
    isFrozen = json['IsFrozen'];
    stockId = json['StockId'];
    status = json['Status'];
    recipeNames =
        json['RecipeNames'] != null ? json['RecipeNames'].cast<String>() : [];
  }
  int? itemId;
  String? name;
  dynamic image;
  String? category;
  String? itemUnit;
  dynamic itemFreezingTime;
  int? itemFridgeTime;
  int? fridgeItemId;
  double? lowStockReminder;
  String? lowStockReminderUnit;
  double? dailyConsumption;
  String? dailyConsumptionUnit;
  int? expiryReminder;
  dynamic userFreezingTime;
  int? userFridgeTime;
  double? quantity;
  String? quantityUnit;
  String? purchaseDate;
  String? expiryDate;
  bool? isFrozen;
  int? stockId;
  String? status;
  List<String>? recipeNames;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ItemId'] = itemId;
    map['Name'] = name;
    map['Image'] = image;
    map['Category'] = category;
    map['ItemFreezingTime'] = itemFreezingTime;
    map['ItemFridgeTime'] = itemFridgeTime;
    map['ItemUnit'] = itemUnit;
    map['FridgeItemId'] = fridgeItemId;
    map['LowStockReminder'] = lowStockReminder;
    map['LowStockReminderUnit'] = lowStockReminderUnit;
    map['DailyConsumption'] = dailyConsumption;
    map['DailyConsumptionUnit'] = dailyConsumptionUnit;
    map['ExpiryReminder'] = expiryReminder;
    map['UserFreezingTime'] = userFreezingTime;
    map['UserFridgeTime'] = userFridgeTime;
    map['Quantity'] = quantity;
    map['QuantityUnit'] = quantityUnit;
    map['PurchaseDate'] = purchaseDate;
    map['ExpiryDate'] = expiryDate;
    map['IsFrozen'] = isFrozen;
    map['StockId'] = stockId;
    map['Status'] = status;
    map['RecipeNames'] = recipeNames;
    return map;
  }
}
