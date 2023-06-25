import 'package:flutter/Cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fridgefood/Models/ingredient.dart';
import 'package:fridgefood/Models/recipe_order.dart';
import 'package:fridgefood/Models/user.dart';
import 'package:fridgefood/Provider/recipe_detail_provider.dart';
import 'package:fridgefood/View/Screens/Recipe/add_ingredient.dart';
import 'package:fridgefood/View/Screens/Recipe/edit_recipe.dart';
import 'package:fridgefood/View/Screens/Recipe/recipe_required_screen.dart';
import 'package:fridgefood/View/Widgets/Meal_DropDown.dart';
import 'package:fridgefood/View/Widgets/MyButton.dart';
import 'package:fridgefood/constants.dart';
import 'package:fridgefood/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Models/recipe.dart';
import '../../../utils/utilities.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'edit_ingredient.dart';

class RecipeDetail extends StatefulWidget {
  Recipe robj;
  RecipeDetail(this.robj);

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  Color color = Colors.white;

  @override
  void initState() {
    super.initState();
    allconnectedusersapi();
    getdata();
    servings = widget.robj.servings!;
  }

  //DateTime mealdate = DateTime.now();

  void getdata() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    fridgeid = sp.getInt('fridgeid');
    userid = sp.getInt('userid');
    name = sp.getString('username');
    role = sp.getString('role');
    userOrderKey = 'userOrder_$fridgeid';
    // setState(() {});
  }

  String? userOrderKey;
  String? name;
  int? fridgeid;
  String? role;
  int? userid;
  Widget makeDismissible({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );

  List<User> allconnectedusers = [];
  Future<List<User>> allconnectedusersapi() async {
    final response = await http.get(Uri.parse(
        '$ip/user/GetAllConnectedUsersByFridgeId?fid=$fridgeid&uid=$userid'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      allconnectedusers.clear();
      // sucess
      for (Map i in data) {
        allconnectedusers.add(User.fromJson(i));
      }
      // allconnectedusers.removeWhere((user) => user.id == userid);
      return allconnectedusers;
    } else {
      return allconnectedusers;
    }
  }

  Future<List<String>?> getUserOrder(int fridgeId) async {
    final userOrderKey = 'userOrder_$fridgeId';
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getStringList(userOrderKey);
  }

  TextEditingController controller = TextEditingController();

  List<Ingredient> unavailableIngredients = [];

  int servings = 0;

  @override
  Widget build(BuildContext context) {
    bool avaliable = true;
    int recipeid = widget.robj.id!;
    List<Ingredient> inglist = [];
    Future<List<Ingredient>> ingredientapi() async {
      final response =
          await http.get(Uri.parse('$ip/recipe/RecipeDetail?rid=$recipeid'));
      var data = jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        // inglist.clear();
        // sucesss
        for (Map i in data) {
          inglist.add(Ingredient.fromJson(i));
        }
        return inglist;
      } else {
        return inglist;
      }
    }

    final provider = Provider.of<RecipeDetailProvider>(context, listen: false);
    String mealDateString =
        provider.mealdate.toIso8601String().substring(0, 10);
    // provider.setservings = servings;
    String dish = widget.robj.name!;

    TextEditingController recipeController = TextEditingController();
    List<String> quantitylist = [];
    List<int> idlist = [];
    List<String> unitlist = [];
    // Ingredient? ingobj;
    return makeDismissible(
      child: DraggableScrollableSheet(
        initialChildSize: 0.87,
        minChildSize: 0.5,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(29),
            ),
          ),
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Recipe Detail',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(imgpath + widget.robj.image!),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),

                        Text(
                          widget.robj.name.toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Serving',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: themeColor,
                            borderRadius: BorderRadius.circular(18),
                          ),

                          // SERVINGS
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (servings != 1) {
                                      servings--;
                                      setState(() {});
                                    }

                                    // if (servings != 1) {
                                    //   provider.incrementservings();
                                    // }
                                  },
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  servings.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    servings++;
                                    setState(() {});
                                    //  provider.decrementservings();
                                  },
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  //INGREDIENTS
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          'Ingredients',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  FutureBuilder(
                    future: ingredientapi(),
                    builder:
                        (context, AsyncSnapshot<List<Ingredient>> snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      } else {
                        // OLD  (VIEW REQUIRED AMOUNT BUTTON SHOW)
                        // final hasUnavailable = snapshot.data!
                        //     .any((ingredient) => !ingredient.avaliable!);
                        // final showAddButton = hasUnavailable;
                        // if (showAddButton) {
                        //   avaliable = false;
                        // }

                        return Column(
                          children: [
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: inglist.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Ingredient ingobj = inglist[index];
                                  int ingid = snapshot.data![index].id!;
                                  double? quantity1 =
                                      snapshot.data![index].ingQuantityoriginal;
                                  String quantityString =
                                      quantity1?.toStringAsFixed(1) ?? "0.0";
                                  String quantity =
                                      quantityString.endsWith(".0")
                                          ? quantityString.substring(
                                              0, quantityString.length - 2)
                                          : quantityString;
                                  String? quantityunit =
                                      snapshot.data![index].ingUnitoriginal;
                                  String? unit =
                                      snapshot.data![index].ingUnit ?? 'nounit';
                                  // quantity in small unit

                                  bool? isavaliable =
                                      snapshot.data![index].avaliable;
                                  int? fridgeitemid =
                                      snapshot.data![index].fridgeitemId;
                                  double? avaliableQuantity =
                                      snapshot.data![index].avaliableQuantity;

                                  // OLD (ADD NOTAVALIABLE ING TO LIST)(new at bottom)
                                  // unavailableIngredients = snapshot.data!
                                  //     .where((ingredient) =>
                                  //         !ingredient.avaliable!)
                                  //     .toList();

                                  const availableColor = Color(0xFF000000);
                                  const unavailableColor = Color(0xFFFF0000);

                                  // Calculate adjusted quantity based on servings
                                  // START

                                  double roundedQuantity = quantity1!;
                                  // CONVERT QUANTITY BASED ON SERVINGS
                                  if (quantityunit == null) {
                                    roundedQuantity = (quantity1 * servings) /
                                        widget.robj.servings!;
                                    roundedQuantity =
                                        roundedQuantity.ceilToDouble();
                                  } else {
                                    roundedQuantity = (quantity1 * servings) /
                                        widget.robj.servings!;
                                    roundedQuantity = double.parse(
                                        roundedQuantity.toStringAsFixed(2));
                                  }

                                  double quantityToCheckAvaliablilty =
                                      roundedQuantity;
                                  // CONVERT  QUANTITY IN SMALL UNIT IF USING IS KG OR L
                                  if (quantityunit == 'kg' ||
                                      quantityunit == 'l') {
                                    quantityToCheckAvaliablilty =
                                        roundedQuantity * 1000;
                                  }

                                  // CHECK AVAILIBILITY (by converting kg or l to small unit)
                                  // for all units
                                  if (quantityToCheckAvaliablilty >
                                      avaliableQuantity!) {
                                    isavaliable = false;
                                  } else {
                                    isavaliable = true;
                                  }

                                  // END

                                  // VIEW REQUIRED AMOUNT BUTTON  & ORDER VISIBILITY
                                  if (isavaliable == false) {
                                    avaliable = false;
                                    // ADD REQUIRED TO LIST
                                    Ingredient i = Ingredient();
                                    String itemName =
                                        snapshot.data![index].itemName!;
                                    double missingquantity = 0.0;
                                    String missingunit = quantityunit ?? '';
                                    print(quantityunit);
                                    if (quantityunit == 'g' ||
                                        quantityunit == 'ml' ||
                                        quantityunit == null) {
                                      missingquantity =
                                          roundedQuantity - avaliableQuantity;
                                    } else if (quantityunit == 'kg') {
                                      double rq = roundedQuantity * 1000;
                                      missingunit = 'g';
                                      missingquantity = rq - avaliableQuantity;
                                    } else if (quantityunit == 'l') {
                                      double rq = roundedQuantity * 1000;
                                      missingunit = 'ml';
                                      missingquantity = rq - avaliableQuantity;
                                    }

                                    // print(missingquantity.toString() +
                                    //     missingunit +
                                    //     'and ' +
                                    //     roundedQuantity.toString() +
                                    //     "and" +
                                    //     avaliableQuantity.toString());
                                    // print(missingunit);
                                    // Check if an Ingredient with the same itemName already exists in the list
                                    Ingredient existingIngredient =
                                        unavailableIngredients.firstWhere(
                                            (ingredient) =>
                                                ingredient.itemName == itemName,
                                            orElse: () => Ingredient());

                                    if (existingIngredient.itemName == null) {
                                      // If no existing Ingredient found, create a new one
                                      Ingredient i = Ingredient();
                                      print(missingquantity.toString() +
                                          missingunit);
                                      i.itemName = itemName;
                                      i.requiredQuantity = missingquantity;
                                      i.requiredUnit = missingunit;
                                      unavailableIngredients.add(i);
                                    } else {
                                      // If existing Ingredient found, update its quantity and quantityunit
                                      existingIngredient.requiredQuantity =
                                          missingquantity;
                                      existingIngredient.requiredUnit =
                                          missingunit;
                                    }
                                  }

                                  // remove 0 after point
                                  String roundedQuantityString =
                                      roundedQuantity.toString();
                                  if (roundedQuantityString.contains('.') &&
                                      roundedQuantityString.endsWith('0')) {
                                    roundedQuantityString =
                                        roundedQuantityString.replaceAll(
                                            RegExp(r'0*$'), '');
                                    if (roundedQuantityString.endsWith('.')) {
                                      roundedQuantityString =
                                          roundedQuantityString.substring(0,
                                              roundedQuantityString.length - 1);
                                    }
                                  }
                                  // FOR COOK RECIPE
                                  quantitylist.add(roundedQuantity.toString());
                                  idlist.add(fridgeitemid!);
                                  unitlist.add(quantityunit ?? "");
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 40),
                                    child: ListTile(
                                      minLeadingWidth: 120,
                                      leading: Text(
                                        snapshot.data![index].itemName
                                            .toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      title: Text(
                                        // CHANGE COLOR TO RED FOR LOW STOCK
                                        quantityunit.toString() == 'null'
                                            ? roundedQuantityString.toString()
                                            : roundedQuantityString.toString() +
                                                quantityunit.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: isavaliable == true
                                              ? availableColor
                                              : unavailableColor,
                                        ),
                                      ),
                                      trailing: Wrap(
                                        spacing: 0, // space between two icons
                                        children: <Widget>[
                                          IconButton(
                                            onPressed: () async {
                                              final value =
                                                  await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditIngredient(
                                                          ingobj: ingobj),
                                                ),
                                              );
                                              setState(() {
                                                color = color == Colors.white
                                                    ? Colors.grey
                                                    : Colors.white;
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 30,
                                            ),
                                          ), // icon-1
                                          IconButton(
                                            onPressed: () async {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text("Alert"),
                                                    content: const Text(
                                                        "Delete Ingredient."),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () async {
                                                          Ingredient i =
                                                              Ingredient();
                                                          i.id = ingid;
                                                          await i
                                                              .deleteingredientapi();
                                                          inglist
                                                              .removeAt(index);
                                                          setState(() {});
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          "Remove",
                                                          style: TextStyle(
                                                              color:
                                                                  themeColor),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.delete_outline_rounded,
                                              size: 30,
                                            ),
                                          ), // icon-2
                                        ],
                                      ),
                                    ),
                                  );
                                }),

                            const SizedBox(
                              height: 15,
                            ),
                            NewButton(
                              text: 'Add Ingredient',
                              backgroundColor: themeColor,
                              buttonwidth: 250,
                              onPress: () async {
                                final value = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddIngredient(robj: widget.robj)),
                                );
                                setState(() {
                                  color = color == Colors.white
                                      ? Colors.grey
                                      : Colors.white;
                                });
                              },
                              textColor: Colors.white,
                            ),
                            const SizedBox(
                              height: 15,
                            ),

                            NewButton(
                              text: 'Cook Recipe',
                              backgroundColor: themeColor,
                              buttonwidth: 200,
                              onPress: () async {
                                if (avaliable == false) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Alert"),
                                        content: const Text(
                                            "Not Enough Ingredient."),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "OK",
                                              style:
                                                  TextStyle(color: themeColor),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  ConsumeIngredients ci = ConsumeIngredients();
                                  ci.fridgeItemIds = idlist;
                                  ci.quantities = quantitylist;
                                  ci.units = unitlist;
                                  String? res =
                                      await ci.ConsumeIngredientsApi();
                                  if (res ==
                                      "\"Ingredients consumed successfully\"") {
                                    Utils.snackBar('Recipe Cooked', context);
                                  }
                                  setState(() {});
                                }
                              },
                              textColor: Colors.white,
                            ),
                            const SizedBox(
                              height: 15,
                            ),

                            // VIEW REQUIRED AMOUNT
                            //  if (showAddButton) // OLD BUTTON SHOW LOGIC
                            NewButton(
                              text: 'View Required Amount',
                              backgroundColor: Colors.red,
                              buttonwidth: 300,
                              textColor: Colors.white,
                              onPress: () {
                                if (avaliable == true) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Alert"),
                                        content: const Text(
                                            "You have Enough Ingredient."),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "OK",
                                              style:
                                                  TextStyle(color: themeColor),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  // for (Ingredient ingredient
                                  //     in unavailableIngredients) {
                                  //   print("Ingredient: ${ingredient.itemName}");
                                  //   print(
                                  //       "Missing Quantity: ${ingredient.requiredQuantity}");
                                  //   print(
                                  //       "Missing Unit: ${ingredient.requiredUnit}");
                                  //   print(""); // Empty line for separation
                                  // }
                                  // print(unavailableIngredients.length);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RecipeRequired(
                                          unavailableIngredients:
                                              unavailableIngredients),
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),

                            // ORDER RECIPE
                            Consumer<RecipeDetailProvider>(
                                builder: (context, value, child) {
                              return CupertinoButton(
                                child: Text(
                                  "${value.mealdate.day}-${value.mealdate.month}-${value.mealdate.year}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: themeColor),
                                ),
                                onPressed: () {
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          SizedBox(
                                            height: 250,
                                            child: CupertinoDatePicker(
                                              backgroundColor: Colors.white,
                                              initialDateTime: value.mealdate,
                                              onDateTimeChanged:
                                                  (DateTime newDate) {
                                                // setState(() {
                                                //   value.updateMealDate(newDate);
                                                //   mealDateString = value.mealdate
                                                //       .toIso8601String()
                                                //       .substring(0, 10);
                                                // });
                                                value.updateMealDate(newDate);
                                                mealDateString = value.mealdate
                                                    .toIso8601String()
                                                    .substring(0, 10);
                                              },
                                              mode:
                                                  CupertinoDatePickerMode.date,
                                            ),
                                          ));
                                },
                              );
                            }),
                            //  DROP DOWN
                            SizedBox(
                              width: 200,
                              child: MealDropdown(
                                  onUnitSelected: provider.onMealSelected),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            //  ORDER RECIPE
                            NewButton(
                              text: 'Order Recipe',
                              backgroundColor: Colors.red,
                              buttonwidth: 200,
                              textColor: Colors.white,
                              onPress: () async {
                                if (!avaliable) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Insufficient Ingredient Quantity'),
                                        content: const Text(
                                            'You dont have enough quantites, still you can order!'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text(
                                              'CANCEL',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              'PROCEED',
                                              style:
                                                  TextStyle(color: themeColor),
                                            ),
                                            onPressed: () async {
                                              SharedPreferences sp =
                                                  await SharedPreferences
                                                      .getInstance();
                                              showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: const Text(
                                                      "Connected Users"),
                                                  content: FutureBuilder(
                                                    future:
                                                        allconnectedusersapi(),
                                                    builder: (context,
                                                        AsyncSnapshot<
                                                                List<User>>
                                                            snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return const CircularProgressIndicator();
                                                      } else {
                                                        List<User> userList =
                                                            snapshot.data!;

                                                        Future<List<String>?>
                                                            futureUserOrder =
                                                            getUserOrder(
                                                                fridgeid ?? 0);

                                                        return FutureBuilder(
                                                            future:
                                                                futureUserOrder,
                                                            builder: (context,
                                                                AsyncSnapshot<
                                                                        List<
                                                                            String>?>
                                                                    orderSnapshot) {
                                                              if (!orderSnapshot
                                                                  .hasData) {
                                                                return const CircularProgressIndicator();
                                                              } else {
                                                                List<String>?
                                                                    userIdOrder =
                                                                    orderSnapshot
                                                                        .data;

                                                                if (userIdOrder !=
                                                                    null) {
                                                                  // Sort the userList according to the user ID order
                                                                  userList.sort((a, b) => userIdOrder
                                                                      .indexOf(a
                                                                          .id
                                                                          .toString())
                                                                      .compareTo(
                                                                          userIdOrder.indexOf(b
                                                                              .id
                                                                              .toString())));
                                                                }
                                                                // print(userIdOrder);
                                                                // print('userList after sorting:');
                                                                // for (var user in userList) {
                                                                //   print(user.name);
                                                                // }
                                                                return SizedBox(
                                                                  width: double
                                                                      .maxFinite,
                                                                  child: ListView
                                                                      .builder(
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemCount: userList
                                                                              .length,
                                                                          itemBuilder:
                                                                              (BuildContext context, int index) {
                                                                            User
                                                                                u =
                                                                                userList[index];
                                                                            int rid =
                                                                                u.userId!;

                                                                            return ListTile(
                                                                              leading: const Icon(
                                                                                Icons.person_outline_outlined,
                                                                                size: 30,
                                                                              ),
                                                                              title: Text(
                                                                                u.name.toString(),
                                                                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                              trailing: IconButton(
                                                                                // ignore: prefer_const_constructors
                                                                                icon: Icon(
                                                                                  Icons.send_outlined,
                                                                                  size: 30,
                                                                                ),
                                                                                onPressed: () async {
                                                                                  // String date =
                                                                                  //     formatDateTime(mealdateTime);
                                                                                  String mealtype = provider.selectedMeal;
                                                                                  recipeController.text = '$name want to have $dish in $mealtype \n ($servings servings)';
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return AlertDialog(
                                                                                        title: const Text('Order Recipe'),
                                                                                        content: TextFormField(
                                                                                          maxLines: 5,
                                                                                          controller: recipeController,
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
                                                                                              'ORDER',
                                                                                              style: TextStyle(color: themeColor),
                                                                                            ),
                                                                                            onPressed: () async {
                                                                                              // CALL API HERE

                                                                                              RecipeOrder ro = RecipeOrder();
                                                                                              ro.title = 'Request Recipe';
                                                                                              ro.body = recipeController.text;
                                                                                              ro.mealDate = mealDateString.toString();
                                                                                              ro.senderId = userid;
                                                                                              ro.recieverId = rid;
                                                                                              ro.reply = '';
                                                                                              ro.mealTime = provider.selectedMeal;
                                                                                              ro.fridgeId = fridgeid;
                                                                                              ro.recipeId = recipeid;
                                                                                              await ro.orderrecipeapi();
                                                                                              provider.resetMealDate();
                                                                                              // provider
                                                                                              //     .resetDropdown();

                                                                                              Navigator.pop(context);
                                                                                              Navigator.pop(context);
                                                                                              Navigator.of(ctx).pop();
                                                                                            },
                                                                                          ),
                                                                                        ],
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                },
                                                                              ),
                                                                            );
                                                                          }),
                                                                );
                                                              }
                                                            });
                                                      }
                                                    },
                                                  ),
                                                  actions: <Widget>[
                                                    Center(
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.of(ctx)
                                                              .pop();
                                                          Navigator.of(ctx)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.red,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  SharedPreferences sp =
                                      await SharedPreferences.getInstance();
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text("Connected Users"),
                                      content: FutureBuilder(
                                        future: allconnectedusersapi(),
                                        builder: (context,
                                            AsyncSnapshot<List<User>>
                                                snapshot) {
                                          if (!snapshot.hasData) {
                                            return const CircularProgressIndicator();
                                          } else {
                                            List<User> userList =
                                                snapshot.data!;

                                            Future<List<String>?>
                                                futureUserOrder =
                                                getUserOrder(fridgeid ?? 0);

                                            return FutureBuilder(
                                                future: futureUserOrder,
                                                builder: (context,
                                                    AsyncSnapshot<List<String>?>
                                                        orderSnapshot) {
                                                  if (!orderSnapshot.hasData) {
                                                    return const CircularProgressIndicator();
                                                  } else {
                                                    List<String>? userIdOrder =
                                                        orderSnapshot.data;

                                                    if (userIdOrder != null) {
                                                      // Sort the userList according to the user ID order
                                                      userList.sort((a, b) =>
                                                          userIdOrder
                                                              .indexOf(a.id
                                                                  .toString())
                                                              .compareTo(userIdOrder
                                                                  .indexOf(b.id
                                                                      .toString())));
                                                    }
                                                    // print(userIdOrder);
                                                    // print('userList after sorting:');
                                                    // for (var user in userList) {
                                                    //   print(user.name);
                                                    // }
                                                    return SizedBox(
                                                      width: double.maxFinite,
                                                      child: ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              userList.length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            User u =
                                                                userList[index];
                                                            int rid = u.userId!;

                                                            return ListTile(
                                                              leading:
                                                                  const Icon(
                                                                Icons
                                                                    .person_outline_outlined,
                                                                size: 30,
                                                              ),
                                                              title: Text(
                                                                u.name
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              trailing:
                                                                  IconButton(
                                                                // ignore: prefer_const_constructors
                                                                icon: Icon(
                                                                  Icons
                                                                      .send_outlined,
                                                                  size: 30,
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  // String date =
                                                                  //     formatDateTime(mealdateTime);
                                                                  String
                                                                      mealtype =
                                                                      provider
                                                                          .selectedMeal;
                                                                  recipeController
                                                                          .text =
                                                                      '$name want to have $dish in $mealtype \n ($servings servings)';
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        title: const Text(
                                                                            'Order Recipe'),
                                                                        content:
                                                                            TextFormField(
                                                                          maxLines:
                                                                              5,
                                                                          controller:
                                                                              recipeController,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            focusedBorder:
                                                                                UnderlineInputBorder(
                                                                              borderSide: BorderSide(color: themeColor),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        actions: <
                                                                            Widget>[
                                                                          TextButton(
                                                                            child:
                                                                                Text(
                                                                              'CANCEL',
                                                                              style: TextStyle(color: themeColor),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          ),
                                                                          TextButton(
                                                                            child:
                                                                                Text(
                                                                              'ORDER',
                                                                              style: TextStyle(color: themeColor),
                                                                            ),
                                                                            onPressed:
                                                                                () async {
                                                                              // CALL API HERE

                                                                              RecipeOrder ro = RecipeOrder();
                                                                              ro.title = 'Request Recipe';
                                                                              ro.body = recipeController.text;
                                                                              ro.mealDate = mealDateString.toString();
                                                                              ro.senderId = userid;
                                                                              ro.recieverId = rid;
                                                                              ro.reply = '';
                                                                              ro.mealTime = provider.selectedMeal;
                                                                              ro.fridgeId = fridgeid;
                                                                              ro.recipeId = recipeid;
                                                                              await ro.orderrecipeapi();
                                                                              provider.resetMealDate();
                                                                              // provider
                                                                              //     .resetDropdown();

                                                                              Navigator.pop(context);
                                                                              Navigator.pop(context);
                                                                            },
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                            );
                                                          }),
                                                    );
                                                  }
                                                });
                                          }
                                        },
                                      ),
                                      actions: <Widget>[
                                        Center(
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            child: const Text(
                                              "Cancel",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      }
                    },
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                  if (role == 'admin' || role == 'owner')
                    NewButton(
                      text: 'Add to Meal',
                      backgroundColor: themeColor,
                      buttonwidth: 200,
                      onPress: () async {
                        String mealtype = provider.selectedMeal;
                        recipeController.text =
                            '$dish \n $mealtype \n $mealDateString';
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Add to Meal'),
                              content: TextFormField(
                                maxLines: 5,
                                controller: recipeController,
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
                                    // CALL API HERE
                                    RecipeOrder ro = RecipeOrder();
                                    ro.title = 'Meal';
                                    ro.mealDate = mealDateString.toString();
                                    ro.reply = 'ok';
                                    ro.mealTime = mealtype;
                                    ro.fridgeId = fridgeid;
                                    ro.recipeId = recipeid;
                                    await ro.addMealapi();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      textColor: Colors.white,
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NewButton(
                          text: 'Edit ',
                          backgroundColor: themeColor,
                          buttonwidth: 150,
                          onPress: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditRecipe(obj: widget.robj),
                              ),
                            );
                          },
                          textColor: Colors.white,
                        ),
                        NewButton(
                          text: 'Delete ',
                          backgroundColor: Colors.red,
                          buttonwidth: 150,
                          onPress: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Alert"),
                                  content: const Text("Delete Recipe."),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        Recipe r = Recipe();
                                        r.id = recipeid;
                                        await r.deleterecipeapi();

                                        Utils.snackBar('Removed', context);
                                        setState(() {});
                                        Navigator.of(context).pop();
                                        Navigator.pop(context, true);
                                      },
                                      child: Text(
                                        "Remove",
                                        style: TextStyle(color: themeColor),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
