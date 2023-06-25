import 'package:flutter/material.dart';
import 'package:fridgefood/Models/all_items.dart';
import 'package:fridgefood/View/Widgets/Add_item_pg_row.dart';
import 'package:fridgefood/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/utilities.dart';
import '../../Widgets/AddStockWidget.dart';

String formatDays(int days) {
  if (days >= 365) {
    int years = days ~/ 365;
    int remainingDays = days % 365;
    if (remainingDays >= 30) {
      int months = remainingDays ~/ 30;
      return '$years years, $months months';
    } else {
      return '$years years';
    }
  } else if (days >= 30) {
    int months = days ~/ 30;
    return '$months months';
  } else {
    return '$days days';
  }
}

class AddStockScreen extends StatefulWidget {
  AllItem detailobj;
  AddStockScreen({required this.detailobj, super.key});

  @override
  State<AddStockScreen> createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  String Freezgval = "system";
  String Fridgegval = "system";
  bool isFreez = false;

  String selectedDayFreezing = 'Day';

  void updateSelectedDuration(String day) {
    setState(() {
      selectedDayFreezing = day;
    });
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  void getdata() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    freezertypee = sp.getInt('freezertype');
  }

  int itemFreezingTime = 1;
  int? freezertypee;

  TextEditingController daysController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (freezertypee == null) {
      itemFreezingTime = 7;
    } else if (freezertypee == 1) {
      itemFreezingTime = 7;
    } else if (freezertypee == 2) {
      itemFreezingTime = 30;
    } else if (freezertypee == 3) {
      itemFreezingTime = 90;
    } else if (freezertypee == 4) {
      itemFreezingTime = 360;
    }
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 30,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Add Stock',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            NetworkImage(itemimgpath + widget.detailobj.image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    widget.detailobj.name.toString(),
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              // FREEZING CONTAINER

              if (isFreez == true)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: SizedBox(
                    child: InputDecorator(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Freezing Time',
                          labelStyle: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            children: [
                              Radio(
                                  activeColor: themeColor,
                                  value: "system",
                                  groupValue: Freezgval,
                                  onChanged: (val) {
                                    setState(() {
                                      Freezgval = val.toString();
                                    });
                                  }),
                              const Text(
                                'System',
                                style: TextStyle(fontSize: 15),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                  // widget.detailobj.itemFreezingTime
                                  //                 .toString() ==
                                  //             "null" ||
                                  //         widget.detailobj.itemFreezingTime
                                  //             .toString()
                                  //             .isEmpty
                                  //     ? "Not Recommended"
                                  //     : formatDays(
                                  //             widget.detailobj.itemFreezingTime)
                                  //         .toString(),
                                  formatDays(itemFreezingTime).toString(),
                                  style: TextStyle(
                                      color: themeColor, fontSize: 15)),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Radio(
                                  activeColor: themeColor,
                                  value: "custom",
                                  groupValue: Freezgval,
                                  onChanged: (val) {
                                    // setState(() {
                                    //   Freezgval = val.toString();
                                    // });
                                  }),
                              const Text(
                                'Custom',
                                style: TextStyle(fontSize: 15),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              // Text(
                              //     widget.detailobj.userFreezingTime
                              //                     .toString() ==
                              //                 "null" ||
                              //             widget.detailobj.userFreezingTime
                              //                 .toString()
                              //                 .isEmpty
                              //         ? "Not Set"
                              //         : formatDays(
                              //                 widget.detailobj.userFreezingTime)
                              //             .toString(),
                              //     style: const TextStyle(
                              //       color: themeColor,
                              //       fontSize: 15,
                              //     )),
                              AddStockRow(
                                detailobj: widget.detailobj,
                                text: '',
                                namecontroller: daysController,
                                onDaySelected: updateSelectedDuration,
                              ),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      Freezgval = "custom";
                                    });
                                  },
                                  child: const Text('OK'))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Fridge Time
              if (isFreez == false)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: SizedBox(
                    child: InputDecorator(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Fridge Time',
                          labelStyle: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            children: [
                              Radio(
                                  activeColor: themeColor,
                                  value: "system",
                                  groupValue: Fridgegval,
                                  onChanged: (val) {
                                    setState(() {
                                      Fridgegval = val.toString();
                                    });
                                  }),
                              const Text(
                                'System',
                                style: TextStyle(fontSize: 15),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                  widget.detailobj.itemFridgeTime.toString() ==
                                              "null" ||
                                          widget.detailobj.itemFridgeTime
                                              .toString()
                                              .isEmpty
                                      ? "No Recommended"
                                      : formatDays(
                                              widget.detailobj.itemFridgeTime ??
                                                  0)
                                          .toString(),
                                  style: TextStyle(
                                    color: themeColor,
                                    fontSize: 15,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Row(
                            children: [
                              Radio(
                                  activeColor: themeColor,
                                  value: "custom",
                                  groupValue: Fridgegval,
                                  onChanged: (val) {
                                    // setState(() {
                                    //   Fridgegval = val.toString();
                                    // });
                                  }),
                              const Text(
                                'Custom',
                                style: TextStyle(fontSize: 15),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              // Text(
                              //     widget.detailobj.userFridgeTime.toString() ==
                              //                 "null" ||
                              //             widget.detailobj.userFridgeTime
                              //                 .toString()
                              //                 .isEmpty
                              //         ? "Not Set"
                              //         : formatDays(
                              //                 widget.detailobj.userFridgeTime ??
                              //                     0)
                              //             .toString(),
                              //     style: const TextStyle(
                              //       color: themeColor,
                              //       fontSize: 15,
                              //     )),
                              AddStockRow(
                                detailobj: widget.detailobj,
                                text: '',
                                namecontroller: daysController,
                                onDaySelected: updateSelectedDuration,
                              ),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      Fridgegval = "custom";
                                    });
                                  },
                                  child: const Text('OK'))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 5,
              ),
              AddStockWidget(
                itemobj: widget.detailobj,
                Freezgval: Freezgval,
                Fridgegval: Fridgegval,
                dayscontroller: daysController,
                selectedDayFreezing: selectedDayFreezing,
                onIsFreezChanged: (value) {
                  // define the callback function here
                  setState(() {
                    isFreez = value;
                  });
                },
              ), // ADD STOCK WIDGET

              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
