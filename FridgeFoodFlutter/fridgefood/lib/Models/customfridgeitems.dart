import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fridgefood/utils/utilities.dart';

class CustomFridgeItem {
  CustomFridgeItem({
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
    this.name,
    this.image,
    this.itemUnit,
    this.category,
  });

  CustomFridgeItem.fromJson(dynamic json) {
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
    name = json['Name'];
    image = json['Image'];
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
  String? name;
  String? image;
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
    map['Name'] = name;
    map['Image'] = image;
    map['ItemUnit'] = itemUnit;
    map['Category'] = category;
    return map;
  }

  Future<String?> addCustomItem(
    File f,
    String name,
    String itemUnit,
    String category,
    int fridgeTime,
    int expiryReminder,
    lowStockReminder,
    String? lowStockReminderUnit,
    String dailyConsumption,
    String? dailyConsumptionUnit,
    int fridgeId,
  ) async {
    String url = '$ip/fridgeitem/AddCustomItem';
    Uri uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);
    http.MultipartFile newfile =
        await http.MultipartFile.fromPath('Image', f.path);
    request.files.add(newfile);
    request.fields['Name'] = name;
    request.fields['ItemUnit'] = itemUnit;
    request.fields['Category'] = category;
    request.fields['FridgeTime'] = fridgeTime.toString();
    request.fields['ExpiryReminder'] = expiryReminder.toString();
    request.fields['LowStockReminder'] = lowStockReminder;
    // request.fields['LowStockReminderUnit'] = lowStockReminderUnit;
    // request.fields['DailyConsumption'] = dailyConsumption;
    // request.fields['DailyConsumptionUnit'] = dailyConsumptionUnit;
    request.fields['DailyConsumption'] = dailyConsumption;
    if (lowStockReminderUnit != null) {
      request.fields['LowStockReminderUnit'] = lowStockReminderUnit;
    }

    if (dailyConsumptionUnit != null) {
      request.fields['DailyConsumptionUnit'] = dailyConsumptionUnit;
    }
    request.fields['FridgeId'] = fridgeId.toString();

    var response = await request.send();
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      return responseBody;
    } else {
      return null;
    }
  }

  Future<String?> editItem(
      File? f,
      String name,
      String itemUnit,
      String category,
      int fridgeTime,
      int expiryReminder,
      String lowStockReminder,
      String? lowStockReminderUnit,
      String dailyConsumption,
      String? dailyConsumptionUnit,
      int fridgeId,
      int id) async {
    String url = '$ip/fridgeitem/EditItem';
    Uri uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);

    http.MultipartFile? newfile;
    if (f != null && await f.exists()) {
      newfile = await http.MultipartFile.fromPath('Image', f.path);
    } else {
      // handle case where file does not exist
    }
    if (newfile != null) {
      request.files.add(newfile);
    }

    request.fields['Id'] = id.toString();
    request.fields['Name'] = name;
    request.fields['ItemUnit'] = itemUnit;
    request.fields['Category'] = category;
    request.fields['FridgeTime'] = fridgeTime.toString();
    request.fields['ExpiryReminder'] = expiryReminder.toString();
    request.fields['LowStockReminder'] = lowStockReminder;
    // request.fields['LowStockReminderUnit'] = lowStockReminderUnit;
    // request.fields['DailyConsumption'] = dailyConsumption;
    // request.fields['DailyConsumptionUnit'] = dailyConsumptionUnit;
    request.fields['DailyConsumption'] = dailyConsumption;
    if (lowStockReminderUnit != null) {
      request.fields['LowStockReminderUnit'] = lowStockReminderUnit;
    }

    if (dailyConsumptionUnit != null) {
      request.fields['DailyConsumptionUnit'] = dailyConsumptionUnit;
    }
    request.fields['FridgeId'] = fridgeId.toString();
    var response = await request.send();
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      return responseBody;
    } else {
      return null;
    }
  }
}
