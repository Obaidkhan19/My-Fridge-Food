import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fridgefood/Models/shoppinglist.dart';
import 'package:fridgefood/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../Models/items.dart';
import '../../../utils/utilities.dart';
import '../../../constants.dart';
import '../../Widgets/MyButton.dart';
import '../../Widgets/text_input_field.dart';

class AddToCart extends StatefulWidget {
  const AddToCart({super.key});

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  @override
  void initState() {
    super.initState();
    getdata();
    allnamesapi();
  }

  void getdata() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userid = sp.getInt('userid');
    username = sp.getString('username');
    setState(() {});
  }

  int? userid;
  String? username;
  bool isOpen = false;
  String selectedoptiong = 'Gram';
  String selectedoptionml = 'MiliLiter';
  String selectedoption = 'No Unit';
  List<String> unitList = ['KiloGram', 'Gram', 'Liter', 'MiliLiter', 'No Unit'];
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
    //final fridgeid = await getIdFromSharedPreferences();
    final response = await http.get(Uri.parse('$ip/fridgeitem/AllItemsNames'));
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

  String? _selectedItem;
  String? _selectedItemUnit;
  TextEditingController quantityController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          backgroundColor: themeColor,
          title: const Text(
            'Add to Shopping List',
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
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable.empty();
                    }
                    return fvlist
                        .where((item) => item.name!
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase()))
                        .map((item) => item.name!);
                  },
                  onSelected: (String item) {
                    _selectedItem = item;
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    textEditingController.text = _selectedItem ?? '';
                    return TextFormField(
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(bottom: 25, left: 20),
                        labelText: "Select Name",
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
                      onChanged: (value) {
                        _selectedItem = value;
                      },
                      onFieldSubmitted: (_) {
                        onFieldSubmitted();
                      },
                    );
                  },
                ),
              ),
              // FutureBuilder<List<Items>>(
              //     future: allnamesapi(),
              //     builder: (context, AsyncSnapshot<List<Items>> snapshot) {
              //       if (snapshot.hasData) {
              //         final items = snapshot.data;
              //         return Padding(
              //           padding: const EdgeInsets.all(20.0),
              //           child: DropdownButtonFormField<String>(
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
              //             value: _selectedItem,
              //             onChanged: (value) {
              //               // setState(() {
              //               //   _selectedItem = value;
              //               // });
              //               final selectedItem =
              //                   items.firstWhere((item) => item.name == value);
              //               setState(() {
              //                 _selectedItemUnit = selectedItem.itemUnit;
              //                 _selectedItem = value;
              //               });
              //             },
              //             items: items!.map((item) {
              //               return DropdownMenuItem<String>(
              //                 value: item.name,
              //                 child: Text(item.name.toString()),
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
                                Text(selectedoption),
                                //  Text(selectedoptiong),
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
                            children: unitList
                                .map((e) => Container(
                                      decoration: BoxDecoration(
                                        // color: selectedoptiong == e
                                        color: selectedoption == e
                                            ? themeColor
                                            : Colors.grey.shade300,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            //selectedoptiong = e;
                                            selectedoption = e;
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
                      text: 'Add',
                      backgroundColor: themeColor,
                      buttonwidth: 150,
                      onPress: () async {
                        Shoppinglist s = Shoppinglist();
                        double? quantity1 =
                            double.parse(quantityController.text.toString());
                        String quantityString = quantity1.toStringAsFixed(1);
                        String quantity = quantityString.endsWith(".0")
                            ? quantityString.substring(
                                0, quantityString.length - 2)
                            : quantityString;

                        String? unit;
                        if (selectedoption == 'KiloGram') {
                          unit = 'kg';
                        } else if (selectedoption == 'Gram') {
                          unit = 'g';
                        } else if (selectedoption == 'Liter') {
                          unit = 'l';
                        } else if (selectedoption == 'MiliLiter') {
                          unit = 'ml';
                        } else if (selectedoption == 'No Unit') {
                          unit = '';
                        } else {
                          unit = '';
                        }
                        // if (_selectedItemUnit == 'kgorg') {
                        //   unit = selectedoptiong == 'KiloGram' ? 'kg' : 'g';
                        // } else if (_selectedItemUnit == 'lorml') {
                        //   unit = selectedoptionml == 'Liter' ? 'l' : 'ml';
                        // } else {
                        //   unit = '';
                        // }
                        String body = "$username need $quantity $unit $_selectedItem.";
                        String head = 'Item Order';
                        final fridgeid = await getIdFromSharedPreferences();
                        s.fridgeId = fridgeid;
                        s.senderId = userid;
                        s.body = body;
                        s.header = head;
                        String? response = await s.addtoshoppinglistapi();

                        Utils.snackBar('Added to Cart', context);
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
      ),
    );
  }
}
