import 'dart:convert';

import 'package:flutter/Cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fridgefood/constants.dart';
import 'package:http/http.dart' as http;
import '../../../Functions/fromat_datetime.dart';
import '../../../Models/logs_filter.dart';
import '../../../utils/utilities.dart';
import '../../Widgets/MyButton.dart';

class FilterLogs extends StatefulWidget {
  int fiid;
  FilterLogs({required this.fiid, super.key});
  @override
  State<FilterLogs> createState() => _FilterLogsState();
}

class _FilterLogsState extends State<FilterLogs> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fiid = widget.fiid;
  }

  int fiid = 0;
  DateTime to = DateTime.now();
  DateTime from = DateTime.now();
  double totalquantity = 0;

  List<LogFilter> llist = [];
  Future<List<LogFilter>> logapi() async {
    final response = await http
        .get(Uri.parse('$ip/log/AllLogswithfilter?fiid=$fiid&sd=$from&ed=$to'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      print(response.statusCode);
      llist.clear();
      // sucess
      for (Map i in data) {
        llist.add(LogFilter.fromJson(i));
        LogFilter logFilter = LogFilter.fromJson(i);
        setState(() {
          totalquantity = logFilter.totalQuantity!;
        });
      }
      return llist;
    } else {
      return llist;
    }
  }

  Future<void> updateLogs() async {
    await logapi();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(llist.length);
    print(from);
    print(to);

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
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                const Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  'From',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                CupertinoButton(
                  child: Text(
                    "${from.day}-${from.month}-${from.year}",
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
                                initialDateTime: from,
                                onDateTimeChanged: (DateTime newTime) {
                                  setState(() => from = newTime);
                                },
                                mode: CupertinoDatePickerMode.date,
                              ),
                            ));
                  },
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  'To',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                CupertinoButton(
                  child: Text(
                    "${to.day}-${to.month}-${to.year}",
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
                                initialDateTime: to,
                                onDateTimeChanged: (DateTime newTime) {
                                  setState(() => to = newTime);
                                },
                                mode: CupertinoDatePickerMode.date,
                              ),
                            ));
                  },
                ),
                MyButton(
                    text: "ok",
                    backgroundColor: themeColor,
                    buttonwidth: 30,
                    onPress: updateLogs,
                    textColor: Colors.white),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // FutureBuilder(
          //   future: logapi(),
          //   builder: (context, AsyncSnapshot<List<LogFilter>> snapshot) {
          //     if (!snapshot.hasData) {
          //       return const CircularProgressIndicator();
          //     } else {
          //       return
          Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: llist.length,
                  itemBuilder: (BuildContext context, int index) {
                    DateTime datetime = DateTime.parse(llist[index].date!);
                    FromatedDateTime fdt = FromatedDateTime();
                    String date = fdt.formatDateTime(datetime);
                    String logdata = llist[index].logData!;
                    double qunatity = llist[index].quantity!;
                    // totalquantity = snapshot.data![index].totalQuantity!;
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
                  }),
            ],
          ),
          //     }
          //   },
          // ),
          const SizedBox(
            height: 15,
          ),
          Text(
            "Total Quantity : $totalquantity",
            style: TextStyle(fontSize: 30, color: themeColor),
          ),
        ],
      ),
    );
  }
}
