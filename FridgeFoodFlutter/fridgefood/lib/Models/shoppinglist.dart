import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fridgefood/utils/utilities.dart';

class Shoppinglist {
  Shoppinglist({
    this.id,
    this.body,
    this.date,
    this.fridgeId,
    this.senderId,
    this.replierId,
    this.replierName,
    this.senderName,
    this.header,
  });

  Shoppinglist.fromJson(dynamic json) {
    id = json['Id'];
    body = json['Body'];
    date = json['Date'];
    fridgeId = json['FridgeId'];
    senderId = json['SenderId'];
    replierId = json['ReplierId'];
    senderName = json['SenderName'];
    replierName = json['ReplierName'];
    header = json['Header'];
  }
  int? id;
  String? body;
  String? date;
  int? fridgeId;
  int? senderId;
  int? replierId;
  String? senderName;
  String? replierName;
  String? header;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = id;
    map['Body'] = body;
    map['Date'] = date;
    map['FridgeId'] = fridgeId;
    map['SenderId'] = senderId;
    map['ReplierId'] = replierId;
    map['ReplierName'] = replierName;
    map['SenderName'] = senderName;
    map['Header'] = header;
    return map;
  }

  Future<String?> addtoshoppinglistapi() async {
    String url = '$ip/shoppinglist/AddToShoppinglistManually';
    Uri uri = Uri.parse(url);
    var bodyy = jsonEncode(<String, dynamic>{
      "Body": body,
      "FridgeId": fridgeId,
      "SenderId": senderId,
      "Header": header,
    });
    var reseponse = await http.post(uri,
        body: bodyy,
        headers: <String, String>{'Content-Type': 'application/json'});
    if (reseponse.statusCode == 200) {
      return reseponse.body;
    } else {
      return null;
    }
  }

  Future<String?> deleteorderapi() async {
    String url = '$ip/shoppinglist/DeleteOrder?oid=$id';
    Uri uri = Uri.parse(url);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> replyorderapi() async {
    String url = '$ip/shoppinglist/replyOrder'; //shoppinglist/replyOrder
    Uri uri = Uri.parse(url);
    var bodyy = jsonEncode(<String, dynamic>{
      "Id": id,
      "ReplierId": replierId,
    });
    var reseponse = await http.post(uri,
        body: bodyy,
        headers: <String, String>{'Content-Type': 'application/json'});
    if (reseponse.statusCode == 200) {
      return reseponse.body;
    } else {
      return null;
    }
  }

  Future<String?> cancelReply() async {
    String url = '$ip/shoppinglist/cancelReply?id=$id';
    Uri uri = Uri.parse(url);
    var reseponse = await http.post(uri);
    if (reseponse.statusCode == 200) {
      return reseponse.body;
    } else {
      return null;
    }
  }
}
