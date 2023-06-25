import 'package:flutter/material.dart';
import 'package:fridgefood/View/Screens/Auth/login_screen.dart';
import 'package:fridgefood/View/Widgets/text_input_field.dart';
import 'package:fridgefood/constants.dart';
import 'package:fridgefood/utils/utils.dart';

import '../../../Models/user.dart';
import '../../Widgets/MyButton.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  String? response;

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
                      controller: _userNameController,
                      labelText: 'Username',
                      icon: Icons.person,
                    ),
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
                text: "Register",
                backgroundColor: themeColor,
                buttonwidth: 200,
                textColor: whitecolor,
                onPress: () async {
                  User u = User();
                  u.name = _userNameController.text;
                  u.email = _emailController.text;
                  u.password = _passwordController.text;
                  response = await u.signupObject();
                  if (response == "\"Exist\"") {
                    Utils.snackBar("Email Exist", context);
                  } else {
                    Utils.snackBar("Account Created sucessfully", context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    )),
                    child: Text(
                      'LogIn ',
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
