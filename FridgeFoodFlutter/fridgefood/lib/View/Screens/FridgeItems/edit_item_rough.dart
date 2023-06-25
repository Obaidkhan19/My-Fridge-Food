// import 'dart:convert';

// import 'package:fridgefood/Models/fridgeitem.dart';
// import 'package:fridgefood/Models/utilities.dart';
// import 'package:fridgefood/View/Widgets/MyButton.dart';
// import 'package:fridgefood/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import '../../Models/all_items.dart';
// import '../Widgets/Add_item_pg_row.dart';

// class EditItem extends StatefulWidget {
//   AllItem detailobj;
//   EditItem({required this.detailobj, super.key});

//   @override
//   State<EditItem> createState() => _EditItemState();
// }

// class _EditItemState extends State<EditItem> {
//   // String selectedDayFreezing = 'null';

//   // void updateSelectedDayFreezing(String day) {
//   //   setState(() {
//   //     selectedDayFreezing = day;
//   //   });
//   // }

//   @override
//   void initState() {
//     super.initState();
//     getdata();
//   }

//   void getdata() async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     fridgeid = sp.getInt('fridgeid');
//     setState(() {});
//   }

//   int? fridgeid;
//   TextEditingController nameController = TextEditingController();
//   TextEditingController freezingController = TextEditingController();
//   TextEditingController expiryController = TextEditingController();
//   TextEditingController lowstockController = TextEditingController();
//   TextEditingController dailyuseController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     String dailyuseunit = widget.detailobj.dailyConsumptionUnit!;
//     String lowstockunit = widget.detailobj.lowStockReminderUnit!;
//     String selectedDayExpiry = 'Day';

//     void updateSelectedDayExpiry(String day) {
//       setState(() {
//         selectedDayExpiry = day;
//       });
//     }

//     String selectedDailyUse = "";

//     void updateSelectedDailyUse(String unit) {
//       setState(() {
//         selectedDailyUse = unit;
//       });
//     }

//     String selectedLowStock = "";

//     void updateSelectedLowStock(String unit) {
//       setState(() {
//         selectedLowStock = unit;
//       });
//     }

//     String itemunit = widget.detailobj.itemUnit!;
//     List<FridgeItem> filist = [];
//     Future<List<FridgeItem>> fridgeitemapi() async {
//       int fiid = widget.detailobj.fridgeItemId!;
//       final response =
//           await http.get(Uri.parse('$ip/FridgeItem/GetFridgeItem?fiid=$fiid'));
//       var data = jsonDecode(response.body.toString());
//       if (response.statusCode == 200) {
//         filist.add(FridgeItem.fromJson(data));
//         return filist;
//       } else {
//         return filist;
//       }
//     }

//     //  FridgeItem editdetailobj = filist.first;

//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         titleSpacing: 0,
//         automaticallyImplyLeading: false,
//         backgroundColor: themeColor,
//         title: const Text(
//           'Edit Item',
//           style: headingTextStyle,
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: const Icon(
//             Icons.arrow_back_ios,
//             size: 30,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const SizedBox(
//                 height: 5,
//               ),
//               Row(
//                 children: [
//                   Container(
//                     height: 150,
//                     width: 150,
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image:
//                             NetworkImage(itemimgpath + widget.detailobj.image!),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 20,
//                   ),
//                   Text(
//                     widget.detailobj.name.toString(),
//                     style: const TextStyle(
//                       fontSize: 25,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               FutureBuilder(
//                 future: fridgeitemapi(),
//                 builder: (context, AsyncSnapshot<List<FridgeItem>> snapshot) {
//                   if (!snapshot.hasData) {
//                     return const CircularProgressIndicator();
//                   } else {
//                     return Column(
//                       children: [
//                         ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: filist.length,
//                           itemBuilder: ((BuildContext context, int index) {
//                             FridgeItem detailobj = filist[index];
//                             return Column(
//                               children: [
//                                 DailyUseRow(
//                                   detailobj: detailobj,
//                                   unit: itemunit,
//                                   text: 'Daily Usage ',
//                                   controller: dailyuseController,
//                                   onUnitSelected: updateSelectedDailyUse,
//                                 ),
//                                 const SizedBox(
//                                   height: 15,
//                                 ),
//                                 Column(
//                                   mainAxisSize: MainAxisSize.max,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 10),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: const [
//                                           Text(
//                                             'Reminder',
//                                             style: TextStyle(
//                                                 fontSize: 30,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     EditItemExpiryRow(
//                                       detailobj: detailobj,
//                                       text: 'Expiry',
//                                       namecontroller: expiryController,
//                                       onDaySelected: updateSelectedDayExpiry,
//                                     ),
//                                     const SizedBox(
//                                       height: 15,
//                                     ),
//                                     LowStockRow(
//                                       unit: itemunit,
//                                       detailobj: detailobj,
//                                       text: 'Low Stock ',
//                                       controller: lowstockController,
//                                       onUnitSelected: updateSelectedLowStock,
//                                     ),
//                                     const SizedBox(
//                                       height: 15,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             );
//                           }),
//                         ),
//                       ],
//                     );
//                   }
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     MyButton(
//                       text: 'Save',
//                       backgroundColor: themeColor,
//                       buttonwidth: 150,
//                       onPress: () async {
//                         print('a');
//                         int expiryDays = 0;
//                         if (selectedDayExpiry == 'Day') {
//                           expiryDays = int.parse(expiryController.text) * 1;
//                         } else if (selectedDayExpiry == 'Month') {
//                           expiryDays = int.parse(expiryController.text) * 30;
//                         } else if (selectedDayExpiry == 'Year') {
//                           expiryDays = int.parse(expiryController.text) * 365;
//                         } else {
//                           expiryDays = 0;
//                         }
//                         String dailyuseunit;
//                         if (selectedDailyUse == 'KiloGram') {
//                           dailyuseunit = 'kg';
//                         } else if (selectedDailyUse == 'Gram') {
//                           dailyuseunit = 'g';
//                         } else if (selectedDailyUse == 'Liter') {
//                           dailyuseunit = 'l';
//                         } else if (selectedDailyUse == 'MiliLiter') {
//                           dailyuseunit = 'ml';
//                         } else {
//                           dailyuseunit = '';
//                         }
//                         String lowstockunit;
//                         if (selectedLowStock == 'KiloGram') {
//                           lowstockunit = 'kg';
//                         } else if (selectedLowStock == 'Gram') {
//                           lowstockunit = 'g';
//                         } else if (selectedLowStock == 'Liter') {
//                           lowstockunit = 'l';
//                         } else if (selectedLowStock == 'MiliLiter') {
//                           lowstockunit = 'ml';
//                         } else {
//                           lowstockunit = '';
//                         }

//                         double? lowstock =
//                             double.tryParse(lowstockController.text);
//                         double? dailyuse =
//                             double.tryParse(dailyuseController.text);
//                         print("$dailyuse unit $selectedDailyUse");
//                         print(expiryDays);
//                         print("$lowstock unit $selectedLowStock");
//                       },
//                       textColor: Colors.white,
//                     ),
//                     const SizedBox(
//                       width: 20,
//                     ),
//                     MyButton(
//                       text: 'Cancel',
//                       backgroundColor: Colors.red,
//                       buttonwidth: 150,
//                       onPress: () {
//                         print('a');
//                         //Navigator.of(context).pop();
//                       },
//                       textColor: Colors.white,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
