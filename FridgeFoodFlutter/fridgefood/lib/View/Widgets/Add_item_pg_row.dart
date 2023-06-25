import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fridgefood/Models/all_items.dart';
import 'package:fridgefood/constants.dart';

import '../../Models/fridgeitem.dart';

class EditItemExpiryRow extends StatefulWidget {
  FridgeItem detailobj;
  final TextEditingController namecontroller;
  String text;
  final Function(String) onDaySelected;
  EditItemExpiryRow({
    super.key,
    required this.namecontroller,
    required this.text,
    required this.onDaySelected,
    required this.detailobj,
  });

  @override
  State<EditItemExpiryRow> createState() => _EditItemExpiryRowState();
}

class _EditItemExpiryRowState extends State<EditItemExpiryRow> {
  bool isOpen = false;

  late String selectedoption;

  List<String> unitList = [
    'Day',
    'Month',
    'Year',
  ];
  @override
  void initState() {
    selectedoption = 'Day';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int days = widget.detailobj.expiryReminder ?? 0;
    if (days != 0) {
      widget.namecontroller.text = days.toString();
    } else {
      widget.namecontroller.text = '';
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 5,
        left: 10,
        right: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 60,
            child: TextField(
              cursorColor: Colors.black,
              controller: widget.namecontroller,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
              decoration: InputDecoration(
                hintText: '',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: themeColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 140,
            //  child: DurationDropdown(),
            child: SingleChildScrollView(
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
                                          widget.onDaySelected(e);
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
            ),
          ),
        ],
      ),
    );
  }
}

class AddStockRow extends StatefulWidget {
  AllItem detailobj;
  final TextEditingController namecontroller;
  String text;
  final Function(String) onDaySelected;
  AddStockRow({
    super.key,
    required this.namecontroller,
    required this.text,
    required this.onDaySelected,
    required this.detailobj,
  });

  @override
  State<AddStockRow> createState() => _AddStockRowState();
}

class _AddStockRowState extends State<AddStockRow> {
  bool isOpen = false;

  String selectedoption = 'Day';

  List<String> unitList = [
    'Day',
    'Month',
    'Year',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 5,
        left: 10,
        right: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 60,
            child: TextField(
              cursorColor: Colors.black,
              controller: widget.namecontroller,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
              decoration: InputDecoration(
                hintText: '',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: themeColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 90,
            //  child: DurationDropdown(),
            child: SingleChildScrollView(
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
                                          widget.onDaySelected(e);
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
            ),
          ),
        ],
      ),
    );
  }
}

class DailyUseRow extends StatefulWidget {
  final TextEditingController controller;
  FridgeItem detailobj;
  String unit;
  String text;
  final Function(String) onUnitSelected;
  DailyUseRow({
    super.key,
    required this.text,
    required this.controller,
    required this.onUnitSelected,
    required this.detailobj,
    required this.unit,
  });

  @override
  State<DailyUseRow> createState() => _DAilyUaeStateRow();
}

class _DAilyUaeStateRow extends State<DailyUseRow> {
  bool isOpen = false;

  late String selectedoption;

  @override
  void initState() {
    super.initState();
    String unit = widget.detailobj.dailyConsumptionUnit ?? '';
    if (unit == 'g') {
      selectedoption = 'Gram';
    } else if (unit == 'kg') {
      selectedoption = 'KiloGram';
    } else if (unit == 'l') {
      selectedoption = 'Liter';
    } else if (unit == 'ml') {
      selectedoption = 'MiliLiter';
    } else {
      selectedoption = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    //   String unit = widget.detailobj.dailyConsumptionUnit ?? '';
    double? quantity1 = widget.detailobj.dailyConsumption ?? 0;
    String quantityString = quantity1.toStringAsFixed(1);
    String quantity = quantityString.endsWith(".0")
        ? quantityString.substring(0, quantityString.length - 2)
        : quantityString;
    String? selectedItemUnit = widget.unit;
    if (quantity1 != 0) {
      widget.controller.text = quantity;
    } else {
      widget.controller.text = '';
    }

    List<String> kgunitList = [
      'KiloGram',
      'Gram',
    ];
    List<String> lunitList = [
      'Liter',
      'MiliLiter',
    ];
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 5,
        left: 5,
        right: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 60,
            child: TextField(
              cursorColor: Colors.black,
              controller: widget.controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                hintText: '',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: themeColor,
                  ),
                ),
              ),
            ),
          ),
          if (selectedItemUnit == 'kgorg')
            SizedBox(
              width: 140,
              child: SingleChildScrollView(
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
                            children: kgunitList
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
                                            setState(() {
                                              widget.onUnitSelected(e);
                                              selectedoption = e;
                                              isOpen = false;
                                            });
                                          },
                                          child: Text(e),
                                        ),
                                      ),
                                    ))
                                .toList()),
                    ],
                  ),
                ),
              ),
            ),
          if (selectedItemUnit == 'lorml')
            SizedBox(
              width: 140,
              child: SingleChildScrollView(
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
                            children: lunitList
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
                                            setState(() {
                                              widget.onUnitSelected(e);
                                              selectedoption = e;
                                              isOpen = false;
                                            });
                                          },
                                          child: Text(e),
                                        ),
                                      ),
                                    ))
                                .toList()),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class LowStockRow extends StatefulWidget {
  final TextEditingController controller;
  FridgeItem detailobj;
  String text;
  String unit;
  final Function(String) onUnitSelected;
  LowStockRow({
    super.key,
    required this.text,
    required this.unit,
    required this.controller,
    required this.onUnitSelected,
    required this.detailobj,
  });

  @override
  State<LowStockRow> createState() => _LowStockRowState();
}

class _LowStockRowState extends State<LowStockRow> {
  bool isOpen = false;

  late String selectedoption;

  @override
  void initState() {
    super.initState();
    String unit = widget.detailobj.lowStockReminderUnit ?? '';
    if (unit == 'g') {
      selectedoption = 'Gram';
    } else if (unit == 'kg') {
      selectedoption = 'KiloGram';
    } else if (unit == 'l') {
      selectedoption = 'Liter';
    } else if (unit == 'ml') {
      selectedoption = 'MiliLiter';
    } else {
      selectedoption = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // String unit = widget.detailobj.lowStockReminderUnit ?? '';
    double? quantity1 = widget.detailobj.lowStockReminder ?? 0;
    String quantityString = quantity1.toStringAsFixed(1);
    String quantity = quantityString.endsWith(".0")
        ? quantityString.substring(0, quantityString.length - 2)
        : quantityString;

    String? selectedItemUnit = widget.unit;
    if (quantity1 != 0) {
      widget.controller.text = quantity;
    } else {
      widget.controller.text = '';
    }

    List<String> kgunitList = [
      'KiloGram',
      'Gram',
    ];
    List<String> lunitList = [
      'Liter',
      'MiliLiter',
    ];

    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 5,
        left: 5,
        right: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 60,
            child: TextField(
              cursorColor: Colors.black,
              controller: widget.controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                hintText: '',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: themeColor,
                  ),
                ),
              ),
            ),
          ),
          if (selectedItemUnit == 'kgorg')
            SizedBox(
              width: 140,
              child: SingleChildScrollView(
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
                            children: kgunitList
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
                                            setState(() {
                                              widget.onUnitSelected(e);
                                              selectedoption = e;
                                              isOpen = false;
                                            });
                                          },
                                          child: Text(e),
                                        ),
                                      ),
                                    ))
                                .toList()),
                    ],
                  ),
                ),
              ),
            ),
          if (selectedItemUnit == 'lorml')
            SizedBox(
              width: 140,
              child: SingleChildScrollView(
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
                            children: lunitList
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
                                            setState(() {
                                              widget.onUnitSelected(e);
                                              selectedoption = e;
                                              isOpen = false;
                                            });
                                          },
                                          child: Text(e),
                                        ),
                                      ),
                                    ))
                                .toList()),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
