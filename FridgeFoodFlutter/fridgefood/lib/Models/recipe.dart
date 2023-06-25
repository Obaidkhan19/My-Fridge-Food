import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fridgefood/utils/utilities.dart';

class Recipe {
  Recipe({
    this.id,
    this.name,
    this.image,
    this.servings,
    this.fridgeId,
  });

  Recipe.fromJson(dynamic json) {
    id = json['Id'];
    name = json['Name'];
    image = json['Image'];
    servings = json['Servings'];
    fridgeId = json['FridgeId'];
  }
  int? id;
  String? name;
  String? image;
  int? servings;
  int? fridgeId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Name'] = name;
    map['Image'] = image;
    map['Servings'] = servings;
    map['FridgeId'] = fridgeId;
    return map;
  }

  // add recipe if fridge item name exist he cant enter again that
  // Future<String?> addRecipe(
  //     File f, String name, int servings, int fridgeid) async {
  //   String url = '$ip/recipe/RecipeAdd';
  //   Uri uri = Uri.parse(url);
  //   var request = http.MultipartRequest('POST', uri);
  //   http.MultipartFile newfile =
  //       await http.MultipartFile.fromPath('Image', f.path);
  //   request.files.add(newfile);
  //   request.fields['Name'] = name;
  //   request.fields['Servings'] = servings.toString();
  //   request.fields['FridgeId'] = fridgeid.toString();
  //   var response = await request.send();
  //   if (response.statusCode == 200) {
  //     return 'sucessful';
  //   } else {
  //     return null;
  //   }
  // }
  Future<String?> addRecipe(
      File f, String name, int servings, int fridgeid) async {
    String url = '$ip/recipe/RecipeAdd';
    Uri uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);
    http.MultipartFile newfile =
        await http.MultipartFile.fromPath('Image', f.path);
    request.files.add(newfile);
    request.fields['Name'] = name;
    request.fields['Servings'] = servings.toString();
    request.fields['FridgeId'] = fridgeid.toString();
    var response = await request.send();
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      return responseBody;
    } else {
      return null;
    }
  }

  Future<String?> editrecipe(File? f, String name, int servings, int id) async {
    String url = '$ip/recipe/EditRecipe';
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
    request.fields['Servings'] = servings.toString();

    var response = await request.send();
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      return responseBody;
    } else {
      return null;
    }
  }

  Future<String?> deleterecipeapi() async {
    String url = '$ip/recipe/DeleteRecipe?id=$id';
    Uri uri = Uri.parse(url);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }
}
