import 'package:flutter/material.dart';

import '../../constants.dart';

class KgDropdown extends StatefulWidget {
  final Function(String) onUnitSelected;
  const KgDropdown({required this.onUnitSelected, super.key});

  @override
  State<KgDropdown> createState() => _KgDropdownState();
}

class _KgDropdownState extends State<KgDropdown> {
  bool isOpen = false;
  String selectedoptiong = 'Gram';
  List<String> kgunitList = [
    'KiloGram',
    'Gram',
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
                      Text(selectedoptiong),
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
                  children: kgunitList
                      .map((e) => Container(
                            decoration: BoxDecoration(
                              color: selectedoptiong == e
                                  ? themeColor
                                  : Colors.grey.shade300,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  widget.onUnitSelected(e);
                                  selectedoptiong = e;
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

class MlDropdown extends StatefulWidget {
  final Function(String) onUnitSelected;
  const MlDropdown({required this.onUnitSelected, super.key});

  @override
  State<MlDropdown> createState() => _MlDropdownState();
}

class _MlDropdownState extends State<MlDropdown> {
  bool isOpen = false;
  String selectedoptionml = 'MiliLiter';
  List<String> lunitList = [
    'Liter',
    'MiliLiter',
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
                      Text(selectedoptionml),
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
                  children: lunitList
                      .map((e) => Container(
                            decoration: BoxDecoration(
                              color: selectedoptionml == e
                                  ? themeColor
                                  : Colors.grey.shade300,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  widget.onUnitSelected(e);
                                  selectedoptionml = e;
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
