import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fridgefood/Functions/fromat_datetime.dart';
import 'package:fridgefood/Models/all_items.dart';
import 'package:fridgefood/View/Screens/FridgeItems/add_item.dart';
import 'package:fridgefood/View/Screens/FridgeItems/item_notification.dart';
import 'package:fridgefood/View/Screens/Items/items_dashboard.dart';
import 'package:fridgefood/View/Screens/FridgeItems/stock_detail.dart';
import 'package:fridgefood/constants.dart';
import 'package:boxicons/boxicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/utilities.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FridgeScreen extends StatefulWidget {
  const FridgeScreen({super.key});

  @override
  State<FridgeScreen> createState() => _FridgeScreenState();
}

class _FridgeScreenState extends State<FridgeScreen> {
  Color color = Colors.white;
  @override
  void initState() {
    super.initState();
    getdata();
    _fetchNumber();
  }

  void getdata() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    fridgeid = sp.getInt('fridgeid');
    userid = sp.getInt('userid');
    setState(() {});
  }

  int? fridgeid;
  int? userid;

  int _number = 0;

  Future<void> _fetchNumber() async {
    final response = await http
        .get(Uri.parse('$ip/FridgeItem/GetExpiringItemCount?fid=$fridgeid'));
    if (response.statusCode == 200) {
      setState(() {
        _number = int.parse(response.body);
      });
    } else {
      return;
    }
  }

  // GET Cooked
  List<AllItem> clist = [];
  Future<List<AllItem>> cookedapi() async {
    final response =
        await http.get(Uri.parse('$ip/Fridgeitem/Cooked?fid=$fridgeid'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      clist.clear();
      // sucess
      for (Map i in data) {
        clist.add(AllItem.fromJson(i));
      }
      return clist;
    } else {
      return clist;
    }
  }

  // GET FRUIT AND VEGE
  List<AllItem> alllist = [];
  Future<List<AllItem>> allfridgeitemsapi() async {
    final response = await http
        .get(Uri.parse('$ip/Fridgeitem/AllFridgeItems?fid=$fridgeid'));
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

  // GET FRUIT AND VEGE
  List<AllItem> fvlist = [];
  Future<List<AllItem>> fruitandvegeapi() async {
    final response = await http.get(
        Uri.parse('$ip/Fridgeitem/FruitandVegetableDashboard?fid=$fridgeid'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      fvlist.clear();
      // sucess
      for (Map i in data) {
        fvlist.add(AllItem.fromJson(i));
      }
      return fvlist;
    } else {
      return fvlist;
    }
  }

  // Eggs and bakery
  List<AllItem> eglist = [];
  Future<List<AllItem>> eggandbakeryapi() async {
    final response = await http
        .get(Uri.parse('$ip/Fridgeitem/EggandBakeryDashboard?fid=$fridgeid'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      eglist.clear();
      // sucess
      for (Map i in data) {
        eglist.add(AllItem.fromJson(i));
      }
      return eglist;
    } else {
      return eglist;
    }
  }

  // MEAT AND SEAFOOD
  List<AllItem> mslist = [];
  Future<List<AllItem>> meatandseafoodapi() async {
    final response = await http
        .get(Uri.parse('$ip/Fridgeitem/MeatandSeafoodDashboard?fid=$fridgeid'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      mslist.clear();
      // sucess
      for (Map i in data) {
        mslist.add(AllItem.fromJson(i));
      }
      return mslist;
    } else {
      return mslist;
    }
  }

// DAIRY
  List<AllItem> dlist = [];
  Future<List<AllItem>> dairyapi() async {
    final response = await http
        .get(Uri.parse('$ip/Fridgeitem/DairyDashboard?fid=$fridgeid'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      dlist.clear();
      // sucess
      for (Map i in data) {
        dlist.add(AllItem.fromJson(i));
      }
      return dlist;
    } else {
      return dlist;
    }
  }

  // // OTHERS
  List<AllItem> olist = [];
  Future<List<AllItem>> otherapi() async {
    final response = await http
        .get(Uri.parse('$ip/Fridgeitem/OthersDashboard?fid=$fridgeid'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      olist.clear();
      // sucess
      for (Map i in data) {
        olist.add(AllItem.fromJson(i));
      }
      return olist;
    } else {
      return olist;
    }
  }

  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: themeColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Fridge Food',
          style: headingTextStyle,
        ),
        leading: const Icon(
          Boxicons.bxs_fridge,
          size: 30.0,
          color: Colors.white,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 10),
            child: FutureBuilder(
                future: _fetchNumber(),
                builder: (context, snapshot) {
                  return Badge(
                    badgeContent: Text(
                      _number.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    badgeColor: Colors.red,
                    borderRadius: BorderRadius.circular(25),
                    toAnimate: false,
                    shape: BadgeShape.circle,
                    position: BadgePosition.topEnd(),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_none_outlined),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ItemNotificationScreen()),
                        );
                      },
                      color: Colors.white,
                      iconSize: 30,
                      padding: const EdgeInsets.only(right: 18, left: 6),
                    ),
                  );
                }),
          ),
        ],
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              // onTap: (() {
              //   final results =
              //       showSearch(context: context, delegate: ItemSearch());
              // }),
              onChanged: (value) {
                setState(() {});
              },
              cursorColor: themeColor,
              decoration: InputDecoration(
                focusColor: themeColor,
                hintText: 'Search For Items',
                prefixIcon: IconButton(
                  color: themeColor,
                  icon: const Icon(Icons.search_outlined),
                  onPressed: () {
                    // final results =
                    //     showSearch(context: context, delegate: ItemSearch());
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 5,
          ),
          Visibility(
            visible: nameController.text.isNotEmpty,
            child: SizedBox(
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
                          if (name
                              .toLowerCase()
                              .contains(nameController.text.toLowerCase())) {
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
                                    // Material(
                                    //   child: Ink.image(
                                    //     image: NetworkImage(
                                    //       itemimgpath +
                                    //           snapshot.data![index].image!,
                                    //     ),
                                    //     height: 110,
                                    //     width: 110,
                                    //     fit: BoxFit.cover,
                                    //     child: InkWell(onTap: () async {
                                    //       await Navigator.push(
                                    //         context,
                                    //         MaterialPageRoute(
                                    //           builder: (context) =>
                                    //               StockDetail(fvobj),
                                    //         ),
                                    //       );
                                    //       setState(() {
                                    //         color = color == Colors.white
                                    //             ? Colors.grey
                                    //             : Colors.white;
                                    //       });
                                    //     }),
                                    //   ),
                                    // ),
                                    Material(
                                      child: CachedNetworkImage(
                                        key: UniqueKey(),
                                        imageUrl: itemimgpath +
                                            snapshot.data![index].image!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Ink.image(
                                          image: imageProvider,
                                          height: 110,
                                          width: 110,
                                          fit: BoxFit.cover,
                                          child: InkWell(
                                            onTap: () async {
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
                                            },
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Container(
                                          height: 110,
                                          width: 110,
                                          alignment: Alignment.center,
                                          child:
                                              Image.asset('assets/additem.png'),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset('assets/additem.png'),
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
                          } else {
                            return Container();
                          }
                        }),
                      );
                    }
                  }),
            ),
          ),
          Visibility(
            visible: clist.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Cooked',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      //  color: Colors.black,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: clist.isNotEmpty,
            child: const SizedBox(
              height: 25,
            ),
          ),
          Visibility(
            visible: clist.isNotEmpty,
            child: SizedBox(
              height: 160,
              child: FutureBuilder(
                  future: cookedapi(),
                  builder: (context, AsyncSnapshot<List<AllItem>> snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else {
                      return ListView.separated(
                        // shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(10),
                        itemCount: clist.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: 12,
                          );
                        },
                        itemBuilder: ((BuildContext context, int index) {
                          // double? quantity1 = snapshot.data![index].quantity;
                          // String quantityString = quantity1
                          //         ?.toStringAsFixed(1) ??
                          //     "0.0"; // convert double to string and round to 1 decimal place
                          // String quantity = quantityString.endsWith(".0")
                          //     ? quantityString.substring(
                          //         0, quantityString.length - 2)
                          //     : quantityString; // remove decimal and trailing zero if the weight is a whole number
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
                          AllItem cobj = clist[index];
                          if (nameController.text.isEmpty) {
                            return Badge(
                              badgeContent: Text(
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
                                      child: CachedNetworkImage(
                                        key: UniqueKey(),
                                        imageUrl: itemimgpath +
                                            snapshot.data![index].image!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Ink.image(
                                          image: imageProvider,
                                          height: 110,
                                          width: 110,
                                          fit: BoxFit.cover,
                                          child: InkWell(
                                            onTap: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      StockDetail(cobj),
                                                ),
                                              );
                                              setState(() {
                                                color = color == Colors.white
                                                    ? Colors.grey
                                                    : Colors.white;
                                              });
                                            },
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Container(
                                          height: 110,
                                          width: 110,
                                          alignment: Alignment.center,
                                          child:
                                              Image.asset('assets/cooked.jpg'),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset('assets/cooked.jpg'),
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
                          } else {
                            return Container();
                          }
                        }),
                      );
                    }
                  }),
            ),
          ),
          Visibility(
            visible: clist.isNotEmpty,
            child: const SizedBox(
              height: 15,
            ),
          ),
          Visibility(
            visible: fvlist.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Fruit and Vegetables',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      //  color: Colors.black,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: fvlist.isNotEmpty,
            child: const SizedBox(
              height: 25,
            ),
          ),
          Visibility(
            visible: fvlist.isNotEmpty,
            child: SizedBox(
              height: 160,
              child: FutureBuilder(
                  future: fruitandvegeapi(),
                  builder: (context, AsyncSnapshot<List<AllItem>> snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else {
                      return ListView.separated(
                        // shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(10),
                        itemCount: fvlist.length,
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
                          AllItem fvobj = fvlist[index];
                          if (nameController.text.isEmpty) {
                            return Badge(
                              badgeContent: Text(
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
                                      child: CachedNetworkImage(
                                        key: UniqueKey(),
                                        imageUrl: itemimgpath +
                                            snapshot.data![index].image!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Ink.image(
                                          image: imageProvider,
                                          height: 110,
                                          width: 110,
                                          fit: BoxFit.cover,
                                          child: InkWell(
                                            onTap: () async {
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
                                            },
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Container(
                                          height: 110,
                                          width: 110,
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                              'assets/fruitandvege.png'),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                'assets/fruitandvege.png'),
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
                          } else {
                            return Container();
                          }
                        }),
                      );
                    }
                  }),
            ),
          ),
          Visibility(
            visible: fvlist.isNotEmpty,
            child: const SizedBox(
              height: 15,
            ),
          ),
          Visibility(
            visible: eglist.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Eggs and Bakery',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      //  color: Colors.black,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: eglist.isNotEmpty,
            child: const SizedBox(
              height: 25,
            ),
          ),
          Visibility(
            visible: eglist.isNotEmpty,
            child: SizedBox(
              height: 160,
              child: FutureBuilder(
                  future: eggandbakeryapi(),
                  builder: (context, AsyncSnapshot<List<AllItem>> snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else {
                      return ListView.separated(
                        // shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(10),
                        itemCount: eglist.length,
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
                          AllItem egobj = eglist[index];
                          if (nameController.text.isEmpty) {
                            return Badge(
                              badgeContent: Text(
                                // quantity.toString() == 'null' ||
                                //         quantity.toString() == "0" &&
                                //             quantityunit.toString() == 'null'
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
                                      child: CachedNetworkImage(
                                        key: UniqueKey(),
                                        imageUrl: itemimgpath +
                                            snapshot.data![index].image!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Ink.image(
                                          image: imageProvider,
                                          height: 110,
                                          width: 110,
                                          fit: BoxFit.cover,
                                          child: InkWell(
                                            onTap: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      StockDetail(egobj),
                                                ),
                                              );
                                              setState(() {
                                                color = color == Colors.white
                                                    ? Colors.grey
                                                    : Colors.white;
                                              });
                                            },
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Container(
                                          height: 110,
                                          width: 110,
                                          alignment: Alignment.center,
                                          child:
                                              Image.asset('assets/bakery.png'),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset('assets/bakery.png'),
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
                          } else {
                            return Container();
                          }
                        }),
                      );
                    }
                  }),
            ),
          ),
          Visibility(
            visible: eglist.isNotEmpty,
            child: const SizedBox(
              height: 15,
            ),
          ),
          Visibility(
            visible: mslist.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Meat and Seafood',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      //  color: Colors.black,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: mslist.isNotEmpty,
            child: const SizedBox(
              height: 25,
            ),
          ),
          Visibility(
            visible: mslist.isNotEmpty,
            child: SizedBox(
              height: 160,
              child: FutureBuilder(
                  future: meatandseafoodapi(),
                  builder: (context, AsyncSnapshot<List<AllItem>> snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else {
                      return ListView.separated(
                        // shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(10),
                        itemCount: mslist.length,
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
                          AllItem msobj = mslist[index];
                          if (nameController.text.isEmpty) {
                            return Badge(
                              badgeContent: Text(
                                // quantity.toString() == 'null' ||
                                //         quantity.toString() == "0" &&
                                //             quantityunit.toString() == 'null'
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
                                      child: CachedNetworkImage(
                                        key: UniqueKey(),
                                        imageUrl: itemimgpath +
                                            snapshot.data![index].image!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Ink.image(
                                          image: imageProvider,
                                          height: 110,
                                          width: 110,
                                          fit: BoxFit.cover,
                                          child: InkWell(
                                            onTap: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      StockDetail(msobj),
                                                ),
                                              );
                                              setState(() {
                                                color = color == Colors.white
                                                    ? Colors.grey
                                                    : Colors.white;
                                              });
                                            },
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Container(
                                          height: 110,
                                          width: 110,
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                              'assets/meatandseafood.jpg'),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                'assets/meatandseafood.jpg'),
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
                          } else {
                            return Container();
                          }
                        }),
                      );
                    }
                  }),
            ),
          ),
          Visibility(
            visible: mslist.isNotEmpty,
            child: const SizedBox(
              height: 15,
            ),
          ),
          Visibility(
            visible: dlist.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Dairy',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      //   color: Colors.black,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: dlist.isNotEmpty,
            child: const SizedBox(
              height: 25,
            ),
          ),
          Visibility(
            visible: dlist.isNotEmpty,
            child: SizedBox(
              height: 160,
              child: FutureBuilder(
                  future: dairyapi(),
                  builder: (context, AsyncSnapshot<List<AllItem>> snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else {
                      return ListView.separated(
                        // shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(10),
                        itemCount: dlist.length,
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
                          AllItem dobj = dlist[index];
                          if (nameController.text.isEmpty) {
                            return Badge(
                              badgeContent: Text(
                                // quantity.toString() == 'null' ||
                                //         quantity.toString() == "0" &&
                                //             quantityunit.toString() == 'null'
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
                                      child: CachedNetworkImage(
                                        key: UniqueKey(),
                                        imageUrl: itemimgpath +
                                            snapshot.data![index].image!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Ink.image(
                                          image: imageProvider,
                                          height: 110,
                                          width: 110,
                                          fit: BoxFit.cover,
                                          child: InkWell(
                                            onTap: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      StockDetail(dobj),
                                                ),
                                              );
                                              setState(() {
                                                color = color == Colors.white
                                                    ? Colors.grey
                                                    : Colors.white;
                                              });
                                            },
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Container(
                                          height: 110,
                                          width: 110,
                                          alignment: Alignment.center,
                                          child:
                                              Image.asset('assets/dairy.png'),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset('assets/dairy.png'),
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
                          } else {
                            return Container();
                          }
                        }),
                      );
                    }
                  }),
            ),
          ),
          Visibility(
            visible: dlist.isNotEmpty,
            child: const SizedBox(
              height: 15,
            ),
          ),
          Visibility(
            visible: olist.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Others',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      //   color: Colors.black,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: olist.isNotEmpty,
            child: const SizedBox(
              height: 25,
            ),
          ),
          Visibility(
            visible: olist.isNotEmpty,
            child: SizedBox(
              height: 160,
              child: FutureBuilder(
                  future: otherapi(),
                  builder: (context, AsyncSnapshot<List<AllItem>> snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else {
                      return ListView.separated(
                        // shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(10),
                        itemCount: olist.length,
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

                          AllItem oobj = olist[index];
                          if (nameController.text.isEmpty) {
                            return Badge(
                              badgeContent: Text(
                                // quantity.toString() == 'null' ||
                                //         quantity.toString() == "0" &&
                                //             quantityunit.toString() == 'null'
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
                                      child: CachedNetworkImage(
                                        key: UniqueKey(),
                                        imageUrl: itemimgpath +
                                            snapshot.data![index].image!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Ink.image(
                                          image: imageProvider,
                                          height: 110,
                                          width: 110,
                                          fit: BoxFit.cover,
                                          child: InkWell(
                                            onTap: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      StockDetail(oobj),
                                                ),
                                              );
                                              setState(() {
                                                color = color == Colors.white
                                                    ? Colors.grey
                                                    : Colors.white;
                                              });
                                            },
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Container(
                                          height: 110,
                                          width: 110,
                                          alignment: Alignment.center,
                                          child:
                                              Image.asset('assets/others.png'),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset('assets/others.png'),
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
                          } else {
                            return Container();
                          }
                        }),
                      );
                    }
                  }),
            ),
          ),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              elevation: 10,
              backgroundColor: themeColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CommonItemsDashboard()),
                        );
                      },
                      title: const Text(
                        'Add Common Items',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddItemScreen()),
                        );
                      },
                      title: const Text(
                        'Add Custom Items',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
              });
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => const CommonItemsDashboard()),
          // );
        },
        tooltip: 'Increment',
        backgroundColor: themeColor,
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }
}
