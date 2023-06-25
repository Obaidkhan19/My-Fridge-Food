import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fridgefood/Models/log.dart';
import 'package:fridgefood/View/Screens/Account/filteredlogs.dart';
import 'package:fridgefood/View/Widgets/MyButton.dart';
import 'package:fridgefood/constants.dart';
import 'package:http/http.dart' as http;
import '../../../Functions/fromat_datetime.dart';
import '../../../Models/bin_chart.dart';
import '../../../utils/utilities.dart';

class consumptionLogs extends StatefulWidget {
  Chart cobj;
  consumptionLogs({required this.cobj, super.key});

  @override
  State<consumptionLogs> createState() => _consumptionLogsState();
}

class _consumptionLogsState extends State<consumptionLogs> {
  @override
  DateTime to = DateTime.now();
  DateTime from = DateTime.now();
  double totalquantity = 0;
  @override
  Widget build(BuildContext context) {
    int fridgeitemid = widget.cobj.fridgeItemId!;
    List<Log> llist = [];
    Future<List<Log>> logapi() async {
      final response =
          await http.get(Uri.parse('$ip/log/AdminItemLogs?fiid=$fridgeitemid'));
      var data = jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        llist.clear();
        // sucess
        for (Map i in data) {
          llist.add(Log.fromJson(i));
        }
        return llist;
      } else {
        return llist;
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: themeColor,
        title: const Text(
          'Consumption Logs',
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
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(left: 8.0),
          //   child: Row(
          //     children: [
          //       const Text(
          //         'Filter',
          //         style: TextStyle(
          //           fontSize: 20,
          //         ),
          //       ),
          //       const SizedBox(
          //         width: 15,
          //       ),
          //       const Text(
          //         'From',
          //         style: TextStyle(
          //           fontSize: 15,
          //         ),
          //       ),
          //       CupertinoButton(
          //         child: Text(
          //           "${from.day}-${from.month}-${from.year}",
          //           style: TextStyle(
          //               fontSize: 20,
          //               fontWeight: FontWeight.bold,
          //               color: themeColor),
          //         ),
          //         onPressed: () {
          //           showCupertinoModalPopup(
          //               context: context,
          //               builder: (BuildContext context) => SizedBox(
          //                     height: 250,
          //                     child: CupertinoDatePicker(
          //                       backgroundColor: Colors.white,
          //                       initialDateTime: from,
          //                       onDateTimeChanged: (DateTime newTime) {
          //                         setState(() => from = newTime);
          //                       },
          //                       mode: CupertinoDatePickerMode.date,
          //                     ),
          //                   ));
          //         },
          //       ),
          //       const SizedBox(
          //         width: 5,
          //       ),
          //       const Text(
          //         'To',
          //         style: TextStyle(
          //           fontSize: 15,
          //         ),
          //       ),
          //       CupertinoButton(
          //         child: Text(
          //           "${to.day}-${to.month}-${to.year}",
          //           style: TextStyle(
          //               fontSize: 20,
          //               fontWeight: FontWeight.bold,
          //               color: themeColor),
          //         ),
          //         onPressed: () {
          //           showCupertinoModalPopup(
          //               context: context,
          //               builder: (BuildContext context) => SizedBox(
          //                     height: 250,
          //                     child: CupertinoDatePicker(
          //                       backgroundColor: Colors.white,
          //                       initialDateTime: to,
          //                       onDateTimeChanged: (DateTime newTime) {
          //                         setState(() => from = newTime);
          //                       },
          //                       mode: CupertinoDatePickerMode.date,
          //                     ),
          //                   ));
          //         },
          //       ),
          //       MyButton(
          //           text: "ok",
          //           backgroundColor: themeColor,
          //           buttonwidth: 30,
          //           onPress: () {},
          //           textColor: Colors.white),
          //     ],
          //   ),
          // ),
          const SizedBox(
            height: 10,
          ),
          FutureBuilder(
            future: logapi(),
            builder: (context, AsyncSnapshot<List<Log>> snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: llist.length,
                    itemBuilder: (BuildContext context, int index) {
                      DateTime datetime =
                          DateTime.parse(snapshot.data![index].date!);
                      FromatedDateTime fdt = FromatedDateTime();
                      String date = fdt.formatDateTime(datetime);
                      String logdata = snapshot.data![index].logData!;
                      double qunatity = snapshot.data![index].quantity!;
                      // totalquantity = snapshot.data!
                      //     .fold(0, (sum, log) => sum + log.quantity!);

                      return Padding(
                        padding: const EdgeInsets.all(2),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 37, 11, 11),
                            borderRadius: BorderRadius.circular(14.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                  title: Text(
                                    qunatity > 1 ? "${logdata}s" : logdata,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    date,
                                    style: const TextStyle(color: Colors.white),
                                  )),
                            ],
                          ),
                        ),
                      );
                    });
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          MyButton(
              text: "Use Filter",
              backgroundColor: themeColor,
              buttonwidth: 300,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilterLogs(
                      fiid: widget.cobj.fridgeItemId!,
                    ),
                  ),
                );
              },
              textColor: Colors.white),
          // Text(
          //   'Total Quantity: $totalquantity',
          //   style: const TextStyle(fontSize: 20),
          // ),
        ],
      ),
    );
  }
}
