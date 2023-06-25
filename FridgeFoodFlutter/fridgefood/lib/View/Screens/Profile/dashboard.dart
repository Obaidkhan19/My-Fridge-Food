import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:fridgefood/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  // @override
  // void initState() {
  //   super.initState();
  //   getname();
  // }

  // String? name;
  // void getname() async {
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   name = sp.getString('username');
  //   setState(() {});
  // }

  Future<String> getName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('username') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height * .3,
            decoration: const BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.topCenter,
                image: AssetImage('assets/top_header.png'),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    height: 130,
                    margin: const EdgeInsets.only(
                      bottom: 100,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: FutureBuilder<String>(
                            future: getName(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator(); // Placeholder or loading indicator
                              } else if (snapshot.hasError) {
                                return const Text(
                                    'Error'); // Display an error message if there's an error
                              } else {
                                return buildColorizeAnimation(
                                  '      My Fridge Food\nWelcome, ${snapshot.data}!',
                                );
                              }
                            },
                          ),
                          //  buildColorizeAnimation(
                          //     '      My Fridge Food\nWelcome, $name!'),
                          //  Text(
                          //   '      My Fridge Food\nWelcome, $name!',
                          //   style: const TextStyle(
                          //     fontSize: 25,
                          //     color: Colors.white,
                          //     fontWeight: FontWeight.w800,
                          //   ),
                          // ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      primary: false,
                      children: [
                        Card(
                          elevation: 8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/fridge.png',
                                height: 128,
                              ),
                              const Text(
                                'Fridge',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          elevation: 8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/recipe.png',
                                height: 128,
                              ),
                              const Text(
                                'Recipe',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          elevation: 8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/shopping.png',
                                height: 128,
                              ),
                              const Text(
                                'Shopping List',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          elevation: 8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/setting.png',
                                height: 128,
                              ),
                              const Text(
                                'Setting',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  var colorizeColors = [
    Colors.red,
    Colors.yellow,
    themeColor,
    Colors.blue,
    Colors.purple,
  ];
  var colorizeTextStyle = const TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w800,
  );
  Widget buildColorizeAnimation(String text) => Center(
        child: AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(text,
                textStyle: colorizeTextStyle, colors: colorizeColors)
          ],
          repeatForever: true,
        ),
      );
}
