import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fridgefood/Models/fridgeuser.dart';
import 'package:fridgefood/View/Screens/Auth/connected_fridges.dart';
import 'package:fridgefood/View/Screens/Auth/new_user_fridge_screen.dart';
import 'package:fridgefood/View/Screens/Auth/signup.dart';
import 'package:fridgefood/View/Widgets/text_input_field.dart';
import 'package:fridgefood/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fridgefood/utils/utilities.dart';
import '../../../Models/user.dart';
import '../../../utils/utils.dart';
import '../../Widgets/MyButton.dart';
import '../Profile/SplashScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: const Image(
                          image: AssetImage("assets/greenlogo.png"),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: const Text(
                          'My Fridge Food',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: const Text(
                          'Plan • Shop • Cook',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    // TEXT INPUT FIELD
                    child: TextInputField(
                      controller: _emailController,
                      labelText: 'Email',
                      icon: Icons.email,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    // TEXT INPUT FIELD
                    child: PassTextField(
                      controller: _passwordController,
                      labelText: 'Password',
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              MyButton(
                  text: "SignIn",
                  backgroundColor: themeColor,
                  buttonwidth: 200,
                  textColor: whitecolor,
                  onPress: () async {
                    User u = User();
                    u.email = _emailController.text;
                    u.password = _passwordController.text;
                    String? response = await u.login();
                    if (response == "\"false\"") {
                      Utils.snackBar("Invalid Username or Email", context);
                    } else {
                      var data = jsonDecode(response.toString());
                      SharedPreferences sp =
                          await SharedPreferences.getInstance();
                      sp.setBool(SplashScreenState.KEYLOGIN, true);
                      var id = data["Id"];
                      //  var fridgeid = data["FridgeId"];
                      var name = data["Name"];
                      var email = data["Email"];
                      var password = data["Password"];
                      sp.setInt('userid', id);
                      //  sp.setInt('fridgeid', fridgeid);
                      sp.setString('username', name);
                      sp.setString('useremail', email);
                      sp.setString('userpassword', password);
                      List<Fridgeuser> fulist = [];
                      Future<List<Fridgeuser>> allfridgeapi() async {
                        final response = await http
                            .get(Uri.parse('$ip/user/UserAllFridges?uid=$id'));
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

                      await allfridgeapi();
                      if (fulist.isEmpty) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const NewUserScreen();
                            },
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const ConnectedFridges();
                            },
                          ),
                        );
                      }
                    }
                  }),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account? ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    )),
                    child: Text(
                      'Register ',
                      style: TextStyle(fontSize: 20, color: themeColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
