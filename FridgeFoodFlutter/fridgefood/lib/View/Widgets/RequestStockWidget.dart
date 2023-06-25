import 'package:flutter/material.dart';
import 'package:fridgefood/View/Widgets/small_unit_dropdown.dart';
import 'package:fridgefood/View/Widgets/text_input_field.dart';
import 'package:fridgefood/constants.dart';

import 'MyButton.dart';

class RequestStockWidget extends StatefulWidget {
  const RequestStockWidget({super.key});

  @override
  State<RequestStockWidget> createState() => _RequestStockWidgetState();
}

class _RequestStockWidgetState extends State<RequestStockWidget> {
  final TextEditingController _consumeQuantityController =
      TextEditingController();
  List<String> names = ['Obaid', 'Talha', 'Sheharyar'];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InputDecorator(
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Request Stock',
            labelStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // TEXTFIELD AND DROPDOWN
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextInputField(
                  controller: _consumeQuantityController,
                  labelText: 'Enter Quantity',
                  icon: Icons.food_bank_outlined),
            ),
            const SizedBox(
              height: 5,
            ),
            const SmallUnitDropDown(),
            const SizedBox(
              height: 15,
            ),
            // MY BUTTON
            NewButton(
              text: 'Request',
              backgroundColor: themeColor,
              buttonwidth: 150,
              onPress: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Connected Users"),
                    content: ListView.builder(
                        shrinkWrap: true,
                        itemCount: names.length,
                        itemBuilder: (BuildContext context, int index) {
                          final name = names[index];
                          return ListTile(
                            leading: const Icon(
                              Icons.person_outline_outlined,
                              size: 30,
                            ),
                            title: Text(
                              name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            trailing: IconButton(
                              // ignore: prefer_const_constructors
                              icon: Icon(
                                Icons.send_outlined,
                                size: 30,
                              ),
                              onPressed: () {},
                            ),
                          );
                        }),
                    actions: <Widget>[
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
