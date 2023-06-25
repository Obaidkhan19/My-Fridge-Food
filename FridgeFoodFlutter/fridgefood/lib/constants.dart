import 'package:flutter/material.dart';
import 'package:fridgefood/View/Screens/Profile/dashboard.dart';
import 'package:fridgefood/View/Screens/FridgeItems/fridge.dart';
import 'package:fridgefood/View/Screens/Profile/profile.dart';
import 'package:fridgefood/View/Screens/Recipe/recipe.dart';
import 'package:fridgefood/View/Screens/Shopping/shpping.dart';
import 'package:fridgefood/View/Screens/Task%20Screens/task.dart';

import 'View/Screens/Meals/Meal_Dashboard.dart';

// COLORS

var themeColor = const Color.fromARGB(255, 12, 182, 123);
const greyBackground = Color.fromARGB(255, 208, 211, 218);
const Color whitecolor = Colors.white;
const headingTextStyle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w500,
  // color: Colors.white,
);

// BOTTON NAV BAR PAGES
List pages = [
  const Dashboard(),
  const FridgeScreen(),
  const ExpiringSoon(),
  const RecipeScreen(),
  const MealDashboard(),
  const ShoppingCartScreen(),
  const ProfileScreen(),
];
