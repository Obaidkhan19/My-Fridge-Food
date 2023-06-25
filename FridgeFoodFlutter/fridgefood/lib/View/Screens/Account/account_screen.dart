import 'package:flutter/material.dart';
import 'package:fridgefood/View/Screens/Account/bin_chart.dart';
import 'package:fridgefood/View/Screens/Account/consumption_chart.dart';
import 'package:fridgefood/View/Screens/Auth/login_screen.dart';
import 'package:fridgefood/View/Screens/Account/create_fridge.dart';
import 'package:fridgefood/View/Screens/Profile/edit_profile.dart';
import 'package:fridgefood/View/Screens/Profile/join_fridge.dart';
import 'package:fridgefood/View/Widgets/add_Row.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import '../Profile/SplashScreen.dart';
import 'edit_fridge.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    getdata();
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
  int? userid;
  String? rolee;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AddFirstRow(
                text: 'Account',
                onPress: () => Navigator.of(context).pop(),
              ),
              const Divider(
                thickness: 2,
                color: Colors.black,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TextButton(
                    //   onPressed: (() async {
                    //     Navigator.pushReplacement(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) {
                    //           return const ThemeScreen();
                    //         },
                    //       ),
                    //     );
                    //   }),
                    //   child: Text(
                    //     'Theme',
                    //     style: TextStyle(
                    //       fontSize: 20,
                    //       fontWeight: FontWeight.w700,
                    //       color: themeColor,
                    //     ),
                    //   ),
                    // ),
                    // const Divider(
                    //   thickness: 1,
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfile(),
                          ),
                        );
                      },
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: themeColor,
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    rolee == 'owner'
                        ? TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditFridge()),
                              );
                            },
                            child: Text(
                              'Edit Fridge',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: themeColor,
                              ),
                            ),
                          )
                        : const SizedBox(
                            width: 1,
                          ),
                    rolee == 'owner'
                        ? const Divider(
                            thickness: 1,
                          )
                        : const SizedBox(
                            width: 1,
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: (() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const JoinFridge(),
                          ),
                        );
                      }),
                      child: Text(
                        'Join Fridge',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: themeColor,
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: (() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateFridge(),
                          ),
                        );
                      }),
                      child: Text(
                        'Create Fridge',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: themeColor,
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (rolee == 'owner' || rolee == 'admin')
                      TextButton(
                        onPressed: (() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ConsumptionDashboard(),
                            ),
                          );
                        }),
                        child: Text(
                          'Consumption Logs',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: themeColor,
                          ),
                        ),
                      ),
                    const Divider(
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (rolee == 'owner' || rolee == 'admin')
                      TextButton(
                        onPressed: (() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BinDashboard(),
                            ),
                          );
                        }),
                        child: Text(
                          'Bin Logs',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: themeColor,
                          ),
                        ),
                      ),

                    const Divider(
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: (() async {
                        SharedPreferences sp =
                            await SharedPreferences.getInstance();
                        sp.setBool(SplashScreenState.KEYLOGIN, false);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const LoginScreen();
                            },
                          ),
                        );
                      }),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // TextButton(
                    //   child: const Text(
                    //     'Delete Account',
                    //     style: TextStyle(
                    //       fontSize: 20,
                    //       fontWeight: FontWeight.w700,
                    //       color: Colors.red,
                    //     ),
                    //   ),
                    //   onPressed: () {
                    //     showDialog(
                    //         barrierDismissible: false,
                    //         context: context,
                    //         builder: (context) {
                    //           return AlertDialog(
                    //             title: const Text('Delete your account?'),
                    //             content: const Text(
                    //                 'This will delete your account FOREVER.\nAre you sure you want to proceed?'),
                    //             actions: [
                    //               TextButton(
                    //                 onPressed: () {
                    //                   Navigator.pop(context);
                    //                 },
                    //                 child: const Text(
                    //                   "YES, DELETE IT.",
                    //                   style: TextStyle(
                    //                       color: themeColor, fontSize: 20),
                    //                 ),
                    //               ),
                    //               TextButton(
                    //                 onPressed: () {
                    //                   Navigator.pop(context);
                    //                 },
                    //                 child: const Text(
                    //                   "Cancel",
                    //                   style: TextStyle(
                    //                       color: themeColor, fontSize: 20),
                    //                 ),
                    //               ),
                    //             ],
                    //           );
                    //         });
                    //   },
                    // ),
                    // const Divider(
                    //   thickness: 1,
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
