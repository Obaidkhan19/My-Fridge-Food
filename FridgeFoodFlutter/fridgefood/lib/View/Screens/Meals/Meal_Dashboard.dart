import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fridgefood/Models/meal.dart';
import 'package:fridgefood/Models/recipe.dart';
import 'package:fridgefood/utils/utilities.dart';
import 'package:fridgefood/View/Screens/Recipe/recipe_notification.dart';
import 'package:fridgefood/View/Screens/Recipe/recipe_detail_screen.dart';
import 'package:fridgefood/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class MealDashboard extends StatefulWidget {
  const MealDashboard({super.key});

  @override
  State<MealDashboard> createState() => _MealDashboardState();
}

class _MealDashboardState extends State<MealDashboard> {
  @override
  void initState() {
    super.initState();
    getdata();
  }

  void getdata() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    fridgeid = sp.getInt('fridgeid');
    userid = sp.getInt('userid');
    setState(() {});
  }

  int? fridgeid;
  int? userid;

  // PART 11
  List<Meal> meallist = [];
  Future<List<Meal>> mealapi() async {
    final response =
        await http.get(Uri.parse('$ip/Notification/GetMeals?fiid=$fridgeid'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      meallist.clear();
      // sucess
      for (Map i in data) {
        meallist.add(Meal.fromJson(i));
      }
      return meallist;
    } else {
      return meallist;
    }
  }

  int _number = 0;

  Future<void> _fetchNumber() async {
    final response = await http.get(Uri.parse(
        '$ip/Notification/notificationCount?uid=$userid&fid=$fridgeid'));
    if (response.statusCode == 200) {
      setState(() {
        _number = int.parse(response.body);
      });
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: themeColor,
        title: const Text(
          'Meals',
          style: headingTextStyle,
        ),
        leading: const Icon(
          Icons.set_meal_outlined,
          size: 30.0,
          color: Colors.white,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 10),
            child: FutureBuilder(
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
                    child: IconButton(
                      icon: const Icon(Icons.notifications_none_outlined),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const RecipeNotificationScreen()),
                        );
                      },
                      color: Colors.white,
                      iconSize: 30,
                      padding: const EdgeInsets.only(right: 18, left: 6),
                    ),
                  );
                }),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            // const SizedBox(
            //   height: 5,
            // ),
            // Row(
            //   children: const [
            //     Padding(
            //       padding: EdgeInsets.only(left: 4),
            //       child: Text(
            //         'Meals',
            //         style: TextStyle(
            //           fontSize: 30,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(
              height: 25,
            ),
            Expanded(
              child: FutureBuilder(
                  future: mealapi(),
                  builder: (context, AsyncSnapshot<List<Meal>> snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: meallist.length,
                          itemBuilder: (BuildContext context, int index) {
                            String date =
                                snapshot.data![index].mealDate!.toString();
                            DateFormat dateFormat =
                                DateFormat("dd MMMM yyyy EEEE");
                            String formattedDate =
                                dateFormat.format(DateTime.parse(date));

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                    height: 300,
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            snapshot.data![index].meals.length,
                                        itemBuilder: (context, Position) {
                                          int servings = snapshot.data![index]
                                              .meals[Position].servings!;

                                          Recipe robj = Recipe(
                                            id: snapshot.data![index]
                                                .meals[Position].recipeId!,
                                            name: snapshot.data![index]
                                                .meals[Position].name!,
                                            image: snapshot.data![index]
                                                .meals[Position].image!,
                                            servings: snapshot.data![index]
                                                .meals[Position].servings!,
                                          );
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            child: Column(
                                              children: [
                                                // Container(
                                                //   height: 200,
                                                //   width: 165,
                                                //   decoration: BoxDecoration(
                                                //       image: DecorationImage(
                                                //     fit: BoxFit.cover,
                                                //     image: NetworkImage(
                                                //       imgpath +
                                                //           snapshot
                                                //               .data![index]
                                                //               .meals[Position]
                                                //               .image!,
                                                //     ),
                                                //   )),
                                                // ),
                                                Material(
                                                  child: Ink.image(
                                                    image: NetworkImage(
                                                      imgpath +
                                                          snapshot
                                                              .data![index]
                                                              .meals[Position]
                                                              .image!,
                                                    ),
                                                    height: 200,
                                                    width: 165,
                                                    fit: BoxFit.cover,
                                                    child: InkWell(
                                                        onTap: () async {
                                                      bool result =
                                                          await showModalBottomSheet(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        isScrollControlled:
                                                            true,
                                                        context: context,
                                                        builder: (context) =>
                                                            RecipeDetail(
                                                          robj,
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: (4),
                                                ),
                                                Text(
                                                  snapshot.data![index]
                                                      .meals[Position].name!,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                const SizedBox(
                                                  height: (4),
                                                ),
                                                Text(
                                                  snapshot
                                                      .data![index]
                                                      .meals[Position]
                                                      .mealTime!,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                const SizedBox(
                                                  height: (4),
                                                ),
                                                // Text(
                                                //   'Servings $servings',
                                                //   style: const TextStyle(
                                                //       fontWeight:
                                                //           FontWeight.bold,
                                                //       fontSize: 20),
                                                // ),
                                              ],
                                            ),
                                          );
                                        }))
                              ],
                            );
                          });
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
