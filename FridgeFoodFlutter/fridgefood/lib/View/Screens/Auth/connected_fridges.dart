import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fridgefood/Models/fridgeuser.dart';
import 'package:fridgefood/View/Screens/Auth/home.dart';
import 'package:fridgefood/constants.dart';
import 'package:http/http.dart' as http;
import 'package:fridgefood/utils/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectedFridges extends StatefulWidget {
  const ConnectedFridges({super.key});

  @override
  State<ConnectedFridges> createState() => _ConnectedFridgesState();
}

class _ConnectedFridgesState extends State<ConnectedFridges> {
  @override
  void initState() {
    super.initState();
    getdata();
  }

  void getdata() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userid = sp.getInt('userid');
    name = sp.getString('username');
    setState(() {});
  }

  int? userid;

  String? name;
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: size.height * .3,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      alignment: Alignment.topCenter,
                      image: AssetImage('assets/top_header.png'),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Column(
                      children: [
                        Container(
                          height: 130,
                          margin: const EdgeInsets.only(
                            bottom: 100,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  '      My Fridge Food\nWelcome, $name!',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Card(
              elevation: 12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/fridge.png',
                    height: 220,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: allfridgeapi(),
              builder: (context, AsyncSnapshot<List<Fridgeuser>> snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: fulist.length,
                      itemBuilder: (BuildContext context, int index) {
                        String role = snapshot.data![index].role.toString();
                        int? fridgeid = snapshot.data![index].fridgeId!;
                        int freezertype = snapshot.data![index].freezerType!;
                        return Card(
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
                                Boxicons.bxs_fridge,
                                size: 30.0,
                                color: Colors.white,
                              ),
                              title: Text(
                                snapshot.data![index].fridgeName.toString(),
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              subtitle: Text(
                                role == 'null' ? '' : role,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              onTap: () async {
                                SharedPreferences sp =
                                    await SharedPreferences.getInstance();
                                sp.setInt('fridgeid', fridgeid);
                                sp.setString('role', role);
                                sp.setInt('freezertype', freezertype);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const HomeScreen();
                                    },
                                  ),
                                );
                              },
                              // trailing: IconButton(
                              //   icon: const Icon(Icons.delete_outline_outlined,
                              //       size: 30, color: Colors.white),
                              //   onPressed: () {},
                              // ),
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
    );
  }
}
