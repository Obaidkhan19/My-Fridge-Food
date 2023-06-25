import 'dart:convert';

import 'package:fridgefood/utils/utilities.dart';
import 'package:http/http.dart' as http;

class Stock {
  Stock({
    this.id,
    this.quantity,
    this.quantityUnit,
    this.purchaseDate,
    this.expiryDate,
    this.isFrozen,
    this.fridgeItemId,
    this.status,
    this.fridgeid,
    this.label,
    this.data,
    this.userId,
  });

  Stock.fromJson(dynamic json) {
    id = json['Id'];
    quantity = json['Quantity'];
    quantityUnit = json['QuantityUnit'];
    purchaseDate = json['PurchaseDate'];
    expiryDate = json['ExpiryDate'];
    isFrozen = json['IsFrozen'];
    fridgeItemId = json['FridgeItemId'];
    status = json['Status'];
    fridgeid = json['FridgeId'];
    label = json['Label'];
    data = json['Data'];
    userId = json['UserId'];
  }
  int? id;
  double? quantity;
  String? quantityUnit;
  String? purchaseDate;
  String? expiryDate;
  bool? isFrozen;
  int? fridgeItemId;
  String? status;
  int? fridgeid;
  String? label;
  String? data;
  int? userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = id;
    map['Quantity'] = quantity;
    map['QuantityUnit'] = quantityUnit;
    map['PurchaseDate'] = purchaseDate;
    map['ExpiryDate'] = expiryDate;
    map['IsFrozen'] = isFrozen;
    map['FridgeItemId'] = fridgeItemId;
    map['Status'] = status;
    map['FridgeId'] = fridgeid;
    map['Label'] = label;
    map['Data'] = data;
    map['UserId'] = userId;
    return map;
  }

  Future<String?> consumeapi() async {
    String url =
        '$ip/fridgeitem/ConsumeStock?sid=$id&quantity=$quantity&unit=$quantityUnit&data=$data&uid=$userId&fid=$fridgeid';
    Uri uri = Uri.parse(url);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  Future<String?> addStock() async {
    String url = '$ip/fridgeitem/AddStock';
    Uri uri = Uri.parse(url);
    var body = jsonEncode(<String, dynamic>{
      "Quantity": quantity,
      "QuantityUnit": quantityUnit,
      "PurchaseDate": purchaseDate,
      "ExpiryDate": expiryDate,
      "IsFrozen": isFrozen,
      "FridgeItemId": fridgeItemId,
      "Label": label,
    });
    var reseponse = await http.post(uri,
        body: body,
        headers: <String, String>{'Content-Type': 'application/json'});
    if (reseponse.statusCode == 200) {
      return reseponse.body;
    } else {
      return null;
    }
  }

  Future<String?> restorestockapi() async {
    String url = '$ip/fridgeitem/RestoreStock?bid=$id';
    Uri uri = Uri.parse(url);
    var response = await http.post(uri);
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  Future<String?> consumeallstockapi() async {
    String url =
        '$ip/fridgeitem/ConsumeAllStock?sid=$id&data=$data&uid=$userId&fid=$fridgeid';
    Uri uri = Uri.parse(url);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> deletestockapi() async {
    String url = '$ip/fridgeitem/DeleteStock?sid=$id&fid=$fridgeid';
    Uri uri = Uri.parse(url);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> editStock() async {
    String url = '$ip/FridgeItem/EditStock';
    Uri uri = Uri.parse(url);
    var body = jsonEncode(<String, dynamic>{
      "Id": id,
      "Quantity": quantity,
      "QuantityUnit": quantityUnit,
      "PurchaseDate": purchaseDate,
      "ExpiryDate": expiryDate,
      "IsFrozen": isFrozen,
    });
    var reseponse = await http.post(uri,
        body: body,
        headers: <String, String>{'Content-Type': 'application/json'});
    if (reseponse.statusCode == 200) {
      return reseponse.body;
    } else {
      return null;
    }
  }
}
