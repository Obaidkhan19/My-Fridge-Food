import 'package:flutter/material.dart';

import '../../constants.dart';

// video link  category dropdown
class UnitDropDown extends StatefulWidget {
  const UnitDropDown({super.key});

  @override
  State<UnitDropDown> createState() => _UnitDropDownState();
}

class _UnitDropDownState extends State<UnitDropDown> {
  bool isOpen = false;
  String selectedoption = 'Select Measuring Unit';
  List<String> unitList = [
    'KiloGram',
    'Gram',
    'Liter',
    'MiliLiter',
    'Single entity',
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                isOpen = !isOpen;
                setState(() {});
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(selectedoption),
                      Icon(isOpen
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ),
            ),
            if (isOpen)
              ListView(
                  primary: true,
                  shrinkWrap: true,
                  children: unitList
                      .map((e) => Container(
                            decoration: BoxDecoration(
                              color: selectedoption == e
                                  ? themeColor
                                  : Colors.grey.shade300,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  selectedoption = e;
                                  isOpen = false;
                                  setState(() {});
                                },
                                child: Text(e),
                              ),
                            ),
                          ))
                      .toList()),
          ],
        ),
      ),
    );
  }
}
