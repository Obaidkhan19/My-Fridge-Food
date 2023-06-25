import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fridgefood/View/Screens/Account/consumption_log.dart';
import 'package:fridgefood/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Models/bin_chart.dart';
import '../../../utils/utilities.dart';
import 'package:http/http.dart' as http;

class ConsumptionDashboard extends StatefulWidget {
  const ConsumptionDashboard({super.key});

  @override
  State<ConsumptionDashboard> createState() => _ConsumptionDashboardState();
}

class _ConsumptionDashboardState extends State<ConsumptionDashboard> {
  //http://192.168.10.16/FridgeFood/api/log/ChartBinLogs?fid=2

  @override
  void initState() {
    super.initState();
    getdata();
  }

  void getdata() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    fridgeid = sp.getInt('fridgeid');
    setState(() {});
  }

  int? fridgeid;

  // GET Bins
  List<Chart> consumptionlist = [];
  Future<List<Chart>> consumptionchartapi() async {
    final response =
        await http.get(Uri.parse('$ip/log/ChartConsumptionLogs?fid=$fridgeid'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      consumptionlist.clear();
      // sucess
      for (Map i in data) {
        consumptionlist.add(Chart.fromJson(i));
      }
      return consumptionlist;
    } else {
      return consumptionlist;
    }
  }

  Color color = Colors.white;
  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
        future: consumptionchartapi(),
        builder: (context, AsyncSnapshot<List<Chart>> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            // Group items by quantity unit
            Map<String, List<Chart>> groupedItems = {};
            for (Chart item in snapshot.data!) {
              String unit = item.quantityUnit!;
              if (!groupedItems.containsKey(unit)) {
                groupedItems[unit] = [];
              }
              groupedItems[unit]!.add(item);
            }
            return ListView.builder(
                itemCount: groupedItems.length * 2 - 1, // Account for dividers
                itemBuilder: (context, index) {
                  if (index.isOdd) {
                    // Divider
                    return const Divider(
                      color: Colors.red,
                      thickness: 20,
                    );
                  } else {
                    int unitIndex = index ~/ 2;
                    String unit = groupedItems.keys.elementAt(unitIndex);
                    List<Chart> items = groupedItems[unit]!;
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, top: 14, bottom: 14),
                          child: Text(
                            unit == 'nounit'
                                ? "No Unit"
                                : unit == 'kgorg'
                                    ? "Gram"
                                    : unit == 'lorml'
                                        ? "Mililiter"
                                        : "",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: themeColor,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            itemBuilder: (context, itemIndex) {
                              Chart item = items[itemIndex];

                              double currentQuantity = item.totalQuantity!;
                              String unit = item.quantityUnit ?? "nounit";

                              double maxCapacity = 100.0;
                              if (unit == 'nounit') {
                                maxCapacity = 100;
                              } else {
                                maxCapacity = 10000;
                              }
                              double progress = currentQuantity / maxCapacity;
                              String quantityString =
                                  currentQuantity.toStringAsFixed(1);
                              String quantity = quantityString.endsWith(".0")
                                  ? quantityString.substring(
                                      0, quantityString.length - 2)
                                  : quantityString;

                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: InkWell(
                                  onLongPress: () async {
                                    final value = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            consumptionLogs(cobj: item),
                                      ),
                                    );
                                    setState(() {
                                      color = color == Colors.white
                                          ? Colors.grey
                                          : Colors.white;
                                    });
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name!,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 16,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                height: 40,
                                                child: LinearProgressIndicator(
                                                  value: progress,
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 228, 204, 208),
                                                  color: const Color.fromARGB(
                                                      255, 224, 14, 14),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              children: [
                                                Text(
                                                  quantity,
                                                  style: const TextStyle(
                                                      fontSize: 20),
                                                ),
                                                Text(
                                                  unit == 'nounit'
                                                      ? ""
                                                      : unit == 'kgorg'
                                                          ? "g"
                                                          : unit == 'lorml'
                                                              ? "ml"
                                                              : "",
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ],
                    );
                  }
                });
          }
        },
      ),
    );
  }
}
