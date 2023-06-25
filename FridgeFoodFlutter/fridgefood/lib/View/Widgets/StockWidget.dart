import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/Cupertino.dart';
import 'package:fridgefood/Models/all_items.dart';
import 'package:fridgefood/utils/utilities.dart';
import 'package:fridgefood/View/Widgets/small_unit_dropdown.dart';
import 'package:fridgefood/View/Widgets/text_input_field.dart';
import 'package:fridgefood/constants.dart';

import '../../Models/stock.dart';
import 'MyButton.dart';

import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class StockWidget extends StatefulWidget {
  AllItem sobj;
  StockWidget(this.sobj, {super.key});

  @override
  State<StockWidget> createState() => StockWidgetState();
}

class StockWidgetState extends State<StockWidget> {
  DateTime? purchasedateTime;
  DateTime? expirydateTime;
  List<Stock> stocklist = [];
  @override
  Widget build(BuildContext context) {
    // GET STOCKS
    int itemid = widget.sobj.itemId!;
    Future<List<Stock>> stockapi() async {
      final response =
          await http.get(Uri.parse('$ip/fridgeitem/AllStocks?fiid=$itemid'));
      var data = jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        for (Map i in data) {
          stocklist.add(Stock.fromJson(i));
        }
        return stocklist;
      } else {
        return stocklist;
      }
    }

    final TextEditingController consumeQuantityController =
        TextEditingController();

    return FutureBuilder(
      future: stockapi(),
      builder: (context, AsyncSnapshot<List<Stock>> snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        } else {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: stocklist.length,
              itemBuilder: (BuildContext context, int index) {
                double? quantity = snapshot.data![index].quantity;
                String? quantityunit = snapshot.data![index].quantityUnit;
                DateTime purchasedateTime = DateTime.parse(
                    snapshot.data![index].purchaseDate.toString());

                DateTime expirydateTime =
                    DateTime.parse(snapshot.data![index].expiryDate.toString());

                var today = DateTime.now();
                Duration difference = expirydateTime.difference(today);
                int days = difference.inDays;
                bool isFreez = snapshot.data![index].isFrozen!;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: SizedBox(
                    child: InputDecorator(
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Stock $index',
                          labelStyle: const TextStyle(
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
                              // STATUS
                              Column(
                                children: [
                                  Badge(
                                    position: BadgePosition.center(),
                                    shape: BadgeShape.square,
                                    badgeColor: themeColor,
                                    borderRadius: BorderRadius.circular(25),
                                    toAnimate: false,
                                    badgeContent: const Text(
                                      'Good /calculate/',
                                      style: TextStyle(color: Colors.white),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            quantityunit.toString() == 'null'
                                                ? quantity.toString()
                                                : quantity.toString() +
                                                    quantityunit.toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Icon(
                                            Icons.add,
                                            color: Colors.white,
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
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
                                              initialDateTime: purchasedateTime,
                                              onDateTimeChanged:
                                                  (DateTime newDate) {
                                                setState(() {
                                                  purchasedateTime = newDate;
                                                });
                                              },
                                              mode:
                                                  CupertinoDatePickerMode.date,
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
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
                                              mode:
                                                  CupertinoDatePickerMode.date,
                                            ),
                                          ));
                                },
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          // MY BUTTON
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              // NewButton(
                              //   text: 'Save',
                              //   backgroundColor: themeColor,
                              //   buttonwidth: 150,
                              //   onPress: () {},
                              //   textColor: Colors.white,
                              // ),
                            ],
                          ),

                          SizedBox(
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Consume',
                                  labelStyle: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  // TEXTFIELD AND DROPDOWN
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextInputField(
                                        controller: consumeQuantityController,
                                        labelText: 'Enter Quantity',
                                        icon: Icons.food_bank_outlined),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const SmallUnitDropDown(),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  // MY BUTTON
                                  NewButton(
                                    text: 'Consume',
                                    backgroundColor: themeColor,
                                    buttonwidth: 150,
                                    onPress: () {},
                                    textColor: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          NewButton(
                            text: 'Remove',
                            backgroundColor: Colors.red,
                            buttonwidth: 150,
                            onPress: () {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Are you sure to Remove?'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              setState(() {});
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "YES",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "NO",
                                              style:
                                                  TextStyle(color: themeColor),
                                            ))
                                      ],
                                    );
                                  });
                            },
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        }
      },
    );
  }
}
