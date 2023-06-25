import 'package:flutter/material.dart';
import 'package:fridgefood/utils/utilities.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../Models/recipe.dart';
import '../Screens/Recipe/recipe_detail_screen.dart';

//https://www.youtube.com/watch?v=RaACAwvZ61E&list=WL&index=2&t=953s&ab_channel=JohannesMilke

class RecipeSearch extends SearchDelegate<String> {
  get fridgeid => null;

  void getdata() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    int? fridgeid = sp.getInt('fridgeid');
  }

  List<Recipe> rlist = [];

  Future<List<Recipe>> recipeapi({String? query}) async {
    final response =
        await http.get(Uri.parse('$ip/recipe/RecipeDashboard?fid=$fridgeid'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      rlist.clear();
      // sucess
      for (Map i in data) {
        rlist.add(Recipe.fromJson(i));
      }

      if (query != null) {
        rlist = rlist
            .where((element) =>
                element.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      return rlist;
    } else {
      return rlist;
    }
  }

  //  cross icon on right
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        )
      ];

// back arrow
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_outlined),
        onPressed: () => Navigator.of(context).pop(),
      );

// click on suggestion then this function is called

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox(
      height: 500,
      child: FutureBuilder(
          future: recipeapi(query: query),
          builder: (context, AsyncSnapshot<List<Recipe>> snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            } else {
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemCount: rlist.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    Recipe robj = rlist[index];
                    return Column(
                      children: [
                        Material(
                          child: Ink.image(
                            image: const AssetImage(
                              'assets/kheer.png',
                            ),
                            height: 110,
                            width: 110,
                            fit: BoxFit.cover,
                            child: InkWell(
                              onTap: () => showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  });
            }
          }),
    );
  }

// suggestion result comming down
  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(child: Text('Search Recipe'));
  }
}
