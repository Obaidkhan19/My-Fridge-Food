import 'dart:convert';

import '../utils/utilities.dart';
import 'package:http/http.dart' as http;

class Fridge {
  Fridge({
    this.id,
    this.name,
    this.connectionId,
    this.allDailyConsumption,
    this.userid,
    this.freezerType,
  });

  Fridge.fromJson(dynamic json) {
    id = json['Id'];
    name = json['Name'];
    connectionId = json['ConnectionId'];
    allDailyConsumption = json['AllDailyConsumption'];
    userid = json['UserId'];
    freezerType = json['FreezerType'];
  }
  int? id;
  String? name;
  String? connectionId;
  bool? allDailyConsumption;
  int? userid;
  int? freezerType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = id;
    map['Name'] = name;
    map['ConnectionId'] = connectionId;
    map['AllDailyConsumption'] = allDailyConsumption;
    map['UserId'] = userid;
    map['FreezerType'] = freezerType;
    return map;
  }

  Future<String?> disconnect() async {
    String url = '$ip/fridge/DisconnectFridge?id=$id';
    Uri uri = Uri.parse(url);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

//fridge/CreateFridge?name=a&dailyuse=false&userid=1
  Future<String?> createFridge() async {
    String url =
        '$ip/fridge/CreateFridge?name=$name&dailyuse=$allDailyConsumption&userid=$userid&freezertype=$freezerType';
    Uri uri = Uri.parse(url);
    var response = await http.post(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> editFridge() async {
    String url = '$ip/fridge/EditFridge';
    Uri uri = Uri.parse(url);
    var body = jsonEncode(<String, dynamic>{
      "Id": id,
      "Name": name,
      "AllDailyConsumption": allDailyConsumption,
      "freezerType": freezerType,
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

  Future<String?> joinFridge() async {
    String url = '$ip/Fridge/JoinFridge?uid=$id&connectionid=$connectionId';
    Uri uri = Uri.parse(url);
    var response = await http.post(uri);
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  Future<String?> joinNewFridge() async {
    String url =
        '$ip/Fridge/JoinFridgenewuser?uid=$id&connectionid=$connectionId';
    Uri uri = Uri.parse(url);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }
}
