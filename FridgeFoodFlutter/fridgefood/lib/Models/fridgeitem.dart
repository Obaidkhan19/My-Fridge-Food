import 'package:fridgefood/utils/utilities.dart';
import 'package:http/http.dart' as http;

class FridgeItem {
  FridgeItem({
    this.id,
    this.freezingTime,
    this.fridgeTime,
    this.expiryReminder,
    this.lowStockReminder,
    this.lowStockReminderUnit,
    this.dailyConsumption,
    this.dailyConsumptionUnit,
    this.fridgeId,
    this.itemId,
    this.itemUnit,
    this.category,
  });

  FridgeItem.fromJson(dynamic json) {
    id = json['Id'];
    freezingTime = json['FreezingTime'];
    fridgeTime = json['FridgeTime'];
    expiryReminder = json['ExpiryReminder'];
    lowStockReminder = json['LowStockReminder'];
    lowStockReminderUnit = json['LowStockReminderUnit'];
    dailyConsumption = json['DailyConsumption'];
    dailyConsumptionUnit = json['DailyConsumptionUnit'];
    fridgeId = json['FridgeId'];
    itemId = json['ItemId'];
    itemUnit = json['ItemUnit'];
    category = json['Category'];
  }
  int? id;
  int? freezingTime;
  int? fridgeTime;
  int? expiryReminder;
  double? lowStockReminder;
  String? lowStockReminderUnit;
  double? dailyConsumption;
  String? dailyConsumptionUnit;
  int? fridgeId;
  int? itemId;
  String? itemUnit;
  String? category;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = id;
    map['FreezingTime'] = freezingTime;
    map['FridgeTime'] = fridgeTime;
    map['ExpiryReminder'] = expiryReminder;
    map['LowStockReminder'] = lowStockReminder;
    map['LowStockReminderUnit'] = lowStockReminderUnit;
    map['DailyConsumption'] = dailyConsumption;
    map['DailyConsumptionUnit'] = dailyConsumptionUnit;
    map['FridgeId'] = fridgeId;
    map['ItemId'] = itemId;
    map['ItemUnit'] = itemUnit;
    map["Category"] = category;
    return map;
  }

  Future<String?> editDetail() async {
    String url =
        '$ip/FridgeItem/EditItemDetail?fiid=$itemId&expiryreminderdays=$expiryReminder&dailyuse=$dailyConsumption&dailyuseunit=$dailyConsumptionUnit&lowstock=$lowStockReminder&lowstockunit=$lowStockReminderUnit&unit=$itemUnit';
    Uri uri = Uri.parse(url);
    var response = await http.post(uri);
    if (response.statusCode == 200) {
      return response.body;
    }

    return null;
  }
}
