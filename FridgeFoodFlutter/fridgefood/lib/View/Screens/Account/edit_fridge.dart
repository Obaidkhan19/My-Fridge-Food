import 'dart:convert';

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Models/fridge.dart';
import '../../../utils/utilities.dart';
import '../../../constants.dart';
import 'package:fridgefood/View/Widgets/MyButton.dart';
import 'package:fridgefood/View/Widgets/text_input_field.dart';

class EditFridge extends StatefulWidget {
  @override
  State<EditFridge> createState() => _EditFridgeState();
}

class _EditFridgeState extends State<EditFridge> {
  // GETTING DATA USING API

  // @override
  // void initState() {
  //   super.initState();
  //   fridgeapi().then((list) {
  //     setState(() {
  //       flist = list;
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    fridgeapi().then((list) {
      setState(() {
        Fridge fridge = list.first;
        nameController.text = fridge.name.toString();
        dailyconsumption = fridge.allDailyConsumption!;
        int freezert = fridge.freezerType!;
        if (freezert == 1) {
          freezerTypeselectedoption = '1 Star';
        } else if (freezert == 2) {
          freezerTypeselectedoption = '2 Star';
        } else if (freezert == 3) {
          freezerTypeselectedoption = '3 Star';
        } else if (freezert == 4) {
          freezerTypeselectedoption = '4 Star';
        }
      });
    });
  }

  // void _onSwitchChanged(bool value) {
  //   setState(() {
  //     Fridge fridge = flist.first;
  //     fridge.allDailyConsumption = value;
  //   });
  // }

  void _onSwitchChanged(bool value) {
    setState(() {
      dailyconsumption = value;
    });
  }

  List<String> freezerTypeList = [
    '1 Star',
    '2 Star',
    '3 Star',
    '4 Star',
  ];

  String freezerTypeselectedoption = '1 Star';

  String id = 'fridgeid';
  Future<int?> getIdFromSharedPreferences() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(id);
  }

  TextEditingController nameController = TextEditingController();
  int? fridgeid;
  bool dailyconsumption = false;
  List<Fridge> flist = [];
  Future<List<Fridge>> fridgeapi() async {
    fridgeid = await getIdFromSharedPreferences();
    final response =
        await http.get(Uri.parse('$ip/fridge/FridgeDetail?fid=$fridgeid'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      flist.clear();
      // sucess
      for (Map i in data) {
        flist.add(Fridge.fromJson(i));
      }
      return flist;
    } else {
      return flist;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (flist.isEmpty) {
      return const CircularProgressIndicator();
    } else {
      // Fridge fridge = flist.first;
      // String name = fridge.name.toString();
      // nameController.text = name;
      // bool dailyconsumption = fridge.allDailyConsumption!;

      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            backgroundColor: themeColor,
            title: const Text(
              'Edit Fridge',
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
                Boxicons.bxs_fridge,
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
                  controller: nameController,
                  labelText: "",
                  icon: Boxicons.bxs_fridge,
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
                      'Daily Consumption',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: themeColor,
                      ),
                    ),
                    Switch(
                      activeColor: themeColor,
                      value: dailyconsumption,
                      onChanged: _onSwitchChanged,
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
                text: 'Done',
                backgroundColor: themeColor,
                buttonwidth: 200,
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
                  f.id = fridgeid;
                  f.name = nameController.text;
                  f.allDailyConsumption = dailyconsumption;
                  f.freezerType = freezerstar;

                  String? response = await f.editFridge();
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  sp.setInt('freezertype', freezerstar);
                  Navigator.of(context).pop();
                },
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      );
    }
  }
}
