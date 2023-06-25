import 'package:flutter/material.dart';
import 'package:flutter/Cupertino.dart';
import 'package:fridgefood/Models/all_items.dart';
import 'package:fridgefood/Models/stock.dart';
import 'package:fridgefood/View/Widgets/MyButton.dart';
import 'package:fridgefood/View/Widgets/text_input_field.dart';
import 'package:fridgefood/constants.dart';
import 'package:fridgefood/utils/utils.dart';

class EditStock extends StatefulWidget {
  AllItem detailobj;
  Stock sobj;
  EditStock(this.detailobj, this.sobj);

  @override
  State<EditStock> createState() => _EditStockState();
}

class _EditStockState extends State<EditStock> {
  @override
  late TextEditingController stockQuantityController;
  bool isOpen = false;
  bool isFreez = false;
  @override
  void initState() {
    super.initState();

    // QUANTITY
    double? quantity1 = widget.sobj.quantity;
    String quantityString = quantity1?.toStringAsFixed(1) ??
        "0.0"; // convert double to string and round to 1 decimal place
    String quantity = quantityString.endsWith(".0")
        ? quantityString.substring(0, quantityString.length - 2)
        : quantityString;
    double roundedQuantity = quantity1!;
    // remove 0 after point
    String roundedQuantityString = roundedQuantity.toString();
    if (roundedQuantityString.contains('.') &&
        roundedQuantityString.endsWith('0')) {
      roundedQuantityString =
          roundedQuantityString.replaceAll(RegExp(r'0*$'), '');
      if (roundedQuantityString.endsWith('.')) {
        roundedQuantityString = roundedQuantityString.substring(
            0, roundedQuantityString.length - 1);
      }
    }
    stockQuantityController =
        TextEditingController(text: roundedQuantityString);
// PURCHASE AND EXPIRY
    purchasedate = DateTime.tryParse(widget.sobj.purchaseDate!);
    expirydate = DateTime.tryParse(widget.sobj.expiryDate!);

    // IS FREEZ
    isFreez = widget.sobj.isFrozen!;

    // UNIT
    String unit = widget.sobj.quantityUnit.toString();
    if (unit == 'g' || unit == 'kg') {
      itemunit = 'kgorg';
    }
    if (unit == 'l' || unit == 'ml') {
      itemunit = 'lorml';
    }
    String selectedoption;

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
    selectedoptiong = selectedoption;
    selectedoptionml = selectedoption;
  }

  String? itemunit;
  String selectedoptiong = '';
  String selectedoptionml = '';
  List<String> kgunitList = [
    'KiloGram',
    'Gram',
  ];
  List<String> lunitList = [
    'Liter',
    'MiliLiter',
  ];
  DateTime? purchasedate = DateTime.now();
  DateTime? expirydate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: themeColor,
        title: const Text(
          'Edit Stock',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SizedBox(
                child: InputDecorator(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Edit Stock',
                      labelStyle:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
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
                            controller: stockQuantityController,
                            labelText: 'Enter Quantity',
                            icon: Icons.food_bank_outlined),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      if (itemunit == 'kgorg')
                        SingleChildScrollView(
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                    onTap: () {
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
                        ),
                      if (itemunit == 'lorml')
                        SingleChildScrollView(
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                    onTap: () {
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
                        ),

                      const SizedBox(
                        height: 15,
                      ),
                      // FREEZ
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Frozen',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Switch(
                            activeColor: themeColor,
                            value: isFreez,
                            onChanged: ((value) => setState(() {
                                  isFreez = value;
                                  // widget.onIsFreezChanged(isFreez);
                                })),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 5,
                      ),
                      // PURCHASE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Purchase  ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          CupertinoButton(
                            child: Text(
                              "${purchasedate!.day}-${purchasedate!.month}-${purchasedate!.year}",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: themeColor),
                            ),
                            onPressed: () {
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (BuildContext context) => SizedBox(
                                        height: 250,
                                        child: CupertinoDatePicker(
                                          backgroundColor: Colors.white,
                                          initialDateTime: purchasedate,
                                          onDateTimeChanged:
                                              (DateTime newTime) {
                                            setState(
                                                () => purchasedate = newTime);
                                          },
                                          mode: CupertinoDatePickerMode.date,
                                        ),
                                      ));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // EXPIRY
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Expiry  ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          CupertinoButton(
                            child: Text(
                              "${expirydate!.day}-${expirydate!.month}-${expirydate!.year}",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: themeColor),
                            ),
                            onPressed: () {
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (BuildContext context) => SizedBox(
                                        height: 250,
                                        child: CupertinoDatePicker(
                                          backgroundColor: Colors.white,
                                          initialDateTime: expirydate,
                                          onDateTimeChanged:
                                              (DateTime newTime) {
                                            setState(
                                                () => expirydate = newTime);
                                          },
                                          mode: CupertinoDatePickerMode.date,
                                        ),
                                      ));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NewButton(
                            text: 'Save',
                            backgroundColor: themeColor,
                            buttonwidth: 150,
                            onPress: () async {
                              Stock s = Stock();
                              s.id = widget.sobj.id;
                              s.quantity =
                                  double.tryParse(stockQuantityController.text);
                              // s.quantityUnit = itemunit;
                              if (itemunit == 'kgorg') {
                                s.quantityUnit =
                                    selectedoptiong == 'KiloGram' ? 'kg' : 'g';
                              } else if (itemunit == 'lorml') {
                                s.quantityUnit =
                                    selectedoptionml == 'Liter' ? 'l' : 'ml';
                              } else {
                                s.quantityUnit = itemunit;
                              }
                              s.isFrozen = isFreez;
                              s.purchaseDate = purchasedate.toString();
                              s.expiryDate = expirydate.toString();
                              String? res = await s.editStock();
                              if (res == "\"Updated\"") {
                                Utils.snackBar('Stock Updated', context);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              }
                            },
                            textColor: Colors.white,
                          ),
                          NewButton(
                            text: 'Cancel',
                            backgroundColor: Colors.red,
                            buttonwidth: 150,
                            onPress: () async {
                              Navigator.of(context).pop();
                            },
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                    ],
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
