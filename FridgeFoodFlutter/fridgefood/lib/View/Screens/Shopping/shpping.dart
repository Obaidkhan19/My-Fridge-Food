import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fridgefood/Functions/fromat_datetime.dart';
import 'package:fridgefood/Models/shoppinglist.dart';
import 'package:fridgefood/utils/utilities.dart';
import 'package:fridgefood/View/Screens/Shopping/add_to_cart.dart';
import 'package:fridgefood/constants.dart';
import 'package:fridgefood/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Widgets/MyButton.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final StreamController _streamController = StreamController();
  Color color = Colors.white;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    getdata();
    // formattedDateTime = formatDateTime(dateTime);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    userid = sp.getInt('userid');
    setState(() {});
  }

  int? fridgeid;
  int? userid;
  List<Shoppinglist> slist = [];
  Future<List<Shoppinglist>> shoppinglistapi() async {
    final response = await http
        .get(Uri.parse('$ip/shoppinglist/allshoppinglist?fid=$fridgeid'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      slist.clear();
      // sucess
      for (Map i in data) {
        slist.add(Shoppinglist.fromJson(i));
        //_streamController.sink.add(i);
      }
      return slist;
    } else {
      return slist;
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
          'Shopping List',
          style: headingTextStyle,
        ),
        leading: const Icon(
          Icons.shopping_cart_outlined,
          size: 30.0,
          color: Colors.white,
        ),
      ),
      body: FutureBuilder(
        future: shoppinglistapi(),
        builder: (context, AsyncSnapshot<List<Shoppinglist>> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: slist.length,
                itemBuilder: (BuildContext context, int index) {
                  int id = snapshot.data![index].id!;
                  int sid = snapshot.data![index].senderId ?? 0;
                  int rid = snapshot.data![index].replierId ?? 0;
                  String replier = snapshot.data![index].replierName ?? '';
                  String header = snapshot.data![index].header!;
                  FromatedDateTime fdt = FromatedDateTime();
                  DateTime datetime =
                      DateTime.parse(snapshot.data![index].date!);
                  String date = fdt.formatDateTime(datetime);
                  // final fname = flist[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
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
                          const SizedBox(
                            height: 25,
                          ),
                          ListTile(
                            title: Text(
                              header,
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        snapshot.data![index].body!,
                                        style: const TextStyle(
                                            fontSize: 19, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  date,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),

                                // I WILL BUY
                                userid != sid && rid == 0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          NewButton(
                                              text: 'I will buy',
                                              backgroundColor: themeColor,
                                              buttonwidth: 250,
                                              onPress: () async {
                                                Shoppinglist s = Shoppinglist();
                                                s.replierId = userid;
                                                s.id = id;
                                                String? response =
                                                    await s.replyorderapi();
                                                setState(() {});
                                              },
                                              textColor: Colors.white),
                                        ],
                                      )
                                    : const SizedBox(
                                        height: 0,
                                      ),

                                // I HAVE BOUGHT AND DELETE
                                rid.toString() == userid.toString()
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          NewButton(
                                              text: 'Done',
                                              backgroundColor: themeColor,
                                              buttonwidth: 100,
                                              onPress: () async {
                                                Shoppinglist s = Shoppinglist();
                                                s.id = id;
                                                String? response =
                                                    await s.deleteorderapi();
                                                Utils.snackBar(
                                                    'Removed', context);
                                                setState(() {});
                                              },
                                              textColor: Colors.white),
                                          NewButton(
                                              text: 'Cancel',
                                              backgroundColor: themeColor,
                                              buttonwidth: 100,
                                              onPress: () async {
                                                Shoppinglist s = Shoppinglist();
                                                s.id = id;
                                                String? response =
                                                    await s.cancelReply();
                                                Utils.snackBar(
                                                    'Cancel', context);
                                                setState(() {});
                                              },
                                              textColor: Colors.white),
                                        ],
                                      )
                                    : const SizedBox(
                                        height: 0,
                                      ),

                                // SHOW OTHER WHO IS GOING TO BUY THIS
                                userid != rid && rid != 0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: NewButton(
                                                text: '$replier will buy this',
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 41, 101, 150),
                                                buttonwidth: 250,
                                                onPress: () {},
                                                textColor: Colors.white),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(
                                        height: 0,
                                      ),
                              ],
                            ),
                            trailing: sid == userid
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: IconButton(
                                        onPressed: () async {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("Alert"),
                                                content: const Text(
                                                    "Delete Notification."),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () async {
                                                      Shoppinglist s =
                                                          Shoppinglist();
                                                      s.id = id;
                                                      String? response = await s
                                                          .deleteorderapi();
                                                      Utils.snackBar(
                                                          'Removed', context);
                                                      setState(() {});
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      "Delete",
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
                                          Icons.delete,
                                          color: Colors.white,
                                          size: 25,
                                        )),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final value = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddToCart()),
          );
          setState(() {
            color = color == Colors.white ? Colors.grey : Colors.white;
          });
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
