import 'package:flutter/material.dart';
import 'package:flutter/Cupertino.dart';
import 'package:fridgefood/Models/all_items.dart';
import 'package:fridgefood/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/stock.dart';
import 'MyButton.dart';

import 'dart:math';

// // MY BUTTON
//               DateTime date = DateTime.now(); // current date and time
// Duration threeDays = Duration(days: 3); // create a Duration object with 3 days
// DateTime threeDaysLater = date.add(threeDays); // add 3 days to the current date and time
// int userFreezingTime = widget.itemobj.userFreezingTime;
// int userFridgeTime = widget.itemobj.userFridgeTime!;
String generateStockLabel(String itemName) {
  Random random = Random();
  int randomNumber =
      random.nextInt(10000); // generates a random number between 0 and 99
  return '$itemName - $randomNumber';
}

class AddStockWidget extends StatefulWidget {
  AllItem itemobj;
  String Freezgval;
  String Fridgegval;
  TextEditingController dayscontroller;
  String selectedDayFreezing;
  final Function(bool) onIsFreezChanged;
  AddStockWidget(
      {required this.itemobj,
      required this.Freezgval,
      required this.Fridgegval,
      required this.dayscontroller,
      required this.selectedDayFreezing,
      required this.onIsFreezChanged,
      super.key});

  @override
  State<AddStockWidget> createState() => _AddStockWidgetState();
}

class _AddStockWidgetState extends State<AddStockWidget> {
  @override
  void initState() {
    super.initState();
    getdata();
  }

  void getdata() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    fridgeid = sp.getInt('fridgeid');
    freezertypee = sp.getInt('freezertype');
  }

  int? freezertypee;

  int? fridgeid;
  final TextEditingController stockQuantityController = TextEditingController();
  bool isOpen = false;
  DateTime purchasedate = DateTime.now();

  bool isFreez = false;
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
  @override
  Widget build(BuildContext context) {
    String name = widget.itemobj.name!;
    String Freezgval = widget.Freezgval;
    String Fridgegval = widget.Fridgegval;
    DateTime expirydate = DateTime.now();

    // FREEZER
    if (isFreez == true && Freezgval == "system") {
      // int itemFreezingTime = widget.itemobj.itemFreezingTime ?? 0;
      // Duration Days = Duration(days: itemFreezingTime);

      int? itemFreezingTime;
      if (freezertypee == 1) {
        itemFreezingTime = 7;
      } else if (freezertypee == 2) {
        itemFreezingTime = 30;
      } else if (freezertypee == 3) {
        itemFreezingTime = 90;
      } else if (freezertypee == 4) {
        itemFreezingTime = 360;
      }
      Duration Days = Duration(days: itemFreezingTime!);
      //  print(itemFreezingTime);
      DateTime newdate = expirydate.add(Days);
      expirydate = newdate;
    } else if (isFreez == true && Freezgval == "custom") {
      int itemFreezingTime = 0;
      if (widget.selectedDayFreezing == 'Day') {
        itemFreezingTime = int.parse(widget.dayscontroller.text) * 1;
      } else if (widget.selectedDayFreezing == 'Month') {
        itemFreezingTime = int.parse(widget.dayscontroller.text) * 30;
      } else if (widget.selectedDayFreezing == 'Year') {
        itemFreezingTime = int.parse(widget.dayscontroller.text) * 365;
      } else {
        itemFreezingTime = 0;
      }
      Duration Days = Duration(days: itemFreezingTime);
      DateTime newdate = expirydate.add(Days);
      expirydate = newdate;
    }

    // FRIDGE
    if (isFreez == false && Fridgegval == "system") {
      int itemFridgeTime = widget.itemobj.itemFridgeTime ?? 0;
      Duration Days = Duration(days: itemFridgeTime);
      DateTime newdate = expirydate.add(Days);
      expirydate = newdate;
    } else if (isFreez == false && Fridgegval == "custom") {
      int itemFridgeTime = 0;
      if (widget.selectedDayFreezing == 'Day') {
        itemFridgeTime = int.parse(widget.dayscontroller.text) * 1;
      } else if (widget.selectedDayFreezing == 'Month') {
        itemFridgeTime = int.parse(widget.dayscontroller.text) * 30;
      } else if (widget.selectedDayFreezing == 'Year') {
        itemFridgeTime = int.parse(widget.dayscontroller.text) * 365;
      } else {
        itemFridgeTime = 0;
      }
      Duration Days = Duration(days: itemFridgeTime);
      DateTime newdate = expirydate.add(Days);
      expirydate = newdate;
    }

    String itemunit = widget.itemobj.itemUnit!;

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SizedBox(
        child: InputDecorator(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Add Stock',
              labelStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // TEXTFIELD AND DROPDOWN
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    //  TextInputField(
                    //     controller: stockQuantityController,
                    //     labelText: 'Enter Quantity',
                    //     icon: Icons.food_bank_outlined),
                    TextField(
                  cursorColor: Colors.black,
                  controller: stockQuantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter Quantity',
                    labelText: 'Enter Quantity',
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
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              if (itemunit == 'kgorg')
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
              if (itemunit == 'lorml')
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

              const SizedBox(
                height: 15,
              ),
              // FREEZ
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Frozen',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    activeColor: themeColor,
                    value: isFreez,
                    onChanged: ((value) => setState(() {
                          isFreez = value;
                          widget.onIsFreezChanged(isFreez);
                        })),
                  ),
                ],
              ),

              const SizedBox(
                height: 5,
              ),
              // PURCHASE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Purchase  ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  CupertinoButton(
                    child: Text(
                      "${purchasedate.day}-${purchasedate.month}-${purchasedate.year}",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: themeColor),
                    ),
                    onPressed: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) => SizedBox(
                                height: 250,
                                child: CupertinoDatePicker(
                                  backgroundColor: Colors.white,
                                  initialDateTime: purchasedate,
                                  onDateTimeChanged: (DateTime newTime) {
                                    setState(() => purchasedate = newTime);
                                  },
                                  mode: CupertinoDatePickerMode.date,
                                ),
                              ));
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              // EXPIRY
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Expiry  ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  CupertinoButton(
                    child: Text(
                      "${expirydate.day}-${expirydate.month}-${expirydate.year}",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: themeColor),
                    ),
                    onPressed: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) => SizedBox(
                                height: 250,
                                child: CupertinoDatePicker(
                                  backgroundColor: Colors.white,
                                  initialDateTime: expirydate,
                                  onDateTimeChanged: (DateTime newTime) {
                                    setState(() => expirydate = newTime);
                                  },
                                  mode: CupertinoDatePickerMode.date,
                                ),
                              ));
                    },
                  ),
                ],
              ),

              NewButton(
                text: 'Add',
                backgroundColor: themeColor,
                buttonwidth: 150,
                onPress: () async {
                  String stocklabel = generateStockLabel(name);

                  // print(widget.Fridgegval);
                  String? unit;
                  if (itemunit == 'kgorg') {
                    unit = selectedoptiong == 'KiloGram' ? 'kg' : 'g';
                  } else if (itemunit == 'lorml') {
                    unit = selectedoptionml == 'Liter' ? 'l' : 'ml';
                  } else {
                    unit = null;
                  }

                  Stock s = Stock();
                  s.quantity = double.tryParse(stockQuantityController.text);
                  s.quantityUnit = unit;
                  s.isFrozen = isFreez;
                  s.fridgeid = fridgeid;
                  s.fridgeItemId = widget.itemobj.fridgeItemId;
                  s.purchaseDate = purchasedate.toString();
                  s.expiryDate = expirydate.toString();
                  s.label = stocklabel;
                  String? res = await s.addStock();
                  if (res == "\"Added\"") {
                    const text = 'Stock Added';
                    const snackBar = SnackBar(
                        duration: Duration(seconds: 10),
                        content: Text(
                          text,
                        ));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
                },
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
