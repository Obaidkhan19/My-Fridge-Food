import 'dart:convert';

import 'package:fridgefood/utils/utilities.dart';
import 'package:http/http.dart' as http;

class User {
  int? id;
  int? userId;
  String? name;
  String? email;
  String? password;
  String? role;
  User({
    int? id,
    this.name,
    this.email,
    this.password,
    this.userId,
    this.role,
  });
  User.fromJson(dynamic json) {
    id = json['Id'];
    name = json['Name'];
    email = json['Email'];
    password = json['Password'];
    userId = json['UserId'];
    role = json['Role'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = id;
    map['Name'] = name;
    map['Email'] = email;
    map['Password'] = password;
    map['UserId'] = userId;
    map['Role'] = role;
    return map;
  }

  Future<String?> login() async {
    String url = '$ip/user/Login?email=$email&password=$password';
    Uri uri = Uri.parse(url);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  Future<String?> signupObject() async {
    String url = '$ip/user/RegisterUser';
    Uri uri = Uri.parse(url);
    var body = jsonEncode(
        <String, dynamic>{"Name": name, "Email": email, "Password": password});
    var reseponse = await http.post(uri,
        body: body,
        headers: <String, String>{'Content-Type': 'application/json'});
    if (reseponse.statusCode == 200) {
      return reseponse.body;
    } else {
      return null;
    }
  }

  Future<String?> editUser() async {
    String url = '$ip/user/EditUser';
    Uri uri = Uri.parse(url);
    var body = jsonEncode(<String, dynamic>{
      "Id": id,
      "Name": name,
      "Email": email,
      "Password": password
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

  Future<String?> removeuserorleaveapi() async {
    String url = '$ip/fridge/LeaveFridge?fuid=$id';
    Uri uri = Uri.parse(url);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<String?> makeadminapi() async {
    String url = '$ip/user/MakeAdmin?fuid=$id';
    Uri uri = Uri.parse(url);
    var response = await http.post(uri);
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  Future<String?> makeownerapi() async {
    String url = '$ip/user/MakeOwner?fuid=$id';
    Uri uri = Uri.parse(url);
    var response = await http.post(uri);
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  Future<String?> removeadminapi() async {
    String url = '$ip/user/RemoveAdmin?fuid=$id';
    Uri uri = Uri.parse(url);
    var response = await http.post(uri);
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }
}
