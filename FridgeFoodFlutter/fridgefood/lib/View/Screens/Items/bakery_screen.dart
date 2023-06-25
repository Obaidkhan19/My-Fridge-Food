import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fridgefood/Models/all_items.dart';
import 'package:fridgefood/Models/items.dart';
import 'package:fridgefood/utils/utilities.dart';
import 'package:fridgefood/constants.dart';
import 'package:fridgefood/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BakeryScreen extends StatefulWidget {
  const BakeryScreen({super.key});

  @override
  State<BakeryScreen> createState() => _BakeryScreenState();
}

class _BakeryScreenState extends State<BakeryScreen> {
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
  TextEditingController nameController = TextEditingController();
  List<Items> blist = [];
  Future<List<Items>> bakeryapi() async {
    final response =
        await http.get(Uri.parse('$ip/item/EggsandBakery?fid=$fridgeid'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      blist.clear();
      // sucess
      for (Map i in data) {
        blist.add(Items.fromJson(i));
      }
      return blist;
    } else {
      return blist;
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
          'Eggs and Bakery',
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
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              onChanged: (value) {
                setState(() {});
              },
              cursorColor: themeColor,
              decoration: InputDecoration(
                focusColor: themeColor,
                hintText: 'Search For Bakery Items',
                prefixIcon: IconButton(
                  color: themeColor,
                  icon: const Icon(Icons.search_outlined),
                  onPressed: () {},
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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Select the Bakery Items you have at home',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(
              thickness: 2,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 25,
            ),
            FutureBuilder(
              future: bakeryapi(),
              builder: (context, AsyncSnapshot<List<Items>> snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                } else {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: blist.length,
                        itemBuilder: (BuildContext context, int index) {
                          String itemname = snapshot.data![index].name!;
                          String added = snapshot.data![index].added!;
                          int itemid = snapshot.data![index].id!;
                          int fridgeitemid =
                              snapshot.data![index].fridgeItemId!;
                          if (nameController.text.isEmpty) {
                            return SizedBox(
                              height: 100,
                              child: ListTile(
                                leading: CachedNetworkImage(
                                  key: UniqueKey(),
                                  imageUrl: itemimgpath +
                                      snapshot.data![index].image!,
                                  imageBuilder: (context, imageProvider) =>
                                      Ink.image(
                                    image: imageProvider,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.fill,
                                  ),
                                  placeholder: (context, url) => Container(
                                    height: 100,
                                    width: 100,
                                    alignment: Alignment.center,
                                    child: Image.asset('assets/bakery.png'),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset('assets/bakery.png'),
                                ),
                                title: Text(
                                  itemname,
                                  style: const TextStyle(fontSize: 30),
                                ),
                                trailing: added == "added"
                                    ? IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("Alert"),
                                                content:
                                                    const Text("Removes Item."),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () async {
                                                      Items i = Items();
                                                      i.id = fridgeitemid;
                                                      await i.removeItemapi();
                                                      Navigator.of(context)
                                                          .pop();
                                                      Utils.snackBar(
                                                          "Removed", context);
                                                      setState(() {});
                                                    },
                                                    child: Text(
                                                      "Remove",
                                                      style: TextStyle(
                                                          color: themeColor),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.radio_button_checked_sharp,
                                          size: 30,
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () async {
                                          Items i = Items();
                                          i.id = itemid;
                                          i.fridgeid = fridgeid;
                                          String? jsonData = await i
                                              .addItem(); // AllItem object
                                          List<dynamic> jsonList =
                                              json.decode(jsonData!);
                                          AllItem detailobj =
                                              AllItem.fromJson(jsonList[0]);
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => EditDetail(
                                          //         detailobj: detailobj),
                                          //   ),
                                          // );
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.radio_button_off_outlined,
                                          size: 30,
                                        ),
                                      ),
                              ),
                            );
                          } else if (itemname
                              .toLowerCase()
                              .contains(nameController.text.toLowerCase())) {
                            return SizedBox(
                              height: 100,
                              child: ListTile(
                                leading: CachedNetworkImage(
                                  key: UniqueKey(),
                                  imageUrl: itemimgpath +
                                      snapshot.data![index].image!,
                                  imageBuilder: (context, imageProvider) =>
                                      Ink.image(
                                    image: imageProvider,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.fill,
                                  ),
                                  placeholder: (context, url) => Container(
                                    height: 100,
                                    width: 100,
                                    alignment: Alignment.center,
                                    child: Image.asset('assets/bakery.png'),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset('assets/bakery.png'),
                                ),
                                title: Text(
                                  itemname,
                                  style: const TextStyle(fontSize: 30),
                                ),
                                trailing: added == "added"
                                    ? IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("Alert"),
                                                content:
                                                    const Text("Removes Item."),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () async {
                                                      Items i = Items();
                                                      i.id = fridgeitemid;
                                                      await i.removeItemapi();
                                                      Navigator.of(context)
                                                          .pop();
                                                      Utils.snackBar(
                                                          "Removed", context);
                                                      setState(() {});
                                                    },
                                                    child: Text(
                                                      "Remove",
                                                      style: TextStyle(
                                                          color: themeColor),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.radio_button_checked_sharp,
                                          size: 30,
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () async {
                                          Items i = Items();
                                          i.id = itemid;
                                          i.fridgeid = fridgeid;
                                          String? jsonData = await i
                                              .addItem(); // AllItem object
                                          List<dynamic> jsonList =
                                              json.decode(jsonData!);
                                          AllItem detailobj =
                                              AllItem.fromJson(jsonList[0]);
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => EditDetail(
                                          //         detailobj: detailobj),
                                          //   ),
                                          // );
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.radio_button_off_outlined,
                                          size: 30,
                                        ),
                                      ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
