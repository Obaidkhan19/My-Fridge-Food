import 'package:fridgefood/utils/utilities.dart';
import 'package:http/http.dart' as http;

class Fridgeuser {
  Fridgeuser({
    this.id,
    this.fridgeName,
    this.role,
    this.fridgeId,
    this.freezerType,
  });

  Fridgeuser.fromJson(dynamic json) {
    id = json['Id'];
    fridgeName = json['FridgeName'];
    role = json['Role'];
    fridgeId = json['FridgeId'];
    freezerType = json['FreezerType'];
  }
  int? id;
  String? fridgeName;
  String? role;
  int? fridgeId;
  int? freezerType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = id;
    map['FridgeName'] = fridgeName;
    map['Role'] = role;
    map['FridgeId'] = fridgeId;
    map['FreezerType'] = freezerType;
    return map;
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
}
