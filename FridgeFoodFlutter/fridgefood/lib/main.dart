import 'package:flutter/material.dart';
import 'package:fridgefood/Provider/recipe_detail_provider.dart';
import 'package:fridgefood/Provider/theme_provider.dart';
import 'package:provider/provider.dart';

import 'View/Screens/Profile/SplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeChanger()),
          ChangeNotifierProvider(create: (_) => RecipeDetailProvider()),
        ],
        child: Builder(
          builder: ((BuildContext context) {
            return const MaterialApp(
              // themeMode: themeChanger.themeMode,
              // theme: ThemeData(
              //   brightness: Brightness.light,
              //   primaryColor: themeColor,
              // ),
              // darkTheme: ThemeData(
              //   brightness: Brightness.dark,
              // ),
              debugShowCheckedModeBanner: false,
              home: SplashScreen(),
            );
          }),
        ));
  }
}
