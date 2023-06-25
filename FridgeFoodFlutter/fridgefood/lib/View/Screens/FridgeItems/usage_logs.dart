import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fridgefood/Functions/fromat_datetime.dart';
import 'package:fridgefood/Models/all_items.dart';
import 'package:fridgefood/Models/log.dart';
import 'package:fridgefood/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../utils/utilities.dart';

class UsageLogs extends StatefulWidget {
  AllItem detailobj;
  UsageLogs(this.detailobj);

  @override
  State<UsageLogs> createState() => _UsageLogsState();
}

class _UsageLogsState extends State<UsageLogs> {
  @override
  void initState() {
    super.initState();
    getdata();
  }

  void getdata() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    fridgeid = sp.getInt('fridgeid');
    userid = sp.getInt('userid');
    setState(() {});
  }

  int? fridgeid;
  int? userid;

  @override
  Widget build(BuildContext context) {
    int fridgeitemid = widget.detailobj.fridgeItemId!;
    List<Log> llist = [];
    Future<List<Log>> logapi() async {
      final response = await http.get(Uri.parse(
          '$ip/log/UserLogs?fid=$fridgeid&iid=$fridgeitemid&uid=$userid'));
      var data = jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        llist.clear();
        // sucess
        for (Map i in data) {
          llist.add(Log.fromJson(i));
        }
        return llist;
      } else {
        return llist;
      }
    }

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
        future: logapi(),
        builder: (context, AsyncSnapshot<List<Log>> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: llist.length,
                itemBuilder: (BuildContext context, int index) {
                  DateTime datetime =
                      DateTime.parse(snapshot.data![index].date!);
                  FromatedDateTime fdt = FromatedDateTime();
                  String date = fdt.formatDateTime(datetime);
                  String logdata = snapshot.data![index].logData!;
                  double qunatity = snapshot.data![index].quantity!;
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
                });
          }
        },
      ),
    );
  }
}
