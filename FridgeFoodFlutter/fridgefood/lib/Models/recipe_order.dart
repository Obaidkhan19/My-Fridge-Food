import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fridgefood/utils/utilities.dart';

class RecipeOrder {
  RecipeOrder({
    this.id,
    this.title,
    this.body,
    this.date,
    this.senderId,
    this.recieverId,
    this.reply,
    this.mealTime,
    this.fridgeId,
    this.senderName,
    this.recieverName,
    this.recipeId,
    this.mealDate,
  });

  RecipeOrder.fromJson(dynamic json) {
    id = json['Id'];
    title = json['Title'];
    body = json['Body'];
    date = json['Date'];
    senderId = json['SenderId'];
    recieverId = json['RecieverId'];
    reply = json['Reply'];
    mealTime = json['MealTime'];
    fridgeId = json['FridgeId'];
    senderName = json['SenderName'];
    recieverName = json['RecieverName'];
    recipeId = json['RecipeId'];
    mealDate = json['MealDate'];
  }
  int? id;
  String? title;
  String? body;
  String? date;
  int? senderId;
  int? recieverId;
  String? reply;
  String? mealTime;
  int? fridgeId;
  String? senderName;
  String? recieverName;
  int? recipeId;
  String? mealDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = id;
    map['Title'] = title;
    map['Body'] = body;
    map['Date'] = date;
    map['SenderId'] = senderId;
    map['RecieverId'] = recieverId;
    map['Reply'] = reply;
    map['MealTime'] = mealTime;
    map["FridgeId"] = fridgeId;
    map["SenderName"] = senderName;
    map["RecieverName"] = recieverName;
    map['RecipeId'] = recipeId;
    map['MealDate'] = mealDate;
    return map;
  }

  Future<String?> orderrecipeapi() async {
    String url = '$ip/notification/AddNotification';
    Uri uri = Uri.parse(url);
    var bodyy = jsonEncode(<String, dynamic>{
      "Title": title,
      "Body": body,
      "MealDate": mealDate,
      "SenderId": senderId,
      "RecieverId": recieverId,
      "Reply": reply,
      "MealTime": mealTime,
      "FridgeId": fridgeId,
      "RecipeId": recipeId,
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
    String url = '$ip/Notification/DeleteNotification?nid=$id';
    Uri uri = Uri.parse(url);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> replyapi() async {
    String url = '$ip/notification/NotificationReply?reply=$reply&nid=$id';
    Uri uri = Uri.parse(url);
    // var bodyy = jsonEncode(<String, dynamic>{
    //   "Id": id,
    //   //  "ReplierId": replierId,
    // });
    var reseponse = await http.post(uri,
        headers: <String, String>{'Content-Type': 'application/json'});
    if (reseponse.statusCode == 200) {
      return reseponse.body;
    } else {
      return null;
    }
  }

  Future<String?> replysorryapi() async {
    String url = '$ip/shoppinglist/replyOrder';
    Uri uri = Uri.parse(url);
    var bodyy = jsonEncode(<String, dynamic>{
      "Id": id,
      //  "ReplierId": replierId,
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

  Future<String?> addMealapi() async {
    String url = '$ip/notification/AddMeal';
    Uri uri = Uri.parse(url);
    var bodyy = jsonEncode(<String, dynamic>{
      "Title": title,
      "MealDate": mealDate,
      "Reply": reply,
      "MealTime": mealTime,
      "FridgeId": fridgeId,
      "RecipeId": recipeId,
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
}
