import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:fridgefood/View/Screens/Account/create_fridgenewuser.dart';
import 'package:fridgefood/View/Screens/Profile/join_fridgenewuser.dart';
import 'package:fridgefood/constants.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({super.key});

  @override
  State<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Let`s get set up',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateFridgeNewUser(),
                  ),
                );
              },
              child: SizedBox(
                height: 150,
                width: 400,
                child: Card(
                  elevation: 20.0,
                  margin: const EdgeInsets.all(25.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 15,
                            left: 10,
                          ),
                          child: Column(
                            children: const [
                              Icon(
                                Boxicons.bxs_fridge,
                                size: 60,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 25,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    'Create a new Fridge',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Most Common',
                                    style: TextStyle(
                                        fontSize: 15, color: themeColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JoinFridgeNewUser(),
                  ),
                );
              },
              child: SizedBox(
                height: 150,
                width: 400,
                child: Card(
                  elevation: 20.0,
                  margin: const EdgeInsets.all(25.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 15,
                            left: 10,
                          ),
                          child: Column(
                            children: const [
                              Icon(
                                Boxicons.bxs_fridge,
                                size: 60,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 25,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    'Join existing Fridge',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Use your invite code',
                                    style: TextStyle(
                                        fontSize: 15, color: themeColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
