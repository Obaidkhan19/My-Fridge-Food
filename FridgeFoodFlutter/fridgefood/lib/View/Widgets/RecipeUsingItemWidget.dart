import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fridgefood/Models/all_items.dart';
import 'package:fridgefood/utils/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/recipe.dart';
import 'package:http/http.dart' as http;

import '../Screens/Recipe/recipe_detail_screen.dart';

// ignore: must_be_immutable
class RecipeUsingItemWidget extends StatefulWidget {
  AllItem sobj;
  RecipeUsingItemWidget(this.sobj);

  @override
  State<RecipeUsingItemWidget> createState() => _RecipeUsingItemWidgetState();
}

class _RecipeUsingItemWidgetState extends State<RecipeUsingItemWidget> {
  @override
  void initState() {
    super.initState();
    getdata();
  }

  void getdata() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    fridgeid = sp.getInt('fridgeid');
    setState(() {});
  }

  int? fridgeid;
  @override
  Widget build(BuildContext context) {
    String namee = widget.sobj.name!;
    int id = widget.sobj.fridgeItemId!;
    List<Recipe> firecipelist = [];
    Future<List<Recipe>> reciipeapi() async {
      final response = await http.get(Uri.parse(
          '$ip/recipe/RecipeByIngredientName?fridgeitemid=$id&fid=$fridgeid'));
      var data = jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        // sucess
        for (Map i in data) {
          firecipelist.add(Recipe.fromJson(i));
        }
        return firecipelist;
      } else {
        return firecipelist;
      }
    }

    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recipes using $namee",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 25,
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      FutureBuilder(
          future: reciipeapi(),
          builder: (context, AsyncSnapshot<List<Recipe>> snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            } else {
              return firecipelist.isNotEmpty
                  ? SizedBox(
                      height: 160,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(10),
                        itemCount: firecipelist.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: 12,
                          );
                        },
                        itemBuilder: ((BuildContext context, int index) {
                          Recipe robj = firecipelist[index];

                          // return buildCard(index);
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Material(
                                child: Ink.image(
                                  image: NetworkImage(
                                    imgpath + snapshot.data![index].image!,
                                  ),
                                  height: 110,
                                  width: 110,
                                  fit: BoxFit.cover,
                                  child: InkWell(
                                    onTap: () => showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) => RecipeDetail(robj),
                                    ),
                                  ),
                                ),
                              ),
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
                        }),
                      ),
                    )
                  : const Text(
                      'No Recipes',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    );
            }
          }),
    ]);
  }
}
  // Widget buildCard(int index) => Container(
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Material(
  //             child: Ink.image(
  //               image: const AssetImage(
  //                 'assets/kheer.png',
  //               ),
  //               height: 110,
  //               width: 110,
  //               fit: BoxFit.cover,
  //               child: InkWell(
  //                 onTap: widget.onPress,
  //               ),
  //             ),
  //           ),
  //           const SizedBox(
  //             height: (4),
  //           ),
  //           const Text(
  //             'Kheer',
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //         ],
  //       ),
  //     );
//}
