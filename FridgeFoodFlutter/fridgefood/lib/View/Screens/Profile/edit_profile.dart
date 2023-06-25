import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fridgefood/View/Widgets/MyButton.dart';
import 'package:fridgefood/View/Widgets/text_input_field.dart';
import 'package:fridgefood/constants.dart';
import 'package:fridgefood/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Models/user.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  @override
  void initState() {
    super.initState();
    getdata();
  }

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // bool _isedit = false;
  int? userid;
  String? namee;
  String? emaill;
  String? passwordd;
  void getdata() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userid = sp.getInt('userid');
    namee = sp.getString('username');
    emaill = sp.getString('useremail');
    passwordd = sp.getString('userpassword');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = namee.toString();
    emailController.text = emaill.toString();
    passwordController.text = passwordd.toString();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          backgroundColor: themeColor,
          title: const Text(
            'Edit Profile',
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
        body: Column(
          children: [
            const Icon(
              Icons.person,
              size: 100,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: TextInputField(
                // enable: _isedit,
                controller: nameController,
                labelText: '',
                icon: Icons.person_outlined,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: TextInputField(
                // enable: _isedit,
                controller: emailController,
                labelText: '',
                icon: Icons.email_outlined,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: PassTextField(
                // enable: _isedit,
                controller: passwordController,
                labelText: '',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            MyButton(
              text: 'Done',
              // _isedit ? 'Done' : 'Edit',
              backgroundColor: themeColor,
              // _isedit ? themeColor : Colors.red,
              buttonwidth: 200,
              onPress: () async {
                User u = User();
                u.id = userid;
                u.name = nameController.text;
                u.email = emailController.text;
                u.password = passwordController.text;
                String? response = await u.editUser();

                if (response != null) {
                  var data = jsonDecode(response.toString());
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  var name = data["Name"];
                  var email = data["Email"];
                  var password = data["Password"];
                  sp.setString('username', name);
                  sp.setString('useremail', email);
                  sp.setString('userpassword', password);

                  Utils.snackBar('Account Updated sucessfully', context);
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return const ProfileScreen();
                  //     },
                  //   ),
                  // );
                  Navigator.of(context).pop();
                }
              },
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
