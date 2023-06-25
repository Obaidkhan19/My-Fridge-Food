import 'package:flutter/material.dart';

import '../../constants.dart';

class ItemUnitDropdown extends StatefulWidget {
  final Function(String) onUnitSelected;
  const ItemUnitDropdown({required this.onUnitSelected, super.key});

  @override
  State<ItemUnitDropdown> createState() => _ItemUnitDropdownState();
}

class _ItemUnitDropdownState extends State<ItemUnitDropdown> {
  bool isOpen = false;
  String selectedoption = 'Select Measuring Unit';
  List<String> unitList = [
    'KiloGram / Gram',
    'Liter / MiliLiter',
    'No Unit',
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
                                  widget.onUnitSelected(e);
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
