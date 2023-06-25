import 'package:fridgefood/Models/ingredient.dart';
import 'package:fridgefood/Models/items.dart';
import 'package:fridgefood/View/Widgets/MyButton.dart';
import 'package:fridgefood/View/Widgets/add_Row.dart';
import 'package:fridgefood/View/Widgets/text_input_field.dart';
import 'package:fridgefood/constants.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fridgefood/utils/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditIngredient extends StatefulWidget {
  Ingredient ingobj;
  EditIngredient({required this.ingobj, super.key});

  @override
  State<EditIngredient> createState() => _EditIngredientState();
}

class _EditIngredientState extends State<EditIngredient> {
  @override

  // GETTING DATA USING OBJECT

  //   late TextEditingController _nameController;
  // late TextEditingController _ageController;

  // @override
  // void initState() {
  //   super.initState();
  //   _nameController = TextEditingController(text: widget.myObject.name);
  //   _ageController = TextEditingController(text: widget.myObject.age.toString());
  // }

  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _ageController.dispose();
  //   super.dispose();
  // }
  late TextEditingController quantityController;

  bool isOpen = false;

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

  String? selectedoption;
  @override
  void initState() {
    super.initState();
    allnamesapi();
    double? quantity1 = widget.ingobj.ingQuantityoriginal;
    String quantityString = quantity1?.toStringAsFixed(1) ??
        "0.0"; // convert double to string and round to 1 decimal place
    String quantity = quantityString.endsWith(".0")
        ? quantityString.substring(0, quantityString.length - 2)
        : quantityString;
    double roundedQuantity = quantity1!;
    // remove 0 after point
    String roundedQuantityString = roundedQuantity.toString();
    if (roundedQuantityString.contains('.') &&
        roundedQuantityString.endsWith('0')) {
      roundedQuantityString =
          roundedQuantityString.replaceAll(RegExp(r'0*$'), '');
      if (roundedQuantityString.endsWith('.')) {
        roundedQuantityString = roundedQuantityString.substring(
            0, roundedQuantityString.length - 1);
      }
    }
    quantityController = TextEditingController(text: roundedQuantityString);
    String unit = widget.ingobj.ingUnitoriginal.toString();
    if (unit == 'g' || unit == 'kg') {
      _selectedItemUnit = 'kgorg';
    }
    if (unit == 'l' || unit == 'ml') {
      _selectedItemUnit = 'lorml';
    }
    String selectedoption;

    if (unit == 'g') {
      selectedoption = 'Gram';
    } else if (unit == 'kg') {
      selectedoption = 'KiloGram';
    } else if (unit == 'l') {
      selectedoption = 'Liter';
    } else if (unit == 'ml') {
      selectedoption = 'MiliLiter';
    } else {
      selectedoption = '';
    }
    selectedoptiong = selectedoption;
    selectedoptionml = selectedoption;
  }

  // double?quantity;
  int? _selectedIngredientId;
  String? _selectedItemUnit;
  String selectedoptiong = '';
  String selectedoptionml = '';
  List<String> kgunitList = [
    'KiloGram',
    'Gram',
  ];
  List<String> mlunitList = [
    'Liter',
    'MiliLiter',
  ];

  @override
  Widget build(BuildContext context) {
    int ingid = widget.ingobj.id!;
    // quantityController.text = widget.ingobj.quantity.toString();
    String name = widget.ingobj.itemName.toString();
    // String selectedoption = widget.ingobj.ingUnitoriginal.toString();
    int initialitemid = widget.ingobj.fridgeitemId!;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            AddFirstRow(
              text: 'Edit Ingredient    ',
              onPress: () => Navigator.of(context).pop(),
            ),
            const Divider(
              thickness: 2,
              color: Colors.black,
            ),
            const SizedBox(
              height: 10,
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
                      labelText: name,
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

                        if (_selectedItemUnit == "kgorg") {
                          selectedoption = 'Gram';
                          selectedoptiong = 'Gram';
                        }
                        if (_selectedItemUnit == "lorml") {
                          selectedoption = 'MiliLiter';
                          selectedoptionml = 'MiliLiter';
                        }
                        if (_selectedItemUnit == "nounit") {
                          selectedoption = '';
                        }
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
            //               labelText: name,
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
            //                 if (_selectedItemUnit == "kgorg") {
            //                   selectedoption = 'Gram';
            //                   selectedoptiong = 'Gram';
            //                 }
            //                 if (_selectedItemUnit == "lorml") {
            //                   selectedoption = 'MiliLiter';
            //                   selectedoptionml = 'MiliLiter';
            //                 }
            //                 if (_selectedItemUnit == "nounit") {
            //                   selectedoption = '';
            //                 }
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            children: mlunitList
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
              padding: const EdgeInsets.all(20.0),
              child: TextInputField(
                controller: quantityController,
                labelText: 'Quantity',
                icon: Icons.dining_outlined,
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
                      Ingredient i = Ingredient();
                      i.id = ingid;
                      i.fridgeitemId = _selectedIngredientId ?? initialitemid;
                      i.ingQuantityoriginal =
                          double.parse(quantityController.text.toString());
                      // if (selectedoption1 != null) {
                      //   if (selectedoption1 == 'KiloGram') {
                      //     i.ingUnit = 'kg';
                      //   } else if (selectedoption1 == 'Gram') {
                      //     i.ingUnit = 'g';
                      //   } else if (selectedoption1 == 'Liter') {
                      //     i.ingUnit = 'l';
                      //   } else if (selectedoption1 == 'MiliLiter') {
                      //     i.ingUnit = 'ml';
                      //   } else if (selectedoption1 == 'Single entity') {
                      //     i.ingUnit = '';
                      //   } else {
                      //     i.ingUnit = '';
                      //   }
                      // } else {
                      //   //also if else on selected option
                      // //  i.ingUnit = selectedoption;
                      // }
                      if (_selectedItemUnit == 'kgorg') {
                        i.ingUnitoriginal =
                            selectedoptiong == 'KiloGram' ? 'kg' : 'g';
                      } else if (_selectedItemUnit == 'lorml') {
                        i.ingUnitoriginal =
                            selectedoptionml == 'Liter' ? 'l' : 'ml';
                      } else {
                        i.ingUnitoriginal = selectedoption;
                      }
                      await i.editingredient();

                      Navigator.pop(context);
                    },
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
