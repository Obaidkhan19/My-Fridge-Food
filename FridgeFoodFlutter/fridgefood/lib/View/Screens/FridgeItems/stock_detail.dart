import 'package:flutter/material.dart';
import 'package:fridgefood/Models/all_items.dart';
import 'package:fridgefood/Models/items.dart';
import 'package:fridgefood/View/Screens/FridgeItems/add_stock_screen.dart';
import 'package:fridgefood/View/Screens/FridgeItems/edit_detail.dart';
import 'package:fridgefood/View/Screens/FridgeItems/stock_screen.dart';
import 'package:fridgefood/View/Screens/FridgeItems/usage_logs.dart';
import 'package:fridgefood/constants.dart';
import 'package:fridgefood/utils/utils.dart';
import '../../../utils/utilities.dart';
import '../../Widgets/RecipeUsingItemWidget.dart';

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

enum _MenuValues {
  AddStock,
  ViewLogs,
  SetDetais,
  RemoveItem,
}

class StockDetail extends StatefulWidget {
  AllItem detailobj;
  StockDetail(this.detailobj);

  @override
  State<StockDetail> createState() => _StockDetailState();
}

class _StockDetailState extends State<StockDetail> {
  Color color = Colors.white;
  @override
  Widget build(BuildContext context) {
    int fridgeitemid = widget.detailobj.fridgeItemId!;
    int stockid = widget.detailobj.stockId!;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          backgroundColor: themeColor,
          title: const Text(
            'Stock Detail',
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
          actions: [
            PopupMenuButton<_MenuValues>(
                itemBuilder: (context) => [
                      const PopupMenuItem(
                          value: _MenuValues.AddStock,
                          child: Text('Add Stock')),
                      const PopupMenuItem(
                          value: _MenuValues.ViewLogs,
                          child: Text('View Logs')),
                      const PopupMenuItem(
                          value: _MenuValues.SetDetais,
                          child: Text('Set Detail')),
                      const PopupMenuItem(
                          value: _MenuValues.RemoveItem,
                          child: Text(
                            'Remove Item',
                            style: TextStyle(color: Colors.red),
                          )),
                    ],
                onSelected: (value) async {
                  switch (value) {
                    case _MenuValues.AddStock:
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddStockScreen(detailobj: widget.detailobj),
                        ),
                      );
                      setState(() {
                        color =
                            color == Colors.white ? Colors.grey : Colors.white;
                      });
                      break;
                    case _MenuValues.ViewLogs:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UsageLogs(widget.detailobj)),
                      );
                      break;
                    case _MenuValues.SetDetais:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditDetail(detailobj: widget.detailobj),
                        ),
                      );
                      break;
                    case _MenuValues.RemoveItem:
                      // Call Remove function here
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Alert"),
                            content: const Text("Removes Item."),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () async {
                                  Items i = Items();
                                  i.id = fridgeitemid;
                                  await i.removeItemapi();
                                  Navigator.of(context).pop();
                                  Utils.snackBar("Removed", context);
                                  setState(() {});
                                  Navigator.of(context).pop();
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

                      break;
                  }
                }),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Row(
              //   children: [
              //     IconButton(
              //       onPressed: () {
              //         Navigator.of(context).pop();
              //       },
              //       icon: const Icon(
              //         Icons.arrow_back_ios,
              //         size: 30,
              //       ),
              //     ),
              //     const Expanded(
              //       child: Text(
              //         'Stock Detail',
              //         textAlign: TextAlign.center,
              //         style:
              //             TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              //       ),
              //     ),
              //     TextButton(
              // onPressed: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             ItemDetail(widget.detailobj)),
              //   );
              // },
              //         child: const Text(
              //           'Item Detail',
              //           style: TextStyle(fontSize: 15, color: Colors.red),
              //         )),
              //   ],
              // ),
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
                  // Expanded(
                  //   child: TextButton(
                  //       onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) =>
                  //           UsageLogs(widget.detailobj)),
                  // );
                  //       },
                  //       child: const Text(
                  //         'View Logs',
                  //         textAlign: TextAlign.right,
                  //         style: TextStyle(fontSize: 15, color: Colors.red),
                  //       )),
                  // ),
                ],
              ),
              //RecipeUsingItemWidget

              RecipeUsingItemWidget(widget.detailobj),

              const SizedBox(height: 5),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 15,
              ),

              StockScreen(
                sobj: widget.detailobj,
                stockid: stockid,
              ),
              // stockid == 'null' || stockid == 0
              //     ? const SizedBox(
              //         width: 0,
              //       )
              //     : StockScreen(
              //         sobj: widget.detailobj,
              //       ),

              const SizedBox(height: 5),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 15,
              ),
              // AddStockWidget(
              //   itemobj: widget.detailobj,
              //   Freezgval: Freezgval,
              //   Fridgegval: Fridgegval,
              // ), // ADD STOCK WIDGET

              const SizedBox(
                height: 10,
              ),

              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
