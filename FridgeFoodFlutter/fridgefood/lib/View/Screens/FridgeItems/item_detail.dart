import 'package:flutter/material.dart';
import 'package:fridgefood/Models/all_items.dart';
import 'package:fridgefood/View/Screens/FridgeItems/add_stock_screen.dart';
import 'package:fridgefood/View/Widgets/MyButton.dart';
import 'package:fridgefood/constants.dart';
import '../../../utils/utilities.dart';

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

class ItemDetail extends StatefulWidget {
  AllItem detailobj;
  ItemDetail(this.detailobj);

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  @override
  Widget build(BuildContext context) {
    double? lowstockreminderquantity =
        double.tryParse(widget.detailobj.lowStockReminder.toString());
    String quantityStringlowstock =
        lowstockreminderquantity?.toStringAsFixed(1) ??
            "0.0"; // convert double to string and round to 1 decimal place
    String quantitylowstock = quantityStringlowstock.endsWith(".0")
        ? quantityStringlowstock.substring(0, quantityStringlowstock.length - 2)
        : quantityStringlowstock;
    String lowstockreminderquantityunit =
        widget.detailobj.lowStockReminderUnit.toString();
    double? dailyusequantity =
        double.tryParse(widget.detailobj.dailyConsumption.toString());
    String quantityString = dailyusequantity?.toStringAsFixed(1) ??
        "0.0"; // convert double to string and round to 1 decimal place
    String quantitydailyuse = quantityString.endsWith(".0")
        ? quantityString.substring(0, quantityString.length - 2)
        : quantityString;
    String dailyusequantityunit =
        widget.detailobj.dailyConsumptionUnit.toString();
    int stockid = widget.detailobj.stockId!;
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
                      'Item Detail',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         EditItem(detailobj: widget.detailobj),
                        //   ),
                        // );
                      },
                      child: const Text(
                        'Edit Detail',
                        style: TextStyle(fontSize: 15, color: Colors.red),
                      ))
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
              const SizedBox(
                height: 5,
              ),
              //CATEGORY AND DROP DOWN
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    widget.detailobj.category.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 5,
              ),

              // REMINDER
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 30,
                ),
                child: SizedBox(
                  child: InputDecorator(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Reminder',
                        labelStyle: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Expiry',
                              style: TextStyle(fontSize: 25),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                                widget.detailobj.expiryReminder.toString() ==
                                            "null" ||
                                        widget.detailobj.expiryReminder
                                            .toString()
                                            .isEmpty
                                    ? "Not Set"
                                    : formatDays(
                                            widget.detailobj.expiryReminder ??
                                                0)
                                        .toString(),
                                style: TextStyle(
                                  color: themeColor,
                                  fontSize: 15,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Low Stock',
                              style: TextStyle(fontSize: 25),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                                quantitylowstock.toString() == 'null' &&
                                        lowstockreminderquantityunit
                                                .toString() ==
                                            'null'
                                    ? 'Not Set'
                                    : lowstockreminderquantityunit.toString() ==
                                            'null'
                                        ? quantitylowstock.toString()
                                        : quantitylowstock.toString() +
                                            lowstockreminderquantityunit
                                                .toString(),
                                style: TextStyle(
                                  color: themeColor,
                                  fontSize: 15,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 5,
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 5,
              ),
              // daily usage
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 30,
                ),
                child: SizedBox(
                  child: InputDecorator(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Daily Usage',
                        labelStyle: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Quantity',
                              style: TextStyle(fontSize: 25),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                                quantitydailyuse.toString() == 'null' &&
                                        dailyusequantityunit.toString() ==
                                            'null'
                                    ? 'Not Set'
                                    : dailyusequantityunit.toString() == 'null'
                                        ? quantitydailyuse.toString()
                                        : quantitydailyuse.toString() +
                                            dailyusequantityunit.toString(),
                                style: TextStyle(
                                  color: themeColor,
                                  fontSize: 15,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 5,
              ),
              // FREEZING CONTAINER
              // Padding(
              //   padding: const EdgeInsets.only(
              //     left: 20,
              //     right: 30,
              //   ),
              //   child: SizedBox(
              //     child: InputDecorator(
              //       decoration: const InputDecoration(
              //           border: OutlineInputBorder(),
              //           labelText: 'Freezing Time',
              //           labelStyle: TextStyle(
              //               fontSize: 30, fontWeight: FontWeight.bold)),
              //       child: Column(
              //         mainAxisSize: MainAxisSize.max,
              //         children: [
              //           Row(
              //             children: [
              //               const Text(
              //                 'System',
              //                 style: TextStyle(fontSize: 25),
              //               ),
              //               const SizedBox(
              //                 width: 15,
              //               ),
              //               Text(
              //                   widget.detailobj.itemFreezingTime.toString() ==
              //                               "null" ||
              //                           widget.detailobj.itemFreezingTime
              //                               .toString()
              //                               .isEmpty
              //                       ? "Not Recommended"
              //                       : formatDays(
              //                               widget.detailobj.itemFreezingTime)
              //                           .toString(),
              //                   style: const TextStyle(
              //                       color: themeColor, fontSize: 15)),
              //             ],
              //           ),
              //           const SizedBox(
              //             height: 5,
              //           ),
              //           Row(
              //             children: [
              //               const Text(
              //                 'Custom',
              //                 style: TextStyle(fontSize: 25),
              //               ),
              //               const SizedBox(
              //                 width: 15,
              //               ),
              //               Text(
              //                   widget.detailobj.userFreezingTime.toString() ==
              //                               "null" ||
              //                           widget.detailobj.userFreezingTime
              //                               .toString()
              //                               .isEmpty
              //                       ? "Not Set"
              //                       : formatDays(
              //                               widget.detailobj.userFreezingTime)
              //                           .toString(),
              //                   style: const TextStyle(
              //                     color: themeColor,
              //                     fontSize: 15,
              //                   )),
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // const Divider(
              //   thickness: 1,
              // ),
              // const SizedBox(
              //   height: 5,
              // ),

              // // Fridge Time

              // Padding(
              //   padding: const EdgeInsets.only(
              //     left: 20,
              //     right: 30,
              //   ),
              //   child: SizedBox(
              //     child: InputDecorator(
              //       decoration: const InputDecoration(
              //           border: OutlineInputBorder(),
              //           labelText: 'Fridge Time',
              //           labelStyle: TextStyle(
              //               fontSize: 30, fontWeight: FontWeight.bold)),
              //       child: Column(
              //         mainAxisSize: MainAxisSize.max,
              //         children: [
              //           Row(
              //             children: [
              //               const Text(
              //                 'System',
              //                 style: TextStyle(fontSize: 25),
              //               ),
              //               const SizedBox(
              //                 width: 15,
              //               ),
              //               Text(
              //                   widget.detailobj.itemFridgeTime.toString() ==
              //                               "null" ||
              //                           widget.detailobj.itemFridgeTime
              //                               .toString()
              //                               .isEmpty
              //                       ? "No Recommended"
              //                       : formatDays(
              //                               widget.detailobj.itemFridgeTime ??
              //                                   0)
              //                           .toString(),
              //                   style: const TextStyle(
              //                     color: themeColor,
              //                     fontSize: 15,
              //                   )),
              //             ],
              //           ),
              //           const SizedBox(
              //             height: 5,
              //           ),
              //           Row(
              //             children: [
              //               const Text(
              //                 'Custom',
              //                 style: TextStyle(fontSize: 25),
              //               ),
              //               const SizedBox(
              //                 width: 15,
              //               ),
              //               Text(
              //                   widget.detailobj.userFridgeTime.toString() ==
              //                               "null" ||
              //                           widget.detailobj.userFridgeTime
              //                               .toString()
              //                               .isEmpty
              //                       ? "Not Set"
              //                       : formatDays(
              //                               widget.detailobj.userFridgeTime ??
              //                                   0)
              //                           .toString(),
              //                   style: const TextStyle(
              //                     color: themeColor,
              //                     fontSize: 15,
              //                   )),
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // const Divider(
              //   thickness: 1,
              // ),
              // const SizedBox(
              //   height: 5,
              // ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(
                    text: "Remove",
                    backgroundColor: Colors.red,
                    buttonwidth: 150,
                    textColor: whitecolor,
                    onPress: () async {},
                  ),
                  const SizedBox(width: 5),
                  MyButton(
                    text: "Add Stock",
                    backgroundColor: themeColor,
                    buttonwidth: 150,
                    textColor: whitecolor,
                    onPress: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddStockScreen(detailobj: widget.detailobj),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
