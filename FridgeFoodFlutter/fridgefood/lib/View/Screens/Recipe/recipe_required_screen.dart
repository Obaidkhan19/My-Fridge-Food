import 'package:flutter/material.dart';
import 'package:fridgefood/Models/ingredient.dart';
import 'package:fridgefood/Models/shoppinglist.dart';
import 'package:fridgefood/constants.dart';
import 'package:fridgefood/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeRequired extends StatefulWidget {
  final List<Ingredient> unavailableIngredients;
  const RecipeRequired({required this.unavailableIngredients, super.key});

  @override
  State<RecipeRequired> createState() => _RecipeRequiredState();
}

class _RecipeRequiredState extends State<RecipeRequired> {
  //TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future<int?> getIdFromSharedPreferences() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(id);
  }

  String id = 'fridgeid';
  int? userid;
  String? name;
  void getdata() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userid = sp.getInt('userid');
    name = sp.getString('username');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: themeColor,
        title: const Text(
          'Required Ingredients',
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
      body: ListView.builder(
        itemCount: widget.unavailableIngredients.length,
        itemBuilder: (BuildContext context, int index) {
          String itemname = widget.unavailableIngredients[index].itemName!;
          String unit = widget.unavailableIngredients[index].requiredUnit ?? '';
          double? quantity1 =
              widget.unavailableIngredients[index].requiredQuantity ?? 0.0;
          String quantityString = quantity1?.toStringAsFixed(1) ?? "0.0";
          String quantity = quantityString.endsWith(".0")
              ? quantityString.substring(0, quantityString.length - 2)
              : quantityString;
          // controller.text = '$name needs $quantity $unit $itemname';
          TextEditingController controller = TextEditingController(
            text: '$name needs $quantity $unit $itemname',
          );
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 37, 11, 11),
                borderRadius: BorderRadius.circular(14.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                leading: Text(
                  itemname,
                  style: const TextStyle(fontSize: 30, color: Colors.white),
                ),
                title: Row(
                  children: [
                    Text(
                      quantity,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      unit,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                trailing: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Add to Shopping List'),
                            content: TextFormField(
                              controller: controller,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeColor),
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  'CANCEL',
                                  style: TextStyle(color: themeColor),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'ADD',
                                  style: TextStyle(color: themeColor),
                                ),
                                onPressed: () async {
                                  // ADD TO SHOPPING LIST
                                  String head = 'Item Order';
                                  Shoppinglist s = Shoppinglist();
                                  final fridgeid =
                                      await getIdFromSharedPreferences();
                                  s.fridgeId = fridgeid;
                                  s.senderId = userid;
                                  s.body = controller.text;
                                  s.header = head;
                                  await s.addtoshoppinglistapi();
                                  Utils.snackBar("Added to Cart", context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.add_shopping_cart_outlined,
                      color: Colors.white,
                      size: 30,
                    )),
              ),
            ),
          );
        },
      ),
    );
  }
}
