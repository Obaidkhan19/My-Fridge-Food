import 'package:flutter/material.dart';
import 'package:fridgefood/constants.dart';


class SmallUnitDropDown extends StatefulWidget {
  const SmallUnitDropDown({super.key});

  @override
  State<SmallUnitDropDown> createState() => _SmallUnitDropDownState();
}

class _SmallUnitDropDownState extends State<SmallUnitDropDown> {
  bool isOpen = false;
  String selectedoption = 'Gram';
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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                isOpen = !isOpen;
                setState(() {});
              },
              child: Container(
                height: 30,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
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
