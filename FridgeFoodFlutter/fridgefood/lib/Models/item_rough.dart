import 'package:http/http.dart' as http;
import 'package:fridgefood/utils/utilities.dart';
import 'dart:io';

class item {
  item({
    this.id,
    this.name,
    this.category,
    this.image,
    this.freezTime,
    this.expiryReminder,
    this.lowStockReminder,
    this.lowStockReminderUnit,
    this.dailyConsumption,
    this.dailyConsumptionUnit,
    this.fridgeId,
    this.itemunit,
  });

  item.fromJson(dynamic json) {
    id = json['Id'];
    name = json['Name'];
    category = json['Category'];
    image = json['Image'];
    freezTime = json['FreezTime'];
    expiryReminder = json['ExpiryReminder'];
    lowStockReminder = json['LowStockReminder'];
    lowStockReminderUnit = json['LowStockReminderUnit'];
    dailyConsumption = json['DailyConsumption'];
    dailyConsumptionUnit = json['DailyConsumptionUnit'];
    fridgeId = json['FridgeId'];
    itemunit = json['ItemUnit'];
  }
  int? id;
  String? name;
  String? category;
  String? image;
  int? freezTime;
  double? lowStockReminder;
  String? lowStockReminderUnit;
  int? expiryReminder;
  double? dailyConsumption;
  String? dailyConsumptionUnit;
  int? fridgeId;
  String? itemunit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = id;
    map['Name'] = name;
    map['Category'] = category;
    map['Image'] = image;
    map['FreezTime'] = freezTime;
    map['ExpiryReminder'] = expiryReminder;
    map['LowStockReminder'] = lowStockReminder;
    map['LowStockReminderUnit'] = lowStockReminderUnit;
    map['DailyConsumption'] = dailyConsumption;
    map['DailyConsumptionUnit'] = dailyConsumptionUnit;
    map['FridgeId'] = fridgeId;
    map['ItemUnit'] = itemunit;
    return map;
  }

  // Future<String?> addItem(File f, item fridgeitem) async {
  //   String url = '$ip/FridgeItem/FridgeItemAdd';
  //   Uri uri = Uri.parse(url);
  //   var request = http.MultipartRequest('POST', uri);
  //   http.MultipartFile newfile =
  //       await http.MultipartFile.fromPath('Image', f.path);
  //   request.files.add(newfile);
  //   request.fields['Name'] = fridgeitem.name!;
  //   request.fields['Category'] = fridgeitem.category!;
  //   request.fields['FreezTime'] = fridgeitem.freezTime.toString();
  //   request.fields['DailyConsumption'] = fridgeitem.dailyConsumption;
  //   request.fields['DailyConsumptionUnit'] = fridgeitem.dailyConsumptionUnit;
  //   request.fields['ExpiryReminder'] = fridgeitem.expiryReminder.toString();
  //   request.fields['LowStockReminder'] = fridgeitem.lowStockReminder.toString();
  //   request.fields['LowStockReminderUnit'] = fridgeitem.lowStockReminderUnit!;
  //   request.fields['FridgeId'] = fridgeitem.fridgeId.toString();
  //   var response = await request.send();
  //   if (response.statusCode == 200) {
  //     String responseBody = await response.stream.bytesToString();
  //     print("a");
  //     return responseBody;
  //   } else {
  //     print("b");
  //     return null;
  //   }
  // }

  // var imagefile = request.Files["Image"];
  //           var name = request.Form["Name"].ToString();
  //           var category = request.Form["Category"];
  //           var fridgeid = request.Form["FridgeId"];
  //           int fid = int.Parse(fridgeid);
  //             var freeztime = request.Form["FreezTime"];
  //           var expiryreminder = request.Form["ExpiryReminder"];
  //           var lowstockreminder = request.Form["LowStockReminder"];
  //           var lowstockreminderunit = request.Form["LowStockReminderUnit"];
  //           var dailyconsumption = request.Form["DailyConsumption"];
  //           var dailyconsumptionunit = request.Form["DailyConsumptionUnit"];
  //           var itemunit = request.Form["ItemUnit"];
  Future<String?> addItem(
    File f,
    String pname,
    String pcategory,
    int pfridgeid,
    int pfreezTime,
    int pexpiryReminder,
    double plowStockReminder,
    String plowStockReminderUnit,
    double pdailyConsumption,
    String pdailyConsumptionUnit,
    String pitemunit,
  ) async {
    String url = '$ip/FridgeItem/FridgeItemAdd';
    Uri uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);
    http.MultipartFile newfile =
        await http.MultipartFile.fromPath('Image', f.path);
    request.files.add(newfile);
    request.fields['Name'] = pname;
    request.fields['Category'] = pcategory;
    request.fields['FridgeId'] = pfridgeid.toString();
    request.fields['FreezTime'] = pfreezTime.toString();
    request.fields['ExpiryReminder'] = pexpiryReminder.toString();
    request.fields['LowStockReminder'] = plowStockReminder.toString();
    request.fields['LowStockReminderUnit'] = plowStockReminderUnit;
    request.fields['DailyConsumption'] = pdailyConsumption.toString();
    request.fields['DailyConsumptionUnit'] = pdailyConsumptionUnit;
    request.fields['ItemUnit'] = pitemunit.toString();
    var response = await request.send();
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      return responseBody;
    } else {
      String responseBody = await response.stream.bytesToString();
      print(responseBody);
      return null;
    }
  }
}
