import 'package:badges/badges.dart';
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:fridgefood/View/Screens/Recipe/recipe_detail_screen.dart';
import 'package:fridgefood/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/utilities.dart';
import 'add_recipe.dart';
import 'recipe_notification.dart';
import 'package:fridgefood/Models/recipe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => RecipeScreenState();
}

class RecipeScreenState extends State<RecipeScreen> {
  Color color = Colors.white;
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

  TextEditingController nameController = TextEditingController();
  List<Recipe> rlist = [];
  Future<List<Recipe>> recipeapi() async {
    final response =
        await http.get(Uri.parse('$ip/recipe/RecipeDashboard?fid=$fridgeid'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      rlist.clear();
      // sucess
      for (Map i in data) {
        rlist.add(Recipe.fromJson(i));
      }
      return rlist;
    } else {
      return rlist;
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
          'Recipe', // 'Recipe & Meals',
          style: headingTextStyle,
        ),
        leading: const Icon(
          Boxicons.bx_food_menu,
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
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              // onTap: (() {
              //   final results =
              //       showSearch(context: context, delegate: RecipeSearch());
              // }),
              cursorColor: themeColor,
              controller: nameController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                focusColor: themeColor,
                hintText: 'Search For Recipes',
                prefixIcon: IconButton(
                  color: themeColor,
                  icon: const Icon(Icons.search_outlined),
                  onPressed: () {
                    // final results =
                    //     showSearch(context: context, delegate: RecipeSearch());
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Column(children: [
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      'Recipes',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // GRID VIEW
              const SizedBox(
                height: 25,
              ),

              SizedBox(
                height: 500,
                child: FutureBuilder(
                    future: recipeapi(),
                    builder: (context, AsyncSnapshot<List<Recipe>> snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      } else {
                        return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
                            ),
                            itemCount: rlist.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              Recipe robj = rlist[index];
                              String name =
                                  snapshot.data![index].name.toString();
                              // is namecontroller is empty
                              if (nameController.text.isEmpty) {
                                return Column(
                                  children: [
                                    Material(
                                      child: Ink.image(
                                        image: NetworkImage(
                                          imgpath +
                                              snapshot.data![index].image!,
                                        ),
                                        height: 110,
                                        width: 110,
                                        fit: BoxFit.cover,
                                        child: InkWell(onTap: () async {
                                          bool result =
                                              await showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) => RecipeDetail(
                                              robj,
                                            ),
                                          );
                                          if (result == true) {
                                            setState(() {
                                              recipeapi().then(
                                                  (value) => rlist = value);
                                            });
                                          }
                                        }),
                                      ),
                                    ),
                                    // Material(
                                    //   child: CachedNetworkImage(
                                    //     key: UniqueKey(),
                                    //     imageUrl: imgpath +
                                    //         snapshot.data![index].image!,
                                    //     imageBuilder:
                                    //         (context, imageProvider) =>
                                    //             Ink.image(
                                    //       image: imageProvider,
                                    //       height: 110,
                                    //       width: 110,
                                    //       fit: BoxFit.cover,
                                    //       child: InkWell(
                                    //         onTap: () async {
                                    //           bool result =
                                    //               await showModalBottomSheet(
                                    //             backgroundColor:
                                    //                 Colors.transparent,
                                    //             isScrollControlled: true,
                                    //             context: context,
                                    //             builder: (context) =>
                                    //                 RecipeDetail(robj),
                                    //           );
                                    //           if (result == true) {
                                    //             setState(() {
                                    //               recipeapi().then(
                                    //                   (value) => rlist = value);
                                    //             });
                                    //           }
                                    //         },
                                    //       ),
                                    //     ),
                                    //     placeholder: (context, url) =>
                                    //         Container(
                                    //       height: 110,
                                    //       width: 110,
                                    //       alignment: Alignment.center,
                                    //       child:
                                    //           Image.asset('assets/recipe.png'),
                                    //     ),
                                    //     errorWidget: (context, url, error) =>
                                    //         Image.asset('assets/recipe.png'),
                                    //   ),
                                    // ),

                                    const SizedBox(
                                      height: (4),
                                    ),
                                    Text(
                                      snapshot.data![index].name.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                );
                              } else if (name.toLowerCase().contains(
                                  nameController.text.toLowerCase())) {
                                return Column(
                                  children: [
                                    Material(
                                      child: Ink.image(
                                        image: NetworkImage(
                                          imgpath +
                                              snapshot.data![index].image!,
                                        ),
                                        height: 110,
                                        width: 110,
                                        fit: BoxFit.cover,
                                        child: InkWell(onTap: () async {
                                          bool result =
                                              await showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) => RecipeDetail(
                                              robj,
                                            ),
                                          );
                                          if (result == true) {
                                            setState(() {
                                              recipeapi().then(
                                                  (value) => rlist = value);
                                            });
                                          }
                                        }),
                                      ),
                                    ),
                                    // Material(
                                    //   child: CachedNetworkImage(
                                    //     key: UniqueKey(),
                                    //     imageUrl: imgpath +
                                    //         snapshot.data![index].image!,
                                    //     imageBuilder:
                                    //         (context, imageProvider) =>
                                    //             Ink.image(
                                    //       image: imageProvider,
                                    //       height: 110,
                                    //       width: 110,
                                    //       fit: BoxFit.cover,
                                    //       child: InkWell(
                                    //         onTap: () async {
                                    //           bool result =
                                    //               await showModalBottomSheet(
                                    //             backgroundColor:
                                    //                 Colors.transparent,
                                    //             isScrollControlled: true,
                                    //             context: context,
                                    //             builder: (context) =>
                                    //                 RecipeDetail(robj),
                                    //           );
                                    //           if (result == true) {
                                    //             setState(() {
                                    //               recipeapi().then(
                                    //                   (value) => rlist = value);
                                    //             });
                                    //           }
                                    //         },
                                    //       ),
                                    //     ),
                                    //     placeholder: (context, url) =>
                                    //         Container(
                                    //       height: 110,
                                    //       width: 110,
                                    //       alignment: Alignment.center,
                                    //       child:
                                    //           Image.asset('assets/recipe.png'),
                                    //     ),
                                    //     errorWidget: (context, url, error) =>
                                    //         Image.asset('assets/recipe.png'),
                                    //   ),
                                    // ),

                                    const SizedBox(
                                      height: (4),
                                    ),
                                    Text(
                                      snapshot.data![index].name.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            });
                      }
                    }),
              ),
            ]),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final value = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddRecipe(),
            ),
          );
          setState(() {
            color = color == Colors.white ? Colors.grey : Colors.white;
          });
        },
        tooltip: 'Increment',
        backgroundColor: themeColor,
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }
}
