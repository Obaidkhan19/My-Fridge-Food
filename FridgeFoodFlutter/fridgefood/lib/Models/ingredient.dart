import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fridgefood/utils/utilities.dart';

class Ingredient {
  Ingredient({
    this.id,
    this.itemName,
    this.itemUnit,
    this.fridgeitemId,
    this.ingUnitoriginal,
    this.ingQuantityoriginal,
    this.recipeId,
    this.requiredQuantity,
    this.requiredUnit,
    this.avaliable,
    this.avaliableQuantity,
    this.avaliableUnit,
    this.ingQuantity,
    this.ingUnit,
  });

  Ingredient.fromJson(dynamic json) {
    id = json['Id'];
    itemName = json['ItemName'];
    fridgeitemId = json['FridgeItemId'];
    ingUnitoriginal = json['IngUnitoriginal'];
    ingQuantityoriginal = json['IngQuantityoriginal'];
    recipeId = json['RecipeId'];
    requiredQuantity = json['RequiredQuantity'];
    requiredUnit = json['RequiredUnit'];
    avaliable = json['Avaliable'];
    itemUnit = json['ItemUnit'];
    avaliableQuantity = json['AvaliableQuantity'];
    avaliableUnit = json['AvaliableUnit'];
    ingQuantity = json['IngQuantity'];
    ingUnit = json['IngUnit'];
  }
  int? id;
  String? itemName;
  String? itemUnit;
  int? fridgeitemId;
  String? ingUnitoriginal;
  double? ingQuantityoriginal;
  int? recipeId;
  dynamic requiredQuantity;
  dynamic requiredUnit;
  bool? avaliable;
  double? ingQuantity;
  String? ingUnit;
  double? avaliableQuantity;
  String? avaliableUnit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = id;
    map['ItemName'] = itemName;
    map['FridgeItemId'] = fridgeitemId;
    map['IngUnitoriginal'] = ingUnitoriginal;
    map['IngQuantityoriginal'] = ingQuantityoriginal;
    map['RecipeId'] = recipeId;
    map['RequiredQuantity'] = requiredQuantity;
    map['RequiredUnit'] = requiredUnit;
    map['Avaliable'] = avaliable;
    map['ItemUnit'] = itemUnit;
    map['IngQuantity'] = ingQuantity;
    map['IngUnit'] = ingUnit;
    map['AvaliableQuantity'] = avaliableQuantity;
    map['AvaliableUnit'] = avaliableUnit;
    return map;
  }

  Future<String?> addingredient() async {
    String url = '$ip/recipe/IngredientAdd';
    Uri uri = Uri.parse(url);
    var body = jsonEncode(<String, dynamic>{
      "FridgeitemId": fridgeitemId,
      "Quantity": ingQuantityoriginal,
      "Unit": ingUnitoriginal,
      "RecipeId": recipeId
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

  Future<String?> editingredient() async {
    String url = '$ip/recipe/EditIngredient';
    Uri uri = Uri.parse(url);
    var body = jsonEncode(<String, dynamic>{
      "Id": id,
      "Quantity": ingQuantityoriginal,
      "Unit": ingUnitoriginal,
      "FridgeitemId": fridgeitemId,
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

  Future<String?> deleteingredientapi() async {
    String url = '$ip/recipe/DeleteIngredient?id=$id';
    Uri uri = Uri.parse(url);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }
}

class ConsumeIngredients {
  List<int>? fridgeItemIds;
  List<String>? quantities;
  List<String>? units;

  ConsumeIngredients({
    this.fridgeItemIds,
    this.quantities,
    this.units,
  });

  Map<String, dynamic> toJson() {
    return {
      "FridgeItemIds": fridgeItemIds,
      "Quantities": quantities,
      "Units": units,
    };
  }

  Future<String?> ConsumeIngredientsApi() async {
    String url = '$ip/FridgeItem/ConsumeIngredients';
    Uri uri = Uri.parse(url);
    var body = jsonEncode(<String, dynamic>{
      "FridgeitemIds": fridgeItemIds,
      "Quantities": quantities,
      "Units": units,
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
