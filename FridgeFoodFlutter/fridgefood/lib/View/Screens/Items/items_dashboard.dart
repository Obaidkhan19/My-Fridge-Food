import 'package:flutter/material.dart';
import 'package:fridgefood/View/Screens/Items/bakery_screen.dart';
import 'package:fridgefood/View/Screens/Items/cooked_screen.dart';
import 'package:fridgefood/View/Screens/Items/dairy_screen.dart';
import 'package:fridgefood/View/Screens/Items/fruitandvege_screen.dart';
import 'package:fridgefood/View/Screens/Items/meat_screen.dart';
import 'package:fridgefood/View/Screens/Items/other.dart';
import 'package:fridgefood/constants.dart';

class CommonItemsDashboard extends StatefulWidget {
  const CommonItemsDashboard({super.key});

  @override
  State<CommonItemsDashboard> createState() => _CommonItemsDashboardState();
}

class _CommonItemsDashboardState extends State<CommonItemsDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: themeColor,
        title: const Text(
          'All Items',
          style: headingTextStyle,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 30,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              crossAxisCount: 2,
              primary: false,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FruitScreen()),
                    );
                  },
                  child: Card(
                    elevation: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/fruitandvege.png',
                          height: 128,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Fruit and Vegetables',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BakeryScreen()),
                    );
                  },
                  child: Card(
                    elevation: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/bakery.png',
                          height: 128,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Eggs and Bakery',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MeatScreen()),
                    );
                  },
                  child: Card(
                    elevation: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/meatandseafood.jpg',
                          height: 128,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Meat and Seafood',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DairyScreen()),
                    );
                  },
                  child: Card(
                    elevation: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/dairy.png',
                          height: 128,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Dairy',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CookedScreen()),
                    );
                  },
                  child: Card(
                    elevation: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/cooked.jpg',
                          height: 128,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Cooked',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Others()),
                    );
                  },
                  child: Card(
                    elevation: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/others.png',
                          height: 128,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Others',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
