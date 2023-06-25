import 'dart:convert';
import 'dart:io';

import 'package:fridgefood/Models/customfridgeitems.dart';
import 'package:fridgefood/Models/fridgeitem.dart';
import 'package:fridgefood/utils/utilities.dart';
import 'package:fridgefood/View/Widgets/MyButton.dart';
import 'package:fridgefood/constants.dart';
import 'package:flutter/material.dart';
import 'package:fridgefood/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Models/all_items.dart';

class EditDetail extends StatefulWidget {
  AllItem detailobj;
  EditDetail({required this.detailobj, super.key});

  @override
  State<EditDetail> createState() => _EditDetailState();
}

class _EditDetailState extends State<EditDetail> {
  late TextEditingController nameController;
  @override
  void initState() {
    nameController =
        TextEditingController(text: widget.detailobj.name.toString());
    itemunit = widget.detailobj.itemUnit!;
    fridgeitemapi();
    _loadData();
    getdata();
    super.initState();
  }

  Future<void> _loadData() async {
    await fridgeitemapi();
    _extractDataFromDetailObj(_detailobj);
  }

  void getdata() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    fridgeid = sp.getInt('fridgeid');
    setState(() {});
  }

  int? fridgeid;
  String? itemunit;
  bool _isLoading = true;
  List<FridgeItem> filist = [];
  FridgeItem _detailobj = FridgeItem();
  Future<void> fridgeitemapi() async {
    int fiid = widget.detailobj.fridgeItemId!;
    final response =
        await http.get(Uri.parse('$ip/FridgeItem/GetFridgeItem?fiid=$fiid'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      filist.add(FridgeItem.fromJson(data));
      _detailobj = filist.first;
    }
    setState(() {
      _isLoading = false;
    });
  }

  TextEditingController expiryController = TextEditingController();
  TextEditingController lowstockController = TextEditingController();
  TextEditingController dailyuseController = TextEditingController();
  TextEditingController fridgedayController = TextEditingController();
  String expirydayselectedoption = "Day";
  String lowstockselectedoptionkg = 'KiloGram';
  String dailyuseselectedoptionkg = 'KiloGram';
  String lowstockselectedoptionl = 'Liter';
  String dailyuseselectedoptionl = 'Liter';
  String fridgedayselectedoption = "Day";
  List<String> dayList = [
    'Day',
    'Month',
    'Year',
  ];

  List<String> kgunitList = [
    'KiloGram',
    'Gram',
  ];
  List<String> lunitList = [
    'Liter',
    'MiliLiter',
  ];

  String categoryselectedoption = "Meat";

  List<String> categoryList = [
    'Meat',
    'Bakery',
    'Eggs',
    'Dairy',
    'Fruit',
    'Seafood',
    'Cooked',
    'Other',
    'Vegetable',
  ];

  String unitselectedoption = "Kg or g";
  List<String> unitList = [
    "Kg or g",
    "L or ml",
    "No Unit",
  ];
  void _extractDataFromDetailObj(FridgeItem detailobj) {
    // image
    image = File(widget.detailobj.image!);
    // item category
    String icategory = detailobj.category ?? "";
    categoryselectedoption = icategory;

    // LOW STOCK REMINDER
    double? ls = detailobj.lowStockReminder ?? 0;
    String quantityStringls = ls.toStringAsFixed(1);
    String quantityls = quantityStringls.endsWith(".0")
        ? quantityStringls.substring(0, quantityStringls.length - 2)
        : quantityStringls;

    // DAILY USE
    double? quantity1du = detailobj.dailyConsumption ?? 0;
    String quantityStringdu = quantity1du.toStringAsFixed(1);
    String quantitydu = quantityStringdu.endsWith(".0")
        ? quantityStringdu.substring(0, quantityStringdu.length - 2)
        : quantityStringdu;

    // EXPIRY
    int expirydays = detailobj.expiryReminder ?? 0;
    lowstockController.text = quantityls.toString();
    dailyuseController.text = quantitydu.toString();
    expiryController.text = expirydays.toString();
    int fridgedays = detailobj.fridgeTime ?? 0;
    fridgedayController.text = fridgedays.toString();
    // if (fridgedays > 365) {
    //   fridgedayselectedoption = 'Year';
    // } else if (fridgedays > 30) {
    //   fridgedayselectedoption = 'Month';
    // } else {
    //   fridgedayselectedoption = 'Day';
    // }

    //dailyuseselectedoption = "Gram";
    //DAILY USE Unit
    String duUnit = detailobj.dailyConsumptionUnit ?? "";
    if (duUnit == 'g') {
      dailyuseselectedoptionkg = 'Gram';
    } else if (duUnit == 'kg') {
      dailyuseselectedoptionkg = 'KiloGram';
    } else if (duUnit == 'l') {
      dailyuseselectedoptionl = 'Liter';
    } else if (duUnit == 'ml') {
      dailyuseselectedoptionl = 'MiliLiter';
    }

    // LOW STOCK Unit
    String lsUnit = detailobj.lowStockReminderUnit ?? "";
    if (lsUnit == 'g') {
      lowstockselectedoptionkg = 'Gram';
    } else if (lsUnit == 'kg') {
      lowstockselectedoptionkg = 'KiloGram';
    } else if (lsUnit == 'l') {
      lowstockselectedoptionl = 'Liter';
    } else if (lsUnit == 'ml') {
      lowstockselectedoptionl = 'MiliLiter';
    }

    String iunit = detailobj.itemUnit ?? "";
    if (iunit == "nounit") {
      unitselectedoption = "No Unit";
    } else if (iunit == "kgorg") {
      unitselectedoption = "Kg or g";
    } else if (iunit == "lorml") {
      unitselectedoption = "L or ml";
    } else {
      unitselectedoption = "No Unit";
    }
  }

  File? image;
  bool hasChangedImage = false;
  pickImage(ImageSource imageType) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: imageType, maxWidth: 480, maxHeight: 600);
      if (image == null) return;
      final tempImage = File(image.path);
      setState(() {
        setState(() => this.image = tempImage);
        hasChangedImage = true;
      });
      Navigator.of(context).pop();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  void imagePickerOption() {
    showModalBottomSheet(
        elevation: 10,
        backgroundColor: themeColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              child: Container(
                color: Colors.white,
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Pic Image From",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton.icon(
                        onPressed: () => pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera),
                        label: const Text("CAMERA"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.image),
                        label: const Text("GALLERY"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close),
                        label: const Text("CANCEL"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    FridgeItem detailobj = filist.isNotEmpty ? filist.first : FridgeItem();

    // nameController.text = widget.detailobj.name!;
    int iid = widget.detailobj.fridgeItemId!;
    // int expiryreminder = widget.detailobj.expiryReminder ?? 0;
    // int fridgeday = widget.detailobj.userFridgeTime ?? 0;
    itemunit = unitselectedoption;
    return _isLoading
        ? const CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              backgroundColor: themeColor,
              title: const Text(
                'Edit Item',
                style: headingTextStyle,
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    itemimgpath + widget.detailobj.image!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            widget.detailobj.name.toString(),
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Align(
                    //   alignment: Alignment.center,
                    //   child: Stack(
                    //     children: [
                    //       Container(
                    //         decoration: BoxDecoration(
                    //           border:
                    //               Border.all(color: Colors.indigo, width: 5),
                    //           borderRadius: const BorderRadius.all(
                    //             Radius.circular(100),
                    //           ),
                    //         ),
                    //         child: ClipOval(
                    //           child: Container(
                    //             height: 150,
                    //             width: 150,
                    //             decoration: BoxDecoration(
                    //               image: DecorationImage(
                    //                 image: hasChangedImage
                    //                     ? FileImage(image!)
                    //                     : NetworkImage(itemimgpath +
                    //                             widget.detailobj.image!)
                    //                         as ImageProvider<Object>,
                    //                 fit: BoxFit.cover,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       Positioned(
                    //         bottom: 0,
                    //         right: 5,
                    //         child: IconButton(
                    //           onPressed: imagePickerOption,
                    //           icon: const Icon(
                    //             Icons.add_a_photo_outlined,
                    //             color: Colors.blue,
                    //             size: 30,
                    //           ),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(20.0),
                    //   child: TextInputField(
                    //     controller: nameController,
                    //     labelText: 'Name',
                    //     icon: Icons.dining_outlined,
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 5,
                    // ),

                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //     left: 10,
                    //     right: 130,
                    //   ),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       const Text(
                    //         'Category',
                    //         style: TextStyle(
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //       DropdownButton<String>(
                    //         value: categoryselectedoption,
                    //         items: categoryList.map((String option) {
                    //           return DropdownMenuItem<String>(
                    //             value: option,
                    //             child: Text(
                    //               option,
                    //               style: const TextStyle(
                    //                 fontSize: 16,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //           );
                    //         }).toList(),
                    //         onChanged: (String? value) {
                    //           setState(() {
                    //             categoryselectedoption =
                    //                 value ?? categoryselectedoption;
                    //           });
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // UNIT

                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 140,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Select Item Unit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          DropdownButton<String>(
                            value: unitselectedoption,
                            items: unitList.map((String option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(
                                  option,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                unitselectedoption =
                                    value ?? unitselectedoption;
                                itemunit = unitselectedoption;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    // // Fridge Time
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //     top: 5,
                    //     bottom: 5,
                    //     left: 10,
                    //     right: 10,
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       const Text(
                    //         'Fridge Time',
                    //         style: TextStyle(
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //       const SizedBox(width: 85),
                    //       SizedBox(
                    //         width: 60,
                    //         child: TextField(
                    //           cursorColor: Colors.black,
                    //           controller: fridgedayController,
                    //           keyboardType: TextInputType.number,
                    //           decoration: InputDecoration(
                    //             hintText: '',
                    //             enabledBorder: OutlineInputBorder(
                    //               borderRadius: BorderRadius.circular(5),
                    //               borderSide: const BorderSide(
                    //                 color: Colors.black,
                    //               ),
                    //             ),
                    //             focusedBorder: OutlineInputBorder(
                    //               borderRadius: BorderRadius.circular(5),
                    //               borderSide: BorderSide(
                    //                 color: themeColor,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       const SizedBox(width: 10),
                    //       DropdownButton<String>(
                    //         value: fridgedayselectedoption,
                    //         items: dayList.map((String option) {
                    //           return DropdownMenuItem<String>(
                    //             value: option,
                    //             child: Text(option),
                    //           );
                    //         }).toList(),
                    //         onChanged: (String? value) {
                    //           setState(() {
                    //             fridgedayselectedoption =
                    //                 value ?? fridgedayselectedoption;
                    //           });
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    const SizedBox(
                      height: 5,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5,
                            bottom: 5,
                            left: 10,
                            right: 10,
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'Daily Usage',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 85),
                              SizedBox(
                                width: 60,
                                child: TextField(
                                  cursorColor: Colors.black,
                                  controller: dailyuseController,
                                  keyboardType: TextInputType.number,
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
                              const SizedBox(width: 10),
                              if (itemunit == 'kgorg' || itemunit == 'Kg or g')
                                DropdownButton<String>(
                                  value: dailyuseselectedoptionkg,
                                  items: kgunitList.map((String option) {
                                    return DropdownMenuItem<String>(
                                      value: option,
                                      child: Text(option),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      dailyuseselectedoptionkg =
                                          value ?? dailyuseselectedoptionkg;
                                    });
                                  },
                                ),
                              if (itemunit == 'lorml' || itemunit == 'L or ml')
                                DropdownButton<String>(
                                  value: dailyuseselectedoptionl,
                                  items: lunitList.map((String option) {
                                    return DropdownMenuItem<String>(
                                      value: option,
                                      child: Text(option),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      dailyuseselectedoptionl =
                                          value ?? dailyuseselectedoptionl;
                                    });
                                  },
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(left: 100),
                                    child: Text(
                                      'Reminders',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5,
                                bottom: 5,
                                left: 10,
                                right: 10,
                              ),
                              child: Row(
                                children: [
                                  const Text(
                                    'Expiry',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 118),
                                  SizedBox(
                                    width: 60,
                                    child: TextField(
                                      cursorColor: Colors.black,
                                      controller: expiryController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: '',
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: themeColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  DropdownButton<String>(
                                    value: expirydayselectedoption,
                                    items: dayList.map((String option) {
                                      return DropdownMenuItem<String>(
                                        value: option,
                                        child: Text(option),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        expirydayselectedoption =
                                            value ?? expirydayselectedoption;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5,
                                bottom: 5,
                                left: 10,
                                right: 10,
                              ),
                              child: Row(
                                children: [
                                  const Text(
                                    'Low Stock',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 94),
                                  SizedBox(
                                    width: 60,
                                    child: TextField(
                                      cursorColor: Colors.black,
                                      controller: lowstockController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: '',
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                            color: themeColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  if (itemunit == 'kgorg' ||
                                      itemunit == 'Kg or g')
                                    DropdownButton<String>(
                                      value: lowstockselectedoptionkg,
                                      items: kgunitList.map((String option) {
                                        return DropdownMenuItem<String>(
                                          value: option,
                                          child: Text(option),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        setState(() {
                                          lowstockselectedoptionkg =
                                              value ?? lowstockselectedoptionkg;
                                        });
                                      },
                                    ),
                                  if (itemunit == 'lorml' ||
                                      itemunit == 'L or ml')
                                    DropdownButton<String>(
                                      value: lowstockselectedoptionl,
                                      items: lunitList.map((String option) {
                                        return DropdownMenuItem<String>(
                                          value: option,
                                          child: Text(option),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        setState(() {
                                          lowstockselectedoptionl =
                                              value ?? lowstockselectedoptionl;
                                        });
                                      },
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyButton(
                            text: 'Done',
                            backgroundColor: themeColor,
                            buttonwidth: 150,
                            onPress: () async {
                              int expiryDays = 0;
                              if (expirydayselectedoption == 'Day') {
                                expiryDays =
                                    int.parse(expiryController.text) * 1;
                              } else if (expirydayselectedoption == 'Month') {
                                expiryDays =
                                    int.parse(expiryController.text) * 30;
                              } else if (expirydayselectedoption == 'Year') {
                                expiryDays =
                                    int.parse(expiryController.text) * 365;
                              } else {
                                expiryDays = 0;
                              }
                              String? dailyuseunit;

                              if (unitselectedoption == "Kg or g") {
                                if (dailyuseselectedoptionkg == 'KiloGram') {
                                  dailyuseunit = 'kg';
                                } else if (dailyuseselectedoptionkg == 'Gram') {
                                  dailyuseunit = 'g';
                                } else if (dailyuseselectedoptionkg ==
                                    'Liter') {
                                  dailyuseunit = 'l';
                                } else if (dailyuseselectedoptionkg ==
                                    'MiliLiter') {
                                  dailyuseunit = 'ml';
                                }
                              } else if (unitselectedoption == "L or ml") {
                                if (dailyuseselectedoptionl == 'KiloGram') {
                                  dailyuseunit = 'kg';
                                } else if (dailyuseselectedoptionl == 'Gram') {
                                  dailyuseunit = 'g';
                                } else if (dailyuseselectedoptionl == 'Liter') {
                                  dailyuseunit = 'l';
                                } else if (dailyuseselectedoptionl ==
                                    'MiliLiter') {
                                  dailyuseunit = 'ml';
                                }
                              }
                              String? lowstockunit;

                              if (unitselectedoption == "L or ml") {
                                if (lowstockselectedoptionl == 'KiloGram') {
                                  lowstockunit = 'kg';
                                } else if (lowstockselectedoptionl == 'Gram') {
                                  lowstockunit = 'g';
                                } else if (lowstockselectedoptionl == 'Liter') {
                                  lowstockunit = 'l';
                                } else if (lowstockselectedoptionl ==
                                    'MiliLiter') {
                                  lowstockunit = 'ml';
                                }
                              } else if (unitselectedoption == "Kg or g") {
                                if (lowstockselectedoptionkg == 'KiloGram') {
                                  lowstockunit = 'kg';
                                } else if (lowstockselectedoptionkg == 'Gram') {
                                  lowstockunit = 'g';
                                } else if (lowstockselectedoptionkg ==
                                    'Liter') {
                                  lowstockunit = 'l';
                                } else if (lowstockselectedoptionkg ==
                                    'MiliLiter') {
                                  lowstockunit = 'ml';
                                }
                              }
                              String iitemunit;
                              if (unitselectedoption == "Kg or g") {
                                iitemunit = 'kgorg';
                              } else if (unitselectedoption == "L or ml") {
                                iitemunit = 'lorml';
                              } else {
                                iitemunit = 'nounit';
                              }

                              int fridgeDays = 0;
                              if (fridgedayselectedoption == 'Day') {
                                fridgeDays =
                                    int.parse(fridgedayController.text) * 1;
                              } else if (fridgedayselectedoption == 'Month') {
                                fridgeDays =
                                    int.parse(fridgedayController.text) * 30;
                              } else if (fridgedayselectedoption == 'Year') {
                                fridgeDays =
                                    int.parse(fridgedayController.text) * 365;
                              } else {
                                fridgeDays = 0;
                              }
                              if (nameController.text == '') {
                                Utils.snackBar('Enter Item Name', context);
                              } else if (nameController.text != '') {
                                CustomFridgeItem fi = CustomFridgeItem();
                                if (hasChangedImage) {
                                  image = File(image!.path);
                                }
                                String? response = await fi.editItem(
                                  image!,
                                  nameController.text,
                                  iitemunit,
                                  categoryselectedoption,
                                  fridgeDays,
                                  expiryDays,
                                  lowstockController.text,
                                  lowstockunit,
                                  dailyuseController.text,
                                  dailyuseunit,
                                  fridgeid!,
                                  iid,
                                );
                                if (response == "\"updatedSuccessfully\"") {
                                  Utils.snackBar(
                                      'Item Updated sucessfully', context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              }
                              // double? lowstock =
                              //     double.tryParse(lowstockController.text);
                              // double? dailyuse =
                              //     double.tryParse(dailyuseController.text);
                              // FridgeItem fi = FridgeItem();
                              // fi.itemId = widget.detailobj.fridgeItemId;
                              // fi.dailyConsumption = dailyuse;
                              // fi.dailyConsumptionUnit = dailyuseunit;
                              // fi.expiryReminder = expiryDays;
                              // fi.lowStockReminder = lowstock;
                              // fi.lowStockReminderUnit = lowstockunit;
                              // fi.itemUnit = iitemunit;
                              // String? res = await fi.editDetail();
                              // Navigator.of(context).pop();
                            },
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
