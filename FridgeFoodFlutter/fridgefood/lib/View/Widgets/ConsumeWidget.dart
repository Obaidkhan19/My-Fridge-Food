import 'package:flutter/material.dart';

import 'package:fridgefood/View/Widgets/small_unit_dropdown.dart';
import 'package:fridgefood/View/Widgets/text_input_field.dart';
import 'package:fridgefood/constants.dart';

import 'MyButton.dart';

class ConsumeWidget extends StatefulWidget {
  const ConsumeWidget({super.key});

  @override
  State<ConsumeWidget> createState() => _ConsumeWidgetState();
}

class _ConsumeWidgetState extends State<ConsumeWidget> {
  final TextEditingController _consumeQuantityController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InputDecorator(
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Consume',
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
              text: 'Consume',
              backgroundColor: themeColor,
              buttonwidth: 150,
              onPress: () {},
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
