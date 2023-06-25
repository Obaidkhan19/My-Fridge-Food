// www.youtube.com/watch?v=4YqyRBCHvug&list=PLFyjjoCMAPtxq8V9fuVmgsYKLNIKqSEV4&index=20&ab_channel=TheTechBrothers

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fridgefood/View/Screens/Auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fridgefood/constants.dart';

import '../Auth/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  static String KEYLOGIN = 'login';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WhereTOGo();
  }

  void WhereTOGo() async {
    var sp = await SharedPreferences.getInstance();

    var isloggedin = sp.getBool(KEYLOGIN);
    if (isloggedin != null) {
      if (isloggedin) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        Timer(const Duration(seconds: 5), () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        });
      }
    } else {
      Timer(const Duration(seconds: 5), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: const Image(
                    image: AssetImage('assets/logo.png'),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: const Text(
                    'My Fridge Food',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: const Text(
                    'Plan • Shop • Cook',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
