import 'package:badges/badges.dart';
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:fridgefood/Functions/fromat_datetime.dart';
import 'package:fridgefood/Models/item_notification.dart';
import 'package:fridgefood/View/Screens/FridgeItems/stock_detail.dart';

import '../../../Models/all_items.dart';
import '../../../constants.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/utilities.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExpiringSoon extends StatefulWidget {
  const ExpiringSoon({super.key});

  @override
  State<ExpiringSoon> createState() => _ExpiringSoonState();
}

class _ExpiringSoonState extends State<ExpiringSoon> {
  Color color = Colors.white;
  List<AllItem> alllist = [];
  Future<List<AllItem>> allfridgeitemsapi() async {
    final response = await http
        .get(Uri.parse('$ip/FridgeItem/GetExpiringItems?fid=$fridgeid'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      alllist.clear();
      // sucess
      for (Map i in data) {
        alllist.add(AllItem.fromJson(i));
      }
      return alllist;
    } else {
      return alllist;
    }
  }

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
        titleSpacing: 0,
        backgroundColor: themeColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Expiring Soon Items',
          style: headingTextStyle,
        ),
        leading: const Icon(
          Boxicons.bxs_fridge,
          size: 30.0,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Expiring Soon Items",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 236, 137, 23)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 160,
              child: FutureBuilder(
                  future: allfridgeitemsapi(),
                  builder: (context, AsyncSnapshot<List<AllItem>> snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else {
                      return ListView.separated(
                        // shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(10),
                        itemCount: alllist.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: 12,
                          );
                        },
                        itemBuilder: ((BuildContext context, int index) {
                          double? quantity1 = snapshot.data![index].quantity;
                          String quantityString = quantity1?.toString() ??
                              "0.0"; // Convert double to string without rounding
                          String quantity = quantityString.endsWith(".0")
                              ? quantityString.substring(
                                  0, quantityString.length - 2)
                              : quantityString; // Remove decimal and trailing zero if the weight is a whole number

                          String? quantityunit =
                              snapshot.data![index].quantityUnit;

                          String name = snapshot.data![index].name.toString();
                          String Status =
                              snapshot.data![index].status.toString();
                          FromatedDateTime fdt = FromatedDateTime();
                          String expirydate =
                              snapshot.data![index].expiryDate ?? "notset";
                          String date = "notset";
                          if (expirydate != "notset") {
                            DateTime datetime = DateTime.parse(
                                snapshot.data![index].expiryDate!);
                            date = fdt.formatDate(datetime);
                          }
                          AllItem fvobj = alllist[index];
                          return Badge(
                            badgeContent: Text(
                              // quantity.toString() == 'null' &&
                              //         quantityunit.toString() == 'null'
                              (int.tryParse(quantity) == 0 &&
                                      quantityunit == null)
                                  ? 'No Stock'
                                  : quantityunit.toString() == 'null'
                                      ? quantity.toString()
                                      : '$quantity $quantityunit',
                              style: const TextStyle(color: Colors.white),
                            ),
                            badgeColor: Status == 'Good'
                                ? themeColor
                                : Status == 'ExpiringSoon'
                                    ? const Color.fromARGB(255, 236, 137, 23)
                                    : Status == 'Expired'
                                        ? Colors.red
                                        : Colors.red,
                            borderRadius: BorderRadius.circular(25),
                            toAnimate: false,
                            shape: BadgeShape.square,
                            position: BadgePosition.topEnd(),
                            child: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Material(
                                    child: Ink.image(
                                      image: NetworkImage(
                                        itemimgpath +
                                            snapshot.data![index].image!,
                                      ),
                                      height: 110,
                                      width: 110,
                                      fit: BoxFit.cover,
                                      child: InkWell(onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                StockDetail(fvobj),
                                          ),
                                        );
                                        setState(() {
                                          color = color == Colors.white
                                              ? Colors.grey
                                              : Colors.white;
                                        });
                                      }),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: (2),
                                  ),
                                  Text(
                                    snapshot.data![index].name.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Status == 'Good'
                                          ? themeColor
                                          : Status == 'ExpiringSoon'
                                              ? const Color.fromARGB(
                                                  255, 236, 137, 23)
                                              : Status == 'Expired'
                                                  ? Colors.red
                                                  : Colors.red,
                                    ),
                                  ),
                                  if (expirydate != "notset")
                                    Text(
                                      "Expiry: $date",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Status == 'Good'
                                            ? themeColor
                                            : Status == 'ExpiringSoon'
                                                ? const Color.fromARGB(
                                                    255, 236, 137, 23)
                                                : Status == 'Expired'
                                                    ? Colors.red
                                                    : Colors.red,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    }
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Recipe Using Expiring Soon Items",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 236, 137, 23)),
              ),
            ),
            FutureBuilder(
              future: itemnotificationapi(),
              builder:
                  (context, AsyncSnapshot<List<ItemNotification>> snapshot) {
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
                        if (recipeNames.isNotEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              // padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: status == 'Expired'
                                    ? Colors.red
                                    : const Color.fromARGB(255, 236, 137, 23),
                                borderRadius: BorderRadius.circular(14.0),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 202, 117, 117)
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
                                    subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          if (recipeNames.isNotEmpty)
                                            Text(
                                              'Recipes of $name',
                                              style: const TextStyle(
                                                fontSize: 22,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          const SizedBox(height: 5),
                                          if (recipeNames.isNotEmpty)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: recipeNames
                                                  .map((recipeName) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .arrow_forward_ios_outlined,
                                                              size: 15,
                                                              color:
                                                                  Colors.white,
                                                              weight: 40,
                                                            ),
                                                            // const Text(
                                                            //   'You can make ',
                                                            //   style: TextStyle(
                                                            //     fontSize: 19,
                                                            //     color: Colors
                                                            //         .white,
                                                            //   ),
                                                            // ),
                                                            Text(
                                                              recipeName,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 19,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            // Text(
                                                            //   ' with $name.',
                                                            //   style:
                                                            //       const TextStyle(
                                                            //     fontSize: 19,
                                                            //     color: Colors
                                                            //         .white,
                                                            //   ),
                                                            // ),
                                                          ],
                                                        ),
                                                      ))
                                                  .toList(),
                                            ),
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return Container();
                      });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
