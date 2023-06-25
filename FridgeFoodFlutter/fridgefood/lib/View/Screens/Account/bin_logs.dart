import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fridgefood/Functions/fromat_datetime.dart';
import 'package:fridgefood/Models/bin_chart.dart';
import 'package:fridgefood/Models/log.dart';
import 'package:fridgefood/constants.dart';
import 'package:fridgefood/utils/utils.dart';
import 'package:http/http.dart' as http;
import '../../../Models/stock.dart';
import '../../../utils/utilities.dart';

class BinLogs extends StatefulWidget {
  Chart bobj;
  BinLogs({required this.bobj, super.key});

  @override
  State<BinLogs> createState() => _BinLogsState();
}

class _BinLogsState extends State<BinLogs> {
  @override
  Widget build(BuildContext context) {
    int fridgeitemid = widget.bobj.fridgeItemId!;
    List<Log> llist = [];
    Future<List<Log>> logapi() async {
      final response =
          await http.get(Uri.parse('$ip/log/ItemBinLogs?fiid=$fridgeitemid'));
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
          'Bin Logs',
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
      body: FutureBuilder(
        future: logapi(),
        builder: (context, AsyncSnapshot<List<Log>> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: llist.length,
                itemBuilder: (BuildContext context, int index) {
                  int bid = snapshot.data![index].id!;
                  DateTime datetime =
                      DateTime.parse(snapshot.data![index].date!);
                  String unit = snapshot.data![index].quantityUnit ?? '';
                  double? quantity1 = snapshot.data![index].quantity;
                  String quantityString = quantity1?.toStringAsFixed(1) ??
                      "0.0"; // convert double to string and round to 1 decimal place
                  String quantity = quantityString.endsWith(".0")
                      ? quantityString.substring(0, quantityString.length - 2)
                      : quantityString;
                  String name = snapshot.data![index].logData!;
                  String data = quantity1! > 1
                      ? '$quantity $unit ${name}s' //"${logdata}s"
                      : '$quantity $unit $name';
                  FromatedDateTime fdt = FromatedDateTime();
                  String date = fdt.formatDateTime(datetime);
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
                              data,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            subtitle: Text(
                              date,
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Alert"),
                                        content: const Text("Restore Stock."),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () async {
                                              Stock s = Stock();
                                              s.id = bid;
                                              String? res =
                                                  await s.restorestockapi();
                                              if (res == "\"Restored\"") {
                                                Utils.snackBar(
                                                    "Stock Restored Sucessfully",
                                                    context);

                                                Navigator.of(context).pop();
                                                setState(() {
                                                  logapi();
                                                });
                                              }
                                            },
                                            child: Text(
                                              "Restore",
                                              style:
                                                  TextStyle(color: themeColor),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              "Cancel",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.restore_from_trash_outlined,
                                  color: Colors.white,
                                  size: 30,
                                )),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
