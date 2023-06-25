class Meal {
  Meal({this.mealDate, this.meals = const []});

  Meal.fromJson(dynamic json) {
    mealDate = json['MealDate'];
    if (json['Meals'] != null) {
      meals = [];
      json['Meals'].forEach((v) {
        meals.add(Meals.fromJson(v));
      });
    }
  }
  String? mealDate;
  late List<Meals> meals;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['MealDate'] = mealDate;
    map['Meals'] = meals.map((v) => v.toJson()).toList();
    return map;
  }
}

class Meals {
  Meals({
    this.recipeId,
    this.name,
    this.image,
    this.servings,
    this.notificationId,
    this.mealTime,
  });

  Meals.fromJson(dynamic json) {
    recipeId = json['RecipeId'];
    name = json['Name'];
    image = json['Image'];
    servings = json['Servings'];
    notificationId = json['NotificationId'];
    mealTime = json['MealTime'];
  }
  int? recipeId;
  String? name;
  String? image;
  int? servings;
  int? notificationId;
  String? mealTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['RecipeId'] = recipeId;
    map['Name'] = name;
    map['Image'] = image;
    map['Servings'] = servings;
    map['NotificationId'] = notificationId;
    map['MealTime'] = mealTime;
    return map;
  }
}
