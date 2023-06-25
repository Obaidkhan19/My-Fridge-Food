import 'package:flutter/material.dart';

class RecipeDetailProvider with ChangeNotifier {
  // =========== MEAL DATE
  DateTime _mealdate = DateTime.now();
  DateTime get mealdate => _mealdate;
  int _servings = 0;
  int get servings => _servings;

  // set mealdate(DateTime value) {
  //   _mealdate = value;
  //   notifyListeners();
  // }
  set setservings(int s) {
    _servings = s;
    notifyListeners();
  }

  void incrementservings() {
    _servings++;
    notifyListeners();
  }

  void decrementservings() {
    _servings--;
    notifyListeners();
  }

  void updateMealDate(mealdate) {
    _mealdate = mealdate;
    notifyListeners();
  }

  void resetMealDate() {
    _mealdate = DateTime.now();
    notifyListeners();
  }

// =========== MEAL TIME
  String _selectedMeal = 'Breakfast';
  String get selectedMeal => _selectedMeal;

  void onMealSelected(selectedMeal) {
    _selectedMeal = selectedMeal;
    notifyListeners();
  }

  // void resetDropdown() {
  //   _selectedMeal = 'Breakfast'; // set the initial value of the dropdown
  //   notifyListeners();
  // }
}
