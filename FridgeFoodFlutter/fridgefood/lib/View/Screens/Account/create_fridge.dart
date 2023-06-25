import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:fridgefood/Models/fridge.dart';
import 'package:fridgefood/View/Widgets/MyButton.dart';
import 'package:fridgefood/View/Widgets/add_Row.dart';
import 'package:fridgefood/View/Widgets/text_input_field.dart';
import 'package:fridgefood/constants.dart';
import 'package:fridgefood/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateFridge extends StatefulWidget {
  const CreateFridge({super.key});

  @override
  State<CreateFridge> createState() => _CreateFridgeState();
}

class _CreateFridgeState extends State<CreateFridge> {
  bool isConsume = false;
  TextEditingController fridgenamecontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
    getdata();
  }

  int? userid;
  void getdata() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userid = sp.getInt('userid');
  }

  List<String> freezerTypeList = [
    '1 Star',
    '2 Star',
    '3 Star',
    '4 Star',
  ];

  String freezerTypeselectedoption = '1 Star';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
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
              'Create a Fridge',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(right: 230),
              child: Text(
                'FRIDGE NAME',
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
                controller: fridgenamecontroller,
                labelText: 'Enter Name',
                icon: Boxicons.bxs_fridge,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daily Consumption',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: themeColor,
                    ),
                  ),
                  Switch(
                    activeColor: themeColor,
                    value: isConsume,
                    onChanged: ((value) => setState(() {
                          isConsume = value;
                        })),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Freezer Rating',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: themeColor,
                    ),
                  ),
                  DropdownButton<String>(
                    value: freezerTypeselectedoption,
                    items: freezerTypeList.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: themeColor,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        freezerTypeselectedoption =
                            value ?? freezerTypeselectedoption;
                      });
                      //  print('Updated value: $freezerTypeselectedoption');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            MyButton(
                text: "Create",
                backgroundColor: themeColor,
                buttonwidth: 300,
                onPress: () async {
                  int freezerstar = 0;
                  if (freezerTypeselectedoption == '1 Star') {
                    freezerstar = 1;
                  } else if (freezerTypeselectedoption == '2 Star') {
                    freezerstar = 2;
                  } else if (freezerTypeselectedoption == '3 Star') {
                    freezerstar = 3;
                  } else if (freezerTypeselectedoption == '4 Star') {
                    freezerstar = 4;
                  }
                  Fridge f = Fridge();
                  f.userid = userid;
                  f.name = fridgenamecontroller.text;
                  f.allDailyConsumption = isConsume;
                  f.freezerType = freezerstar;
                  String? response = await f.createFridge();
                  if (response == "\"Created\"") {
                    Utils.snackBar('Created', context);
                  }
                },
                textColor: Colors.white),
          ],
        ),
      ),
    );
  }
}
