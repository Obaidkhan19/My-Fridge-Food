import 'dart:async';
import 'dart:convert';
import 'package:fridgefood/Functions/fromat_datetime.dart';
import 'package:fridgefood/Models/recipe_order.dart';
import 'package:fridgefood/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fridgefood/utils/utilities.dart';
import 'package:fridgefood/View/Widgets/MyButton.dart';
import 'package:fridgefood/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeNotificationScreen extends StatefulWidget {
  const RecipeNotificationScreen({super.key});

  @override
  State<RecipeNotificationScreen> createState() =>
      _RecipeNotificationScreenState();
}

class _RecipeNotificationScreenState extends State<RecipeNotificationScreen> {
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
    userid = sp.getInt('userid');
    setState(() {});
  }

  int? fridgeid;
  int? userid;
  List<RecipeOrder> rolist = [];
  Future<List<RecipeOrder>> recipeOrderapi() async {
    final response = await http.get(Uri.parse(
        '$ip/Notification/ViewNotification?uid=$userid&fid=$fridgeid'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      rolist.clear();
      // sucess
      for (Map i in data) {
        rolist.add(RecipeOrder.fromJson(i));
      }
      return rolist;
    } else {
      return rolist;
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
        future: recipeOrderapi(),
        builder: (context, AsyncSnapshot<List<RecipeOrder>> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: rolist.length,
                itemBuilder: (BuildContext context, int index) {
                  int nid = snapshot.data![index].id!;
                  int sid = snapshot.data![index].senderId ?? 0;
                  int rid = snapshot.data![index].recieverId ?? 0;
                  String? title = snapshot.data![index].title!;
                  String? body = snapshot.data![index].body!;
                  String? reply = snapshot.data![index].reply ?? '';

                  DateTime mealdatetime =
                      DateTime.parse(snapshot.data![index].mealDate!);
                  FromatedDateTime fdt = FromatedDateTime();
                  String mealdate = fdt.formatDate(mealdatetime);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      // padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 70, 165, 209),
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
                              // leading: const Icon(
                              //   Icons.person_outline_outlined,
                              //   color: Colors.white,
                              //   size: 40,
                              // ),
                              title: Text(
                                title,
                                style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          body,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ),
                                      // isSeen == true
                                      //     ? const Icon(
                                      //         Icons.done_all,
                                      //         color: Color.fromARGB(255, 11, 4, 75),
                                      //         size: 20,
                                      //       )
                                      //     : const Icon(
                                      //         Icons.done_all,
                                      //         color: Colors.white,
                                      //         size: 20,
                                      //       ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'On ',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        mealdate,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Reply : ',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        reply.isEmpty ? 'No Reply' : reply,
                                        style: const TextStyle(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  // if (userid != sid && reply.isEmpty)
                                  //   Row(
                                  //     children: [
                                  //       if (reply.isEmpty || reply == 'sorry')
                                  //         NewButton(
                                  //             text: 'OK',
                                  //             backgroundColor: themeColor,
                                  //             buttonwidth: 130,
                                  //             onPress: () async {
                                  //               RecipeOrder ro = RecipeOrder();
                                  //               ro.reply = 'ok';
                                  //               ro.id = nid;
                                  //               await ro.replyapi();
                                  //               setState(() {});
                                  //             },
                                  //             textColor: Colors.white),
                                  //       if (reply.isEmpty || reply == 'ok')
                                  //         NewButton(
                                  //             text: 'Sorry',
                                  //             backgroundColor: Colors.red,
                                  //             buttonwidth: 130,
                                  //             onPress: () async {
                                  //               RecipeOrder ro = RecipeOrder();
                                  //               ro.reply = 'sorry';
                                  //               ro.id = nid;

                                  //               await ro.replyapi();
                                  //               setState(() {});
                                  //             },
                                  //             textColor: Colors.white),
                                  //     ],
                                  //   ),
                                  if (userid != sid)
                                    Row(
                                      children: [
                                        if (reply.isEmpty)
                                          Row(
                                            children: [
                                              NewButton(
                                                text: 'OK',
                                                backgroundColor: themeColor,
                                                buttonwidth: 130,
                                                onPress: () async {
                                                  RecipeOrder ro =
                                                      RecipeOrder();
                                                  ro.reply = 'ok';
                                                  ro.id = nid;
                                                  await ro.replyapi();
                                                  setState(() {
                                                    reply =
                                                        'ok'; // update the reply variable
                                                  });
                                                },
                                                textColor: Colors.white,
                                              ),
                                              NewButton(
                                                text: 'Sorry',
                                                backgroundColor: Colors.red,
                                                buttonwidth: 130,
                                                onPress: () async {
                                                  RecipeOrder ro =
                                                      RecipeOrder();
                                                  ro.reply = 'sorry';
                                                  ro.id = nid;
                                                  await ro.replyapi();
                                                  setState(() {
                                                    reply =
                                                        'sorry'; // update the reply variable
                                                  });
                                                },
                                                textColor: Colors.white,
                                              ),
                                            ],
                                          ),
                                        if (reply == 'sorry')
                                          NewButton(
                                            text: 'OK',
                                            backgroundColor: themeColor,
                                            buttonwidth: 130,
                                            onPress: () async {
                                              RecipeOrder ro = RecipeOrder();
                                              ro.reply = 'ok';
                                              ro.id = nid;
                                              await ro.replyapi();
                                              setState(() {
                                                reply =
                                                    'ok'; // update the reply variable
                                              });
                                            },
                                            textColor: Colors.white,
                                          ),
                                        if (reply == 'ok')
                                          NewButton(
                                            text: 'Sorry',
                                            backgroundColor: Colors.red,
                                            buttonwidth: 130,
                                            onPress: () async {
                                              RecipeOrder ro = RecipeOrder();
                                              ro.reply = 'sorry';
                                              ro.id = nid;
                                              await ro.replyapi();
                                              setState(() {
                                                reply =
                                                    'sorry'; // update the reply variable
                                              });
                                            },
                                            textColor: Colors.white,
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                              // edit and delete for recipe only

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
                                                      "Delete Order."),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () async {
                                                        RecipeOrder ro =
                                                            RecipeOrder();
                                                        ro.id = nid;
                                                        String? response =
                                                            await ro
                                                                .deleteorderapi();
                                                        Utils.snackBar(
                                                            'Removed', context);
                                                        setState(() {});
                                                        Navigator.of(context)
                                                            .pop();
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
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 25,
                                          )),
                                    )
                                  : null),
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
