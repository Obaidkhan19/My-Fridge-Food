import 'package:fridgefood/Models/ingredient.dart';
import 'package:fridgefood/Models/items.dart';
import 'package:fridgefood/Models/recipe.dart';
import 'package:fridgefood/View/Widgets/MyButton.dart';
import 'package:fridgefood/View/Widgets/text_input_field.dart';
import 'package:fridgefood/constants.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fridgefood/utils/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddIngredient extends StatefulWidget {
  Recipe robj;
  AddIngredient({required this.robj, super.key});

  @override
  State<AddIngredient> createState() => _AddIngredientState();
}

class _AddIngredientState extends State<AddIngredient> {
  @override
  void initState() {
    super.initState();
    allnamesapi();
  }

  bool isOpen = false;
  String selectedoptiong = 'Gram';
  String selectedoptionml = 'MiliLiter';
  List<String> kgunitList = [
    'KiloGram',
    'Gram',
  ];
  List<String> lunitList = [
    'Liter',
    'MiliLiter',
  ];

  String id = 'fridgeid';
  Future<int?> getIdFromSharedPreferences() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(id);
  }

  List<Items> fvlist = [];
  Future<List<Items>> allnamesapi() async {
    final fridgeid = await getIdFromSharedPreferences();
    final response = await http
        .get(Uri.parse('$ip/fridgeitem/FridgeItemsNames?fid=$fridgeid'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      fvlist.clear();
      // sucess
      for (Map i in data) {
        fvlist.add(Items.fromJson(i));
      }
      return fvlist;
    } else {
      return fvlist;
    }
  }

//  List<String> itemunitlist = [];
//  List<String> ilist = [];
// // FRIDGE DETAIL
//   Future<List<Items>> itemapi() async {
//     final response =
//         await http.get(Uri.parse('$ip/fridge/FridgeDetail?fid=$fridgeidd'));
//     var data = jsonDecode(response.body.toString());

//     if (response.statusCode == 200) {
//       ilist.clear();
//       itemunitlist.clear();
//       // success
//       for (Map i in data) {
//         Items item= Items.fromJson(i);
//         ilist.add(item);
//         itemunitlist.add(item.itemunit!);
//       }
//       return ilist;
//     } else {
//       return ilist;
//     }
//   }

  int? _selectedIngredientId;
  String? _selectedItemUnit;
  TextEditingController quantityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    int recipeid = widget.robj.id!;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          backgroundColor: themeColor,
          title: const Text(
            'Add an Ingredient',
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Autocomplete<Items>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable.empty();
                    }
                    return fvlist.where((item) => item.name!
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase()));
                  },
                  onSelected: (Items selectedItem) {
                    setState(() {
                      _selectedIngredientId = selectedItem.id;
                      _selectedItemUnit = selectedItem.itemUnit;
                    });
                  },
                  displayStringForOption: (Items option) => option.name!,
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    return TextFormField(
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(bottom: 25, left: 20),
                        labelText: "Select Ingredient",
                        labelStyle:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        floatingLabelStyle: TextStyle(color: themeColor),
                        fillColor: themeColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: themeColor,
                          ),
                        ),
                      ),
                      controller: textEditingController,
                      focusNode: focusNode,
                      onFieldSubmitted: (String value) {
                        final selectedItem = fvlist.firstWhere((item) =>
                            item.name!.toLowerCase() == value.toLowerCase());
                        setState(() {
                          _selectedIngredientId = selectedItem.id;
                          _selectedItemUnit = selectedItem.itemUnit;
                        });
                      },
                    );
                  },
                ),
              ),

              // FutureBuilder<List<Items>>(
              //     future: allnamesapi(),
              //     builder: (context, AsyncSnapshot<List<Items>> snapshot) {
              //       if (snapshot.hasData) {
              //         final ingredients = snapshot.data;
              //         return Padding(
              //           padding: const EdgeInsets.all(20.0),
              //           child: DropdownButtonFormField<int>(
              //             decoration: InputDecoration(
              //               contentPadding:
              //                   const EdgeInsets.only(bottom: 25, left: 20),
              //               labelText: "Select Name",
              //               labelStyle: const TextStyle(
              //                   fontSize: 20, color: Colors.black),
              //               floatingLabelStyle:
              //                   const TextStyle(color: themeColor),
              //               fillColor: themeColor,
              //               enabledBorder: OutlineInputBorder(
              //                 borderRadius: BorderRadius.circular(5),
              //                 borderSide: const BorderSide(
              //                   color: Colors.black,
              //                 ),
              //               ),
              //               focusedBorder: OutlineInputBorder(
              //                 borderRadius: BorderRadius.circular(5),
              //                 borderSide: const BorderSide(
              //                   color: themeColor,
              //                 ),
              //               ),
              //             ),
              //             value: _selectedIngredientId,
              //             onChanged: (value) {
              //               final selectedItem = ingredients
              //                   .firstWhere((item) => item.id == value);
              //               setState(() {
              //                 _selectedIngredientId = value;
              //                 _selectedItemUnit = selectedItem.itemUnit;
              //               });
              //             },
              //             items: ingredients!.map((ingredient) {
              //               return DropdownMenuItem<int>(
              //                 value: ingredient.id,
              //                 child: Text(ingredient.name.toString()),
              //               );
              //             }).toList(),
              //           ),
              //         );
              //       } else {
              //         return const CircularProgressIndicator();
              //       }
              //     }),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextInputField(
                  controller: quantityController,
                  labelText: 'Quantity',
                  icon: Icons.dining_outlined,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (_selectedItemUnit == 'kgorg')
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            isOpen = !isOpen;
                            setState(() {});
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(selectedoptiong),
                                  Icon(isOpen
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (isOpen)
                          ListView(
                              primary: true,
                              shrinkWrap: true,
                              children: kgunitList
                                  .map((e) => Container(
                                        decoration: BoxDecoration(
                                          color: selectedoptiong == e
                                              ? themeColor
                                              : Colors.grey.shade300,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              selectedoptiong = e;
                                              isOpen = false;
                                              setState(() {});
                                            },
                                            child: Text(e),
                                          ),
                                        ),
                                      ))
                                  .toList()),
                      ],
                    ),
                  ),
                ),
              if (_selectedItemUnit == 'lorml')
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            isOpen = !isOpen;
                            setState(() {});
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(selectedoptionml),
                                  Icon(isOpen
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (isOpen)
                          ListView(
                              primary: true,
                              shrinkWrap: true,
                              children: lunitList
                                  .map((e) => Container(
                                        decoration: BoxDecoration(
                                          color: selectedoptionml == e
                                              ? themeColor
                                              : Colors.grey.shade300,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              selectedoptionml = e;
                                              isOpen = false;
                                              setState(() {});
                                            },
                                            child: Text(e),
                                          ),
                                        ),
                                      ))
                                  .toList()),
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyButton(
                      text: 'Done',
                      backgroundColor: themeColor,
                      buttonwidth: 150,
                      onPress: () async {
                        if (_selectedIngredientId == null) {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Alert"),
                                content: const Text("Select Ingredient."),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("OK"),
                                  )
                                ],
                              );
                            },
                          );
                        } else if (_selectedIngredientId != null) {
                          Ingredient i = Ingredient();
                          i.recipeId = recipeid;
                          i.fridgeitemId = _selectedIngredientId;
                          i.ingQuantityoriginal =
                              double.parse(quantityController.text.toString());
                          // if (selectedoptiong == 'KiloGram') {
                          //   i.ingUnit = 'kg';
                          // } else if (selectedoptiong == 'Gram') {
                          //   i.ingUnit = 'g';
                          // } else if (selectedoptionml == 'Liter') {
                          //   i.ingUnit = 'l';
                          // } else if (selectedoptionml == 'MiliLiter') {
                          //   i.ingUnit = 'ml';
                          // } else {
                          //   i.ingUnit = '';
                          // }
                          if (_selectedItemUnit == 'kgorg') {
                            i.ingUnitoriginal =
                                selectedoptiong == 'KiloGram' ? 'kg' : 'g';
                          } else if (_selectedItemUnit == 'lorml') {
                            i.ingUnitoriginal =
                                selectedoptionml == 'Liter' ? 'l' : 'ml';
                          } else {
                            i.ingUnitoriginal = null;
                          }
                          await i.addingredient();
                          Navigator.pop(context);
                        }
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
    );
  }
}
