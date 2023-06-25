import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fridgefood/Models/fridge.dart';
import 'package:fridgefood/constants.dart';
import 'package:fridgefood/utils/utils.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Models/fridgeuser.dart';
import '../../../Models/user.dart';
import '../../../utils/utilities.dart';
import '../Account/account_screen.dart';

enum _MenuValues { MakeAdmin, RemoveAdmin, RemoveFromFridge, MakeOwner }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Color color = Colors.white;
  @override
  void initState() {
    super.initState();
    getdata();
    // fridgeapi().then((_) {
    //   setState(() {
    //     connectionId = connectionId ?? ''; // assign default value if null
    //   });
    // });
    allconnectedusersapi();
  }

  void getdata() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    fridgeidd = sp.getInt('fridgeid');
    userid = sp.getInt('userid');
    rolee = sp.getString('role');
    setState(() {});
  }

  // all connected user to a fridge
  int? fridgeidd;
  int? freezertypee;
  int? userid;
  String? rolee;
  List<User> allconnectedusers = [];
  final _userOrderKey = 'userOrder';

  bool hasOwner = false;
  Future<List<User>> allconnectedusersapi() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final userOrderKey = 'userOrder_$fridgeidd';
    final List<String>? userOrder = sp.getStringList(userOrderKey);
    final response = await http.get(Uri.parse(
        '$ip/user/GetAllConnectedUsersByFridgeId?fid=$fridgeidd&uid=$userid'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      allconnectedusers.clear();
      // sucess
      for (Map i in data) {
        allconnectedusers.add(User.fromJson(i));
        User user = User.fromJson(i);
        if (user.role == 'owner') {
          hasOwner = true;
        }
      }
      if (userOrder != null) {
        allconnectedusers.sort((a, b) =>
            userOrder.indexOf(a.id.toString()) -
            userOrder.indexOf(b.id.toString()));
      }
      // allconnectedusers.removeWhere((user) => user.id == userid);
      return allconnectedusers;
    } else {
      return allconnectedusers;
    }
  }

  Future<void> _saveUserOrder(int fridgeId) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final userOrderKey = 'userOrder_$fridgeId';
    final List<String> userOrder =
        allconnectedusers.map((user) => user.id.toString()).toList();
    await sp.setStringList(userOrderKey, userOrder);
  }

  List<Fridge> flist = [];
  // List<String> connectionidlist = [];
  // String? connectionId;
// FRIDGE DETAIL
  Future<List<Fridge>> fridgeapi() async {
    final response =
        await http.get(Uri.parse('$ip/fridge/FridgeDetail?fid=$fridgeidd'));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      flist.clear();
      //  connectionidlist.clear();
      // success
      for (Map i in data) {
        Fridge fridge = Fridge.fromJson(i);
        flist.add(fridge);
        //  connectionidlist.add(fridge.connectionId!);
      }
      //  connectionId = flist.isNotEmpty ? flist[0].connectionId : '';
      return flist;
    } else {
      return flist;
    }
  }

  // USER`s FRIDGES
  List<Fridgeuser> fulist = [];
  Future<List<Fridgeuser>> allfridgeapi() async {
    final response =
        await http.get(Uri.parse('$ip/user/UserAllFridges?uid=$userid'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      fulist.clear();
      // sucess
      for (Map i in data) {
        fulist.add(Fridgeuser.fromJson(i));
      }
      return fulist;
    } else {
      return fulist;
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
          'Profile',
          style: headingTextStyle,
        ),
        leading: const Icon(
          Icons.account_circle_outlined,
          size: 30.0,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              var value = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountScreen()),
              );
              setState(() {
                color = color == Colors.white ? Colors.grey : Colors.white;
              });
            },
            color: Colors.white,
            iconSize: 30,
            padding: const EdgeInsets.only(right: 18),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),

            const Icon(
              Icons.person,
              size: 120,
            ),
            const SizedBox(
              height: 20,
            ),

            const Divider(
              thickness: 1,
            ),

            // SHARE FRIDGE
            rolee == 'owner' || rolee == 'admin'
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Fridge',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // print(connectionidlist.join(", "));

                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Image.asset(
                                      'assets/sharelogo.png',
                                    ),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Invite Your Fridgemates!',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          // Text(
                                          //   // connectionidlist.join(", "),f
                                          //   // connectionId!,
                                          //   style: const TextStyle(
                                          //       fontSize: 25,
                                          //       fontWeight: FontWeight.bold),
                                          // ),
                                          FutureBuilder<List<Fridge>>(
                                            future: fridgeapi(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const CircularProgressIndicator();
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              } else if (snapshot.hasData) {
                                                String connectionID =
                                                    snapshot.data!.isNotEmpty
                                                        ? snapshot.data![0]
                                                            .connectionId!
                                                        : '';
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      // snapshot.data!.isNotEmpty
                                                      //     ? snapshot.data![0]
                                                      //         .connectionId!
                                                      //     : '',
                                                      connectionID,
                                                      style: const TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          Clipboard.setData(
                                                              ClipboardData(
                                                                  text:
                                                                      connectionID));

                                                          Utils.snackBar(
                                                              'Copied to clipboard',
                                                              context);
                                                        },
                                                        icon: Icon(
                                                          Icons
                                                              .content_copy_outlined,
                                                          size: 30,
                                                          color: themeColor,
                                                        )),
                                                  ],
                                                );
                                              } else {
                                                return const Text('');
                                              }
                                            },
                                          ),

                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                              'Dont share this code publicly '),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "OK",
                                          style: TextStyle(
                                              color: themeColor, fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            'SEND INVITE',
                            style: TextStyle(fontSize: 20, color: themeColor),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(
                    width: 1,
                  ),
            const Divider(
              thickness: 1,
            ),

            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 15,
              ),
              child: SizedBox(
                child: InputDecorator(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Connected Fridge ',
                      labelStyle:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      FutureBuilder(
                        future: allfridgeapi(),
                        builder: (context,
                            AsyncSnapshot<List<Fridgeuser>> snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          } else {
                            return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: fulist.length,
                                itemBuilder: (BuildContext context, int index) {
                                  String role =
                                      snapshot.data![index].role.toString();
                                  int? fridgeid =
                                      snapshot.data![index].fridgeId!;
                                  int? id = snapshot.data![index].id!;
                                  int freezertype =
                                      snapshot.data![index].freezerType!;
                                  return Card(
                                    elevation: 12,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: fridgeid == fridgeidd
                                            ? themeColor
                                            : Colors.grey,
                                      ),
                                      child: ListTile(
                                        //  tileColor: Colors.white,
                                        leading: const Icon(
                                          Boxicons.bxs_fridge,
                                          size: 30.0,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          snapshot.data![index].fridgeName
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        subtitle: Text(
                                          role == 'null' ? '' : role,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                        onTap: () async {
                                          SharedPreferences sp =
                                              await SharedPreferences
                                                  .getInstance();
                                          sp.setInt('fridgeid', fridgeid);
                                          sp.setString('role', role);
                                          sp.setInt('freezertype', freezertype);
                                          setState(() {
                                            // update the state variables and make API calls if needed
                                            fridgeidd = fridgeid;
                                            rolee = role;
                                            freezertypee = freezertype;
                                            getdata();
                                            fridgeapi().then((value) {
                                              setState(() {
                                                flist = value;
                                              });
                                            });
                                            allfridgeapi().then((value) {
                                              setState(() {
                                                fulist = value;
                                              });
                                            });
                                          });
                                        },
                                        trailing: role != 'owner'
                                            ? IconButton(
                                                icon: const Icon(
                                                    Icons
                                                        .delete_outline_outlined,
                                                    size: 30,
                                                    color: Colors.white),
                                                onPressed: () async {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title:
                                                            const Text("Alert"),
                                                        content: const Text(
                                                            "Leave This Fridge."),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              Fridgeuser fu =
                                                                  Fridgeuser();
                                                              fu.id = id;
                                                              await fu
                                                                  .removeuserorleaveapi();
                                                              fulist.removeAt(
                                                                  index);
                                                              if (fridgeidd ==
                                                                  fridgeid) {
                                                                SharedPreferences
                                                                    sp =
                                                                    await SharedPreferences
                                                                        .getInstance();
                                                                sp.setInt(
                                                                    'fridgeid',
                                                                    0);
                                                              }
                                                              setState(() {
                                                                getdata();
                                                              });
                                                              Utils.snackBar(
                                                                  'Leaved',
                                                                  context);
                                                              setState(() {});
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                              "Remove",
                                                              style: TextStyle(
                                                                  color:
                                                                      themeColor),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                              "Cancel",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              )
                                            : role == 'owner' &&
                                                    hasOwner == true
                                                ? IconButton(
                                                    icon: const Icon(
                                                        Icons
                                                            .delete_outline_outlined,
                                                        size: 30,
                                                        color: Colors.white),
                                                    onPressed: () async {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                "Alert"),
                                                            content: const Text(
                                                                "Leave This Fridge. \n you cant undo this action"),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  Fridgeuser
                                                                      fu =
                                                                      Fridgeuser();
                                                                  fu.id = id;
                                                                  await fu
                                                                      .removeuserorleaveapi();
                                                                  fulist
                                                                      .removeAt(
                                                                          index);
                                                                  if (fridgeidd ==
                                                                      fridgeid) {
                                                                    SharedPreferences
                                                                        sp =
                                                                        await SharedPreferences
                                                                            .getInstance();
                                                                    sp.setInt(
                                                                        'fridgeid',
                                                                        0);
                                                                  }
                                                                  setState(() {
                                                                    getdata();
                                                                  });
                                                                  Utils.snackBar(
                                                                      'Leaved',
                                                                      context);
                                                                  setState(
                                                                      () {});
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                  "Remove",
                                                                  style: TextStyle(
                                                                      color:
                                                                          themeColor),
                                                                ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "Cancel",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                  )
                                                : role == 'owner' &&
                                                        hasOwner == false
                                                    ? IconButton(
                                                        icon: const Icon(
                                                            Icons
                                                                .delete_outline_outlined,
                                                            size: 30,
                                                            color:
                                                                Colors.white),
                                                        onPressed: () async {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title:
                                                                    const Text(
                                                                        "Alert"),
                                                                content: const Text(
                                                                    "You Can`t Leave this Fridge. \n Make someone owner before leaving"),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                      "Ok",
                                                                      style: TextStyle(
                                                                          color:
                                                                              themeColor),
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                      )
                                                    : null,
                                      ),
                                    ),
                                  );
                                });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: SizedBox(
                child: InputDecorator(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Connected Users',
                      labelStyle:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      FutureBuilder(
                        future: allconnectedusersapi(),
                        builder: (context, AsyncSnapshot<List<User>> snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          } else {
                            allconnectedusers = snapshot.data!;
                            return ReorderableListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: allconnectedusers.length,
                              itemBuilder: (BuildContext context, int index) {
                                User u = allconnectedusers[index];
                                int id = u.id!;
                                String userrole =
                                    snapshot.data![index].role ?? '';
                                if (userrole == 'owner') {
                                  hasOwner = true;
                                }
                                return Card(
                                  key: ValueKey(u),
                                  elevation: 12,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: themeColor,
                                    ),
                                    child: ListTile(
                                      leading: const Icon(
                                          Icons.person_outline_outlined,
                                          size: 30,
                                          color: Colors.white),
                                      title: Text(
                                        u.name.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      // SIMPLE
                                      // trailing: rolee == 'owner'
                                      //     ? IconButton(
                                      //         icon: const Icon(
                                      //             Icons.delete_outline_outlined,
                                      //             size: 30,
                                      //             color: Colors.white),
                                      //         onPressed: () async {
                                      //           showDialog(
                                      //               context: context,
                                      //             builder:
                                      //                 (BuildContext context) {
                                      //               return AlertDialog(
                                      //                 title:
                                      //                     const Text("Alert"),
                                      //                 content: const Text(
                                      //                     "Remove User."),
                                      //                 actions: <Widget>[
                                      //                   TextButton(
                                      //                     onPressed: () async {
                                      //                       User u = User();
                                      //                       u.id = id;
                                      //                       await u
                                      //                           .removeuserorleaveapi();
                                      //                       allconnectedusers
                                      //                           .removeAt(
                                      //                               index);
                                      //                       // Store updated list locally
                                      //                       await SharedPreferences
                                      //                               .getInstance()
                                      //                           .then((prefs) => prefs.setStringList(
                                      //                               'connected_users',
                                      //                               allconnectedusers
                                      //                                   .map((user) =>
                                      //                                       jsonEncode(user.toJson()))
                                      //                                   .toList()));
                                      //                       setState(() {});

                                      //                       Utils.snackBar(
                                      //                           'Removed',
                                      //                           context);
                                      //                       setState(() {});
                                      //                       Navigator.of(
                                      //                               context)
                                      //                           .pop();
                                      //                     },
                                      //                     child: Text(
                                      //                       "Remove",
                                      //                       style: TextStyle(
                                      //                           color:
                                      //                               themeColor),
                                      //                     ),
                                      //                   ),
                                      //                   TextButton(
                                      //                     onPressed: () {
                                      //                       Navigator.of(
                                      //                               context)
                                      //                           .pop();
                                      //                     },
                                      //                     child: const Text(
                                      //                       "Cancel",
                                      //                       style: TextStyle(
                                      //                           color:
                                      //                               Colors.red),
                                      //                     ),
                                      //                   )
                                      //                 ],
                                      //               );
                                      //             },
                                      //           );
                                      //         },
                                      //       )
                                      //     : null,
                                      // WITH OWNER
                                      trailing: rolee == 'owner'
                                          ? PopupMenuButton<_MenuValues>(
                                              icon: const Icon(
                                                Icons.more_vert,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                              itemBuilder: (context) => [
                                                    // MAKE ADMIN
                                                    if (userrole == '' ||
                                                        userrole == 'null')
                                                      const PopupMenuItem(
                                                          value: _MenuValues
                                                              .MakeAdmin,
                                                          child: Text(
                                                              'Make Admin')),

                                                    // REMOVE ADMIN
                                                    if (userrole == 'admin')
                                                      const PopupMenuItem(
                                                          value: _MenuValues
                                                              .RemoveAdmin,
                                                          child: Text(
                                                              'Remove Admin')),
                                                    // Make Owner
                                                    if (userrole == 'admin')
                                                      const PopupMenuItem(
                                                          value: _MenuValues
                                                              .MakeOwner,
                                                          child: Text(
                                                              'Make Owner')),

                                                    // REMOVE
                                                    if (userrole == '' ||
                                                        userrole == 'null')
                                                      const PopupMenuItem(
                                                          value: _MenuValues
                                                              .RemoveFromFridge,
                                                          child:
                                                              Text('Remove')),
                                                  ],
                                              onSelected: (value) async {
                                                switch (value) {
                                                  case _MenuValues.MakeOwner:
                                                    showDialog(
                                                      context: context,
                                                      builder: ((context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Confirmation'),
                                                          content: const Text(
                                                              'Are you sure you want to Make this user Owner? \n You can Undo this action.'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  'Cancel'),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                User u = User();
                                                                u.id = id;
                                                                await u
                                                                    .makeownerapi();
                                                                hasOwner = true;
                                                                setState(() {});
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  'Confirm'),
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                                    );
                                                    break;
                                                  case _MenuValues.MakeAdmin:
                                                    User u = User();
                                                    u.id = id;

                                                    await u.makeadminapi();
                                                    setState(() {});

                                                    break;
                                                  case _MenuValues.RemoveAdmin:
                                                    User u = User();
                                                    u.id = id;

                                                    await u.removeadminapi();
                                                    setState(() {});
                                                    break;
                                                  case _MenuValues
                                                      .RemoveFromFridge:
                                                    User u = User();
                                                    u.id = id;
                                                    await u
                                                        .removeuserorleaveapi();
                                                    allconnectedusers
                                                        .removeAt(index);
                                                    // Store updated list locally
                                                    await SharedPreferences
                                                            .getInstance()
                                                        .then((prefs) =>
                                                            prefs.setStringList(
                                                                'connected_users',
                                                                allconnectedusers
                                                                    .map((user) =>
                                                                        jsonEncode(
                                                                            user.toJson()))
                                                                    .toList()));
                                                    setState(() {});
                                                    break;
                                                }
                                              })
                                          : null,
                                    ),
                                  ),
                                );
                              },
                              onReorder: (oldIndex, newIndex) async {
                                SharedPreferences sp =
                                    await SharedPreferences.getInstance();
                                setState(() {
                                  if (newIndex > oldIndex) {
                                    newIndex -= 1;
                                  }
                                  final User u =
                                      allconnectedusers.removeAt(oldIndex);
                                  allconnectedusers.insert(newIndex, u);

                                  // Update the userOrder list with the updated user positions
                                  final List<String> userOrder =
                                      allconnectedusers
                                          .map((user) => user.id.toString())
                                          .toList();
                                  sp.setStringList(_userOrderKey, userOrder);

                                  // Store updated list locally
                                  sp.setStringList(
                                      'connected_users',
                                      allconnectedusers
                                          .map((user) =>
                                              jsonEncode(user.toJson()))
                                          .toList());
                                  final int fridgeId = fridgeidd!;
                                  _saveUserOrder(fridgeId);
                                });
                              },
                            );
                          }
                        },
                      ),
                      // FutureBuilder(
                      //   future: allconnectedusersapi(),
                      //   builder: (context, AsyncSnapshot<List<User>> snapshot) {
                      //     if (!snapshot.hasData) {
                      //       return const CircularProgressIndicator();
                      //     } else {
                      //       return ListView.builder(
                      //           shrinkWrap: true,
                      //           itemCount: allconnectedusers.length,
                      //           itemBuilder: (BuildContext context, int index) {
                      //             User u = allconnectedusers[index];
                      //             int id = snapshot.data![index].id!;
                      //             return ListTile(
                      //               leading: const Icon(
                      //                 Icons.person_outline_outlined,
                      //                 size: 30,
                      //               ),
                      //               title: Text(
                      //                 u.name.toString(),
                      //                 style: const TextStyle(
                      //                     fontWeight: FontWeight.bold,
                      //                     color: Colors.black),
                      //               ),
                      //               trailing: rolee == 'owner'
                      //                   ? IconButton(
                      //                       icon: const Icon(
                      //                         Icons.delete_outline_outlined,
                      //                         size: 30,
                      //                       ),
                      //                       onPressed: () async {
                      //                         User u = User();
                      //                         u.id = id;
                      //                         await u.removeuserorleaveapi();
                      //                         allconnectedusers.removeAt(index);
                      //                         setState(() {});
                      //                       },
                      //                     )
                      //                   : null,
                      //             );
                      //           });
                      //     }
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
