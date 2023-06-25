import 'dart:async';
import 'package:badges/badges.dart';
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:fridgefood/utils/utilities.dart';
import 'package:fridgefood/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        getdata();
        _fetchNumber();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void getdata() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    fridgeid = sp.getInt('fridgeid');
    setState(() {});
  }

  int _number = 0;
  int? fridgeid;

  Future<void> _fetchNumber() async {
    final response = await http
        .get(Uri.parse('$ip/shoppinglist/ShoppinglistCounter?fid=$fridgeid'));
    if (response.statusCode == 200) {
      setState(() {
        _number = int.parse(response.body);
      });
    } else {
      return;
    }
  }

  int pageIdx = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) {
          setState(() {
            pageIdx = idx;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: themeColor,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        currentIndex: pageIdx,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Boxicons.bxs_fridge,
              size: 30,
            ),
            label: 'Fridge',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Boxicons.bxs_fridge,
              size: 30,
            ),
            label: 'Expiring Soon',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Boxicons.bx_food_menu,
              size: 30,
            ),
            label: 'Recipe',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.set_meal_outlined,
              size: 30,
            ),
            label: 'Meal',
          ),
          BottomNavigationBarItem(
            icon: FutureBuilder(
              future: _fetchNumber(),
              builder: (context, snapshot) {
                return Badge(
                  badgeContent: Text(
                    _number.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  badgeColor: Colors.red,
                  borderRadius: BorderRadius.circular(25),
                  toAnimate: false,
                  shape: BadgeShape.circle,
                  position: BadgePosition.topEnd(),
                  child: const Icon(
                    (Icons.shopping_cart_outlined),
                    size: 30,
                  ),
                );
              },
            ),
            label: 'Shopping',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              (Icons.person),
              size: 30,
            ),
            label: 'Profile',
          ),
        ],
      ),
      body: pages[pageIdx],
    );
  }
}
