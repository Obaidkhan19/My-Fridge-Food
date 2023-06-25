import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/Cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fridgefood/Models/all_items.dart';
import 'package:fridgefood/Models/stock.dart';
import 'package:fridgefood/View/Screens/FridgeItems/edit_stock.dart';
import 'package:fridgefood/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/utilities.dart';
import '../../Widgets/MyButton.dart';

class StockScreen extends StatefulWidget {
  AllItem sobj;
  int stockid;

  dynamic callback;
  StockScreen({required this.sobj, required this.stockid});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  // String selectedoptiong = 'Gram';
  // void updateSelectedUnitKg(String unit) {
  //   setState(() {
  //     selectedoptiong = unit;
  //   });
  // }

  // String selectedoptionml = 'MiliLiter';
  // void updateSelectedUnitMl(String unit) {
  //   setState(() {
  //     selectedoptionml = unit;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    stockid = widget.stockid;
    stockapi();
    getdata();
  }

  void getdata() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    name = sp.getString('username');
    userid = sp.getInt('userid');
    fridgeid = sp.getInt('fridgeid');
    setState(() {});
  }

  int? fridgeid;
  int? userid;
  String? name;
  int? stockid;
  List<Stock> stocklist = [];
  Future<void> stockapi() async {
    final response =
        await http.get(Uri.parse('$ip/fridgeitem/stockdetail?sid=$stockid'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      // sucess
      setState(() {
        stocklist.clear();
        for (Map i in data) {
          stocklist.add(Stock.fromJson(i));
        }
      });
    }
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
  final TextEditingController consumeQuantityController =
      TextEditingController();
  DateTime? purchasedateTime;
  DateTime? expirydateTime;

  @override
  Widget build(BuildContext context) {
    String? status = widget.sobj.status;
    String itemunit = widget.sobj.itemUnit!;
    String itemname = widget.sobj.name!;
    return Column(
      children: [
        stocklist.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // THIS ALLOW CONTAINER TO SCROLL
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  // double? quantity1 = stocklist[index].quantity!;
                  // String quantityString = quantity1.toStringAsFixed(1);
                  // String quantity = quantityString.endsWith(".0")
                  //     ? quantityString.substring(0, quantityString.length - 2)
                  //     : quantityString; // remove decimal and trailing zero if the weight is a whole number
                  // //  double? quantity = stocklist[index].quantity!;
                  double quantity1 = stocklist[index].quantity!;
                  String quantityString = quantity1
                      .toString(); // Convert double to string without rounding
                  String quantity = quantityString.endsWith(".0")
                      ? quantityString.substring(0, quantityString.length - 2)
                      : quantityString; // Remove decimal and trailing zero if the weight is a whole number

                  String? label = stocklist[index].label ?? '';
                  String? quantityunit = stocklist[index].quantityUnit ?? '';

                  DateTime purchasedateTime =
                      DateTime.parse(stocklist[index].purchaseDate.toString());
                  DateTime expirydateTime =
                      DateTime.parse(stocklist[index].expiryDate.toString());
                  var today = DateTime.now();
                  Duration difference = expirydateTime.difference(today);
                  int days = difference.inDays;
                  bool isFreez = widget.sobj.isFrozen ?? false;
                  Stock stockobj = stocklist[index];
                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: 40, left: 10, right: 10),
                    child: SizedBox(
                      child: InputDecorator(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Stock',
                            labelStyle: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Stock Packet Label',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  label,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: themeColor),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // STATUS
                                Column(
                                  children: [
                                    Badge(
                                      position: BadgePosition.center(),
                                      shape: BadgeShape.square,
                                      badgeColor: status == 'Good'
                                          ? themeColor
                                          : status == 'ExpiringSoon'
                                              ? const Color.fromARGB(
                                                  255, 236, 137, 23)
                                              : status == 'Expired'
                                                  ? Colors.red
                                                  : Colors.red,
                                      borderRadius: BorderRadius.circular(25),
                                      toAnimate: false,
                                      badgeContent: Text(
                                        status!,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ), // status
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    const Text('Status'), // status
                                  ],
                                ),

                                // DAYS LEFT
                                Column(
                                  children: [
                                    Text(
                                      days < 0 ? '0' : days.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ), // days left
                                    const Text('Days Left'), // days old
                                  ],
                                ),
                                // QUANTITY
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: themeColor,
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              quantityunit.toString() == 'null'
                                                  ? quantity.toString()
                                                  : quantity.toString() +
                                                      quantityunit.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ), // quantity
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    const Text('Quantity'), // quantity
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Frozen',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Switch(
                                  activeColor: themeColor,
                                  value: isFreez,
                                  onChanged: ((value) {}),
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
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                CupertinoButton(
                                  child: Text(
                                    "${purchasedateTime.day}-${purchasedateTime.month}-${purchasedateTime.year}",
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
                                                initialDateTime:
                                                    purchasedateTime,
                                                onDateTimeChanged:
                                                    (DateTime newDate) {
                                                  setState(() {
                                                    purchasedateTime = newDate;
                                                  });
                                                },
                                                mode: CupertinoDatePickerMode
                                                    .date,
                                              ),
                                            ));
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),

                            // EXPIRE
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Expiry  ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                CupertinoButton(
                                  child: Text(
                                    "${expirydateTime.day}-${expirydateTime.month}-${expirydateTime.year}",
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
                                                initialDateTime: expirydateTime,
                                                onDateTimeChanged:
                                                    (DateTime newTime) {
                                                  setState(() {
                                                    expirydateTime = newTime;
                                                  });
                                                },
                                                mode: CupertinoDatePickerMode
                                                    .date,
                                              ),
                                            ));
                                  },
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (stockid != 0 && status != 'Expired')
                                  NewButton(
                                    text: 'Consume All',
                                    backgroundColor: themeColor,
                                    buttonwidth: 150,
                                    onPress: () async {
                                      String data =
                                          '$name has used $quantity $quantityunit $itemname';
                                      Stock i = Stock();
                                      i.id = stockid;
                                      i.userId = userid;
                                      i.data = data;
                                      i.fridgeid = fridgeid;
                                      await i.consumeallstockapi();
                                      setState(() {
                                        stockapi();
                                      });
                                    },
                                    textColor: Colors.white,
                                  ),
                                if (status == 'Expired')
                                  NewButton(
                                      text: 'Add to Bin',
                                      backgroundColor: Colors.red,
                                      buttonwidth: 150,
                                      textColor: Colors.white,
                                      onPress: () async {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Alert"),
                                              content:
                                                  const Text("Add to Bin."),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () async {
                                                    Stock i = Stock();
                                                    i.id = stockid;
                                                    i.fridgeid = fridgeid;
                                                    await i.deletestockapi();
                                                    setState(() {
                                                      stockapi();
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "Bin",
                                                    style: TextStyle(
                                                        color: themeColor),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      }),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                NewButton(
                                  text: 'Edit',
                                  backgroundColor: Colors.red,
                                  buttonwidth: 150,
                                  onPress: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditStock(
                                          widget.sobj,
                                          stockobj,
                                        ),
                                      ),
                                    );
                                  },
                                  textColor: Colors.white,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })
            : const SizedBox(
                height: 0,
              ),
        if (stockid != 0 && status != 'Expired')
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: SizedBox(
              child: InputDecorator(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Consume',
                    labelStyle:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // TEXTFIELD AND DROPDOWN
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child:
                            // TextInputField(
                            //     controller: consumeQuantityController,
                            //     labelText: 'Enter Quantity',
                            //     icon: Icons.food_bank_outlined),
                            TextField(
                          cursorColor: Colors.black,
                          controller: consumeQuantityController,
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
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
                    // MY BUTTON
                    NewButton(
                      text: 'Consume',
                      backgroundColor: themeColor,
                      buttonwidth: 150,
                      onPress: () async {
                        String? unit;
                        if (itemunit == 'kgorg') {
                          unit = selectedoptiong == 'KiloGram' ? 'kg' : 'g';
                        } else if (itemunit == 'lorml') {
                          unit = selectedoptionml == 'Liter' ? 'l' : 'ml';
                        } else {
                          unit = null;
                        }
                        Stock s = Stock();
                        s.id = stockid;
                        s.quantity =
                            double.tryParse(consumeQuantityController.text);
                        String quantity = consumeQuantityController.text;
                        s.quantityUnit = unit;
                        String dunit;
                        if (unit == null) {
                          dunit = '';
                        } else {
                          dunit = unit;
                        }
                        String data =
                            '$name has used $quantity $dunit $itemname';
                        s.data = data;
                        s.userId = userid;
                        s.fridgeid = fridgeid;
                        String? response = await s.consumeapi();
                        print(response);
                        if (response == "\"Insufficientstock\"") {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Alert"),
                                content: const Text("Not Enough Stock."),
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
                        } else if (response == "\"consumed\"") {
                          setState(() {
                            stockapi();
                            consumeQuantityController.clear();
                          });
                        }
                      },
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
