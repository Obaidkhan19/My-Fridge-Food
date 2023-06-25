import 'dart:convert';

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:fridgefood/Models/fridge.dart';
import 'package:fridgefood/View/Screens/Auth/home.dart';

import 'package:fridgefood/View/Widgets/MyButton.dart';
import 'package:fridgefood/View/Widgets/text_input_field.dart';
import 'package:fridgefood/constants.dart';
import 'package:fridgefood/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/add_Row.dart';

class JoinFridgeNewUser extends StatefulWidget {
  const JoinFridgeNewUser({super.key});

  @override
  State<JoinFridgeNewUser> createState() => _JoinFridgeNewUserState();
}

class _JoinFridgeNewUserState extends State<JoinFridgeNewUser> {
  @override
  void initState() {
    super.initState();
    getdata();
  }

  void getdata() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userid = sp.getInt('userid');
    setState(() {});
  }

  int? userid;
  TextEditingController codecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AddFirstRow(
              text: '',
              onPress: () => Navigator.of(context).pop(),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Join a Fridge',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Text(
                'Enter the invite code that someone send you to join their Fridge',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(right: 230),
              child: Text(
                'INVITE CODE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: TextInputField(
                controller: codecontroller,
                labelText: 'Enter code',
                icon: Boxicons.bxs_fridge,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            MyButton(
              text: "Submit",
              backgroundColor: themeColor,
              buttonwidth: 300,
              textColor: Colors.white,
              onPress: () async {
                Fridge f = Fridge();
                f.id = userid;
                f.connectionId = codecontroller.text;
                String? response = await f.joinNewFridge();
                if (response == "\"wrongid\"") {
                  //wrong connection id
                  Utils.snackBar('Wrong Connection Id', context);
                } else {
                  var data = jsonDecode(response.toString());
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  int fridgeid = int.parse(data["FridgeId"].toString());
                  String role = data["Role"] ?? 'NULL';
                  sp.setInt('fridgeid', fridgeid);
                  sp.setString('role', role);
                  Utils.snackBar('Connected', context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const HomeScreen();
                      },
                    ),
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
