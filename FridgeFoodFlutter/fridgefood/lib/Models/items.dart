import 'package:fridgefood/utils/utilities.dart';
import 'package:http/http.dart' as http;

class Items {
  Items({
    this.id,
    this.name,
    this.itemUnit,
    this.image,
    this.added,
    this.fridgeid,
    this.fridgeItemId,
  });

  Items.fromJson(dynamic json) {
    id = json['Id'];
    name = json['Name'];
    itemUnit = json['ItemUnit'];
    image = json['Image'];
    added = json['Added'];
    fridgeid = json['fridgeid'];
    fridgeItemId = json['FridgeItemId'];
  }
  int? id;
  String? name;
  String? itemUnit;
  dynamic image;
  String? added;
  int? fridgeid;
  int? fridgeItemId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = id;
    map['Name'] = name;
    map['ItemUnit'] = itemUnit;
    map['Image'] = image;
    map['Added'] = added;
    map['FridgeId'] = fridgeid;
    map['FridgeItemId'] = fridgeItemId;
    return map;
  }

  Future<String?> addItem() async {
    String url = '$ip/FridgeItem/AddItem?iid=$id&fid=$fridgeid';
    Uri uri = Uri.parse(url);
    var response = await http.post(uri);
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  Future<String?> removeItemapi() async {
    String url = '$ip/FridgeItem/DeleteFridgeItem?fiid=$id';
    Uri uri = Uri.parse(url);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }
}
