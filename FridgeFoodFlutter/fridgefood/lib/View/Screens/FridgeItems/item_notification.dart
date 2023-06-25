import 'dart:async';
import 'dart:convert';
import 'package:fridgefood/Models/item_notification.dart';
import 'package:fridgefood/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fridgefood/utils/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemNotificationScreen extends StatefulWidget {
  const ItemNotificationScreen({super.key});

  @override
  State<ItemNotificationScreen> createState() => _ItemNotificationScreenState();
}

class _ItemNotificationScreenState extends State<ItemNotificationScreen> {
  // for expiry color red for order recipe color blue

  Color color = Colors.white;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    getdata();
    // formattedDateTime = formatDateTime(dateTime);
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void getdata() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    fridgeid = sp.getInt('fridgeid');
    setState(() {});
  }

  int? fridgeid;
  List<ItemNotification> inlist = [];
  Future<List<ItemNotification>> itemnotificationapi() async {
    final response = await http
        .get(Uri.parse('$ip/FridgeItem/GetExpiringItems?fid=$fridgeid'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      inlist.clear();
      // sucess
      for (Map i in data) {
        inlist.add(ItemNotification.fromJson(i));
      }
      return inlist;
    } else {
      return inlist;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: themeColor,
        title: const Text(
          'Notification',
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
        future: itemnotificationapi(),
        builder: (context, AsyncSnapshot<List<ItemNotification>> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: inlist.length,
                itemBuilder: (BuildContext context, int index) {
                  String name = snapshot.data![index].name!;
                  String status = snapshot.data![index].status!;
                  DateTime expirydateTime = DateTime.parse(
                      snapshot.data![index].expiryDate.toString());
                  var today = DateTime.now();
                  Duration difference = expirydateTime.difference(today);
                  int days = difference.inDays;
                  dynamic expirydays = days == 0
                      ? "Tomorrow"
                      : days == 1
                          ? "in $days day"
                          : "in $days days";
                  List<String> recipeNames =
                      snapshot.data![index].recipeNames ?? [];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      // padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: status == 'Expired'
                            ? Colors.red
                            : const Color.fromARGB(255, 236, 137, 23),
                        borderRadius: BorderRadius.circular(14.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 202, 117, 117)
                                .withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text(
                              'Item Expiry',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          status == 'Expired'
                                              ? '$name has Expired !'
                                              : status == 'ExpiringSoon'
                                                  ? '$name are going to expire $expirydays !'
                                                  : '',
                                          style: const TextStyle(
                                              fontSize: 19,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  // if (recipeNames.isNotEmpty)
                                  //   const Text(
                                  //     'You can make these recipe ',
                                  //     style: TextStyle(
                                  //       fontSize: 22,
                                  //       color: Colors.white,
                                  //       fontWeight: FontWeight.bold,
                                  //     ),
                                  //   ),
                                  // const SizedBox(height: 5),
                                  // if (recipeNames.isNotEmpty)
                                  //   Column(
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //     children: recipeNames
                                  //         .map((recipeName) => Text(
                                  //               recipeName,
                                  //               style: const TextStyle(
                                  //                 fontSize: 16,
                                  //                 color: Colors.white,
                                  //               ),
                                  //             ))
                                  //         .toList(),
                                  //   ),
                                ]),
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
