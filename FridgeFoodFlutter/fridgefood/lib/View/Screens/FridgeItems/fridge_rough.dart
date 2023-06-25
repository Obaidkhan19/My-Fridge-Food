// import 'package:badges/badges.dart';
// import 'package:flutter/material.dart';
// import 'package:fridgefood/View/Screens/notification.dart';
// import 'package:fridgefood/constants.dart';
// import 'package:boxicons/boxicons.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../Models/fridge_item.dart';
// import '../../Models/utilities.dart';
// import 'add_item.dart';
// import 'item_detail_screen.dart';

// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class FridgeScreen extends StatefulWidget {
//   const FridgeScreen({super.key});

//   @override
//   State<FridgeScreen> createState() => _FridgeScreenState();
// }

// class _FridgeScreenState extends State<FridgeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     getdata();
//     fruitandvegeapi();
//     eggandbakeryapi();
//     meatandseafoodapi();
//     dairyapi();
//     otherapi();
//   }

//   void getdata() async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     fridgeid = sp.getInt('fridgeid');
//     setState(() {});
//   }

//   int? fridgeid;

//   // GET FRUIT AND VEGE
//   List<fridgeItem> fvlist = [];
//   Future<List<fridgeItem>> fruitandvegeapi() async {
//     final response = await http.get(
//         Uri.parse('$ip/Fridgeitem/FruitandVegetableDashboard?fid=$fridgeid'));
//     var data = jsonDecode(response.body.toString());
//     if (response.statusCode == 200) {
//       fvlist.clear();
//       // sucess
//       for (Map i in data) {
//         fvlist.add(fridgeItem.fromJson(i));
//       }
//       return fvlist;
//     } else {
//       return fvlist;
//     }
//   }

//   // Eggs and bakery
//   List<fridgeItem> eglist = [];
//   Future<List<fridgeItem>> eggandbakeryapi() async {
//     final response = await http
//         .get(Uri.parse('$ip/Fridgeitem/EggandBakeryDashboard?fid=$fridgeid'));
//     var data = jsonDecode(response.body.toString());
//     if (response.statusCode == 200) {
//       eglist.clear();
//       // sucess
//       for (Map i in data) {
//         eglist.add(fridgeItem.fromJson(i));
//       }
//       return eglist;
//     } else {
//       return eglist;
//     }
//   }

//   // MEAT AND SEAFOOD
//   List<fridgeItem> mslist = [];
//   Future<List<fridgeItem>> meatandseafoodapi() async {
//     final response = await http
//         .get(Uri.parse('$ip/Fridgeitem/MeatandSeafoodDashboard?fid=$fridgeid'));
//     var data = jsonDecode(response.body.toString());
//     if (response.statusCode == 200) {
//       mslist.clear();
//       // sucess
//       for (Map i in data) {
//         mslist.add(fridgeItem.fromJson(i));
//       }
//       return mslist;
//     } else {
//       return mslist;
//     }
//   }

// // DAIRY
//   List<fridgeItem> dlist = [];
//   Future<List<fridgeItem>> dairyapi() async {
//     final response = await http
//         .get(Uri.parse('$ip/Fridgeitem/DairyDashboard?fid=$fridgeid'));
//     var data = jsonDecode(response.body.toString());
//     if (response.statusCode == 200) {
//       dlist.clear();
//       // sucess
//       for (Map i in data) {
//         dlist.add(fridgeItem.fromJson(i));
//       }
//       return dlist;
//     } else {
//       return dlist;
//     }
//   }

//   // OTHERS
//   List<fridgeItem> olist = [];
//   Future<List<fridgeItem>> otherapi() async {
//     final response = await http
//         .get(Uri.parse('$ip/Fridgeitem/OthersDashboard?fid=$fridgeid'));
//     var data = jsonDecode(response.body.toString());
//     if (response.statusCode == 200) {
//       olist.clear();
//       // sucess
//       for (Map i in data) {
//         olist.add(fridgeItem.fromJson(i));
//       }
//       return olist;
//     } else {
//       return olist;
//     }
//   }

//   TextEditingController nameController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         titleSpacing: 0,
//         backgroundColor: themeColor,
//         automaticallyImplyLeading: false,
//         title: const Text(
//           'Fridge Food',
//           style: headingTextStyle,
//         ),
//         leading: const Icon(
//           Boxicons.bxs_fridge,
//           size: 30.0,
//           color: Colors.white,
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications_none_outlined),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const NotificationScreen()),
//               );
//             },
//             color: Colors.white,
//             iconSize: 30,
//             padding: const EdgeInsets.only(right: 18, left: 6),
//           ),
//         ],
//         centerTitle: true,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(56),
//           child: Padding(
//             padding: const EdgeInsets.all(10),
//             child: TextField(
//               controller: nameController,
//               // onTap: (() {
//               //   final results =
//               //       showSearch(context: context, delegate: ItemSearch());
//               // }),
//               onChanged: (value) {
//                 setState(() {});
//               },
//               cursorColor: themeColor,
//               decoration: InputDecoration(
//                 focusColor: themeColor,
//                 hintText: 'Search For Items',
//                 prefixIcon: IconButton(
//                   color: themeColor,
//                   icon: const Icon(Icons.search_outlined),
//                   onPressed: () {
//                     // final results =
//                     //     showSearch(context: context, delegate: ItemSearch());
//                   },
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(3),
//                   borderSide: BorderSide.none,
//                 ),
//                 contentPadding: EdgeInsets.zero,
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(children: [
//           const SizedBox(
//             height: 5,
//           ),
//           // ItemDashboard(
//           //   text: 'Fruit and Vegetables',
//           //   onPress: () => showModalBottomSheet(
//           //     isScrollControlled: true,
//           //     backgroundColor: Colors.transparent,
//           //     context: context,
//           //     builder: (context) => const ItemDetail(),
//           //   ),
//           // ),
//           Padding(
//             padding: const EdgeInsets.only(
//               left: 10,
//               right: 10,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: const [
//                 Text(
//                   'Fruit and Vegetables',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 Icon(
//                   Icons.arrow_forward_ios_outlined,
//                   size: 25,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 25,
//           ),
//           SizedBox(
//             height: 160,
//             child: FutureBuilder(
//                 future: fruitandvegeapi(),
//                 builder: (context, AsyncSnapshot<List<fridgeItem>> snapshot) {
//                   if (!snapshot.hasData) {
//                     return const CircularProgressIndicator();
//                   } else {
//                     return ListView.separated(
//                       // shrinkWrap: true,
//                       scrollDirection: Axis.horizontal,
//                       padding: const EdgeInsets.all(10),
//                       itemCount: fvlist.length,
//                       separatorBuilder: (context, index) {
//                         return const SizedBox(
//                           width: 12,
//                         );
//                       },
//                       itemBuilder: ((BuildContext context, int index) {
//                         double? quantity = snapshot.data![index].quantity;
//                         String? quantityunit =
//                             snapshot.data![index].quantityunit;

//                         String name = snapshot.data![index].name.toString();
//                         fridgeItem fvobj = fvlist[index];
//                         if (nameController.text.isEmpty) {
//                           return Badge(
//                             badgeContent: Text(
//                               quantity.toString() == 'null' &&
//                                       quantityunit.toString() == 'null'
//                                   ? 'No Stock'
//                                   : quantityunit.toString() == 'null'
//                                       ? quantity.toString()
//                                       : quantity.toString() +
//                                           quantityunit.toString(),
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                             badgeColor: Colors.red,
//                             borderRadius: BorderRadius.circular(25),
//                             toAnimate: false,
//                             shape: BadgeShape.square,
//                             position: BadgePosition.topEnd(),
//                             child: Container(
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Material(
//                                     child: Ink.image(
//                                       image: const AssetImage(
//                                         'assets/apple.png',
//                                       ),
//                                       height: 110,
//                                       width: 110,
//                                       fit: BoxFit.cover,
//                                       child: InkWell(
//                                         onTap: () => showModalBottomSheet(
//                                           isScrollControlled: true,
//                                           backgroundColor: Colors.transparent,
//                                           context: context,
//                                           builder: (context) =>
//                                               ItemDetail(fvobj),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: (2),
//                                   ),
//                                   Text(
//                                     snapshot.data![index].name.toString(),
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         } else if (name
//                             .toLowerCase()
//                             .contains(nameController.text.toLowerCase())) {
//                           return Badge(
//                             badgeContent: Text(
//                               quantity.toString() == 'null' &&
//                                       quantityunit.toString() == 'null'
//                                   ? 'No Stock'
//                                   : quantityunit.toString() == 'null'
//                                       ? quantity.toString()
//                                       : quantity.toString() +
//                                           quantityunit.toString(),
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                             badgeColor: Colors.red,
//                             borderRadius: BorderRadius.circular(25),
//                             toAnimate: false,
//                             shape: BadgeShape.square,
//                             position: BadgePosition.topEnd(),
//                             child: Container(
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Material(
//                                     child: Ink.image(
//                                       image: const AssetImage(
//                                         'assets/apple.png',
//                                       ),
//                                       height: 110,
//                                       width: 110,
//                                       fit: BoxFit.cover,
//                                       child: InkWell(
//                                         onTap: () => showModalBottomSheet(
//                                           isScrollControlled: true,
//                                           backgroundColor: Colors.transparent,
//                                           context: context,
//                                           builder: (context) =>
//                                               ItemDetail(fvobj),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: (2),
//                                   ),
//                                   Text(
//                                     snapshot.data![index].name.toString(),
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         } else {
//                           return Container();
//                         }
//                       }),
//                     );
//                   }
//                 }),
//           ),
//           const SizedBox(
//             height: 15,
//           ),
//           // ItemDashboard(
//           //   text: 'Eggs and Bakery',
//           //   onPress: () => showModalBottomSheet(
//           //     isScrollControlled: true,
//           //     backgroundColor: Colors.transparent,
//           //     context: context,
//           //     builder: (context) =>   ItemDetail(),
//           //   ),
//           // ),
//           Padding(
//             padding: const EdgeInsets.only(
//               left: 10,
//               right: 10,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: const [
//                 Text(
//                   'Eggs and Bakery',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 Icon(
//                   Icons.arrow_forward_ios_outlined,
//                   size: 25,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 25,
//           ),
//           SizedBox(
//             height: 160,
//             child: FutureBuilder(
//                 future: eggandbakeryapi(),
//                 builder: (context, AsyncSnapshot<List<fridgeItem>> snapshot) {
//                   if (!snapshot.hasData) {
//                     return const CircularProgressIndicator();
//                   } else {
//                     return ListView.separated(
//                       // shrinkWrap: true,
//                       scrollDirection: Axis.horizontal,
//                       padding: const EdgeInsets.all(10),
//                       itemCount: eglist.length,
//                       separatorBuilder: (context, index) {
//                         return const SizedBox(
//                           width: 12,
//                         );
//                       },
//                       itemBuilder: ((BuildContext context, int index) {
//                         double? quantity = snapshot.data![index].quantity;
//                         String? quantityunit =
//                             snapshot.data![index].quantityunit;
//                         String name = snapshot.data![index].name.toString();
//                         fridgeItem egobj = eglist[index];

//                         if (nameController.text.isEmpty) {
//                           return Badge(
//                             badgeContent: Text(
//                               quantity.toString() == 'null' &&
//                                       quantityunit.toString() == 'null'
//                                   ? 'No Stock'
//                                   : quantityunit.toString() == 'null'
//                                       ? quantity.toString()
//                                       : quantity.toString() +
//                                           quantityunit.toString(),
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                             badgeColor: Colors.red,
//                             borderRadius: BorderRadius.circular(25),
//                             toAnimate: false,
//                             shape: BadgeShape.square,
//                             position: BadgePosition.topEnd(),
//                             child: Container(
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Material(
//                                     child: Ink.image(
//                                       image: const AssetImage(
//                                         'assets/apple.png',
//                                       ),
//                                       height: 110,
//                                       width: 110,
//                                       fit: BoxFit.cover,
//                                       child: InkWell(
//                                         onTap: () => showModalBottomSheet(
//                                           isScrollControlled: true,
//                                           backgroundColor: Colors.transparent,
//                                           context: context,
//                                           builder: (context) =>
//                                               ItemDetail(egobj),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: (2),
//                                   ),
//                                   Text(
//                                     snapshot.data![index].name.toString(),
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         } else if (name
//                             .toLowerCase()
//                             .contains(nameController.text.toLowerCase())) {
//                           return Badge(
//                             badgeContent: Text(
//                               quantity.toString() == 'null' &&
//                                       quantityunit.toString() == 'null'
//                                   ? 'No Stock'
//                                   : quantityunit.toString() == 'null'
//                                       ? quantity.toString()
//                                       : quantity.toString() +
//                                           quantityunit.toString(),
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                             badgeColor: Colors.red,
//                             borderRadius: BorderRadius.circular(25),
//                             toAnimate: false,
//                             shape: BadgeShape.square,
//                             position: BadgePosition.topEnd(),
//                             child: Container(
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Material(
//                                     child: Ink.image(
//                                       image: const AssetImage(
//                                         'assets/apple.png',
//                                       ),
//                                       height: 110,
//                                       width: 110,
//                                       fit: BoxFit.cover,
//                                       child: InkWell(
//                                         onTap: () => showModalBottomSheet(
//                                           isScrollControlled: true,
//                                           backgroundColor: Colors.transparent,
//                                           context: context,
//                                           builder: (context) =>
//                                               ItemDetail(egobj),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: (2),
//                                   ),
//                                   Text(
//                                     snapshot.data![index].name.toString(),
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         } else {
//                           return Container();
//                         }
//                       }),
//                     );
//                   }
//                 }),
//           ),
//           const SizedBox(
//             height: 15,
//           ),
//           // ItemDashboard(
//           //   text: 'Meat and Seafood',
//           //   onPress: () => showModalBottomSheet(
//           //     isScrollControlled: true,
//           //     backgroundColor: Colors.transparent,
//           //     context: context,
//           //     builder: (context) => const ItemDetail(),
//           //   ),
//           // ),
//           Padding(
//             padding: const EdgeInsets.only(
//               left: 10,
//               right: 10,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: const [
//                 Text(
//                   'Meat and Seafood',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 Icon(
//                   Icons.arrow_forward_ios_outlined,
//                   size: 25,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 25,
//           ),
//           SizedBox(
//             height: 160,
//             child: FutureBuilder(
//                 future: meatandseafoodapi(),
//                 builder: (context, AsyncSnapshot<List<fridgeItem>> snapshot) {
//                   if (!snapshot.hasData) {
//                     return const CircularProgressIndicator();
//                   } else {
//                     return ListView.separated(
//                       // shrinkWrap: true,
//                       scrollDirection: Axis.horizontal,
//                       padding: const EdgeInsets.all(10),
//                       itemCount: mslist.length,
//                       separatorBuilder: (context, index) {
//                         return const SizedBox(
//                           width: 12,
//                         );
//                       },
//                       itemBuilder: ((BuildContext context, int index) {
//                         double? quantity = snapshot.data![index].quantity;
//                         String? quantityunit =
//                             snapshot.data![index].quantityunit;
//                         String name = snapshot.data![index].name.toString();
//                         fridgeItem msobj = mslist[index];

//                         if (nameController.text.isEmpty) {
//                           return Badge(
//                             badgeContent: Text(
//                               quantity.toString() == 'null' &&
//                                       quantityunit.toString() == 'null'
//                                   ? 'No Stock'
//                                   : quantityunit.toString() == 'null'
//                                       ? quantity.toString()
//                                       : quantity.toString() +
//                                           quantityunit.toString(),
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                             badgeColor: Colors.red,
//                             borderRadius: BorderRadius.circular(25),
//                             toAnimate: false,
//                             shape: BadgeShape.square,
//                             position: BadgePosition.topEnd(),
//                             child: Container(
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Material(
//                                     child: Ink.image(
//                                       image: const AssetImage(
//                                         'assets/apple.png',
//                                       ),
//                                       height: 110,
//                                       width: 110,
//                                       fit: BoxFit.cover,
//                                       child: InkWell(
//                                         onTap: () => showModalBottomSheet(
//                                           isScrollControlled: true,
//                                           backgroundColor: Colors.transparent,
//                                           context: context,
//                                           builder: (context) =>
//                                               ItemDetail(msobj),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: (2),
//                                   ),
//                                   Text(
//                                     snapshot.data![index].name.toString(),
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         } else if (name
//                             .toLowerCase()
//                             .contains(nameController.text.toLowerCase())) {
//                           return Badge(
//                             badgeContent: Text(
//                               quantity.toString() == 'null' &&
//                                       quantityunit.toString() == 'null'
//                                   ? 'No Stock'
//                                   : quantityunit.toString() == 'null'
//                                       ? quantity.toString()
//                                       : quantity.toString() +
//                                           quantityunit.toString(),
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                             badgeColor: Colors.red,
//                             borderRadius: BorderRadius.circular(25),
//                             toAnimate: false,
//                             shape: BadgeShape.square,
//                             position: BadgePosition.topEnd(),
//                             child: Container(
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Material(
//                                     child: Ink.image(
//                                       image: const AssetImage(
//                                         'assets/apple.png',
//                                       ),
//                                       height: 110,
//                                       width: 110,
//                                       fit: BoxFit.cover,
//                                       child: InkWell(
//                                         onTap: () => showModalBottomSheet(
//                                           isScrollControlled: true,
//                                           backgroundColor: Colors.transparent,
//                                           context: context,
//                                           builder: (context) =>
//                                               ItemDetail(msobj),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: (2),
//                                   ),
//                                   Text(
//                                     snapshot.data![index].name.toString(),
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         } else {
//                           return Container();
//                         }
//                       }),
//                     );
//                   }
//                 }),
//           ),
//           const SizedBox(
//             height: 15,
//           ),
//           // ItemDashboard(
//           //   text: 'Dairy',
//           //   onPress: () => showModalBottomSheet(
//           //     isScrollControlled: true,
//           //     backgroundColor: Colors.transparent,
//           //     context: context,
//           //     builder: (context) => const ItemDetail(),
//           //   ),
//           // ),

//           Padding(
//             padding: const EdgeInsets.only(
//               left: 10,
//               right: 10,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: const [
//                 Text(
//                   'Dairy',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 Icon(
//                   Icons.arrow_forward_ios_outlined,
//                   size: 25,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 25,
//           ),
//           SizedBox(
//             height: 160,
//             child: FutureBuilder(
//                 future: dairyapi(),
//                 builder: (context, AsyncSnapshot<List<fridgeItem>> snapshot) {
//                   if (!snapshot.hasData) {
//                     return const CircularProgressIndicator();
//                   } else {
//                     return ListView.separated(
//                       //  shrinkWrap: true,
//                       scrollDirection: Axis.horizontal,
//                       padding: const EdgeInsets.all(10),
//                       itemCount: dlist.length,
//                       separatorBuilder: (context, index) {
//                         return const SizedBox(
//                           width: 12,
//                         );
//                       },
//                       itemBuilder: ((BuildContext context, int index) {
//                         double? quantity = snapshot.data![index].quantity;
//                         String? quantityunit =
//                             snapshot.data![index].quantityunit;
//                         String name = snapshot.data![index].name.toString();
//                         fridgeItem dobj = dlist[index];

//                         if (nameController.text.isEmpty) {
//                           return Badge(
//                             badgeContent: Text(
//                               quantity.toString() == 'null' &&
//                                       quantityunit.toString() == 'null'
//                                   ? 'No Stock'
//                                   : quantityunit.toString() == 'null'
//                                       ? quantity.toString()
//                                       : quantity.toString() +
//                                           quantityunit.toString(),
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                             badgeColor: Colors.red,
//                             borderRadius: BorderRadius.circular(25),
//                             toAnimate: false,
//                             shape: BadgeShape.square,
//                             position: BadgePosition.topEnd(),
//                             child: Container(
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Material(
//                                     child: Ink.image(
//                                       image: const AssetImage(
//                                         'assets/apple.png',
//                                       ),
//                                       height: 110,
//                                       width: 110,
//                                       fit: BoxFit.cover,
//                                       child: InkWell(
//                                         onTap: () => showModalBottomSheet(
//                                           isScrollControlled: true,
//                                           backgroundColor: Colors.transparent,
//                                           context: context,
//                                           builder: (context) =>
//                                               ItemDetail(dobj),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: (2),
//                                   ),
//                                   Text(
//                                     snapshot.data![index].name.toString(),
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         } else if (name
//                             .toLowerCase()
//                             .contains(nameController.text.toLowerCase())) {
//                           return Badge(
//                             badgeContent: Text(
//                               quantity.toString() == 'null' &&
//                                       quantityunit.toString() == 'null'
//                                   ? 'No Stock'
//                                   : quantityunit.toString() == 'null'
//                                       ? quantity.toString()
//                                       : quantity.toString() +
//                                           quantityunit.toString(),
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                             badgeColor: Colors.red,
//                             borderRadius: BorderRadius.circular(25),
//                             toAnimate: false,
//                             shape: BadgeShape.square,
//                             position: BadgePosition.topEnd(),
//                             child: Container(
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Material(
//                                     child: Ink.image(
//                                       image: const AssetImage(
//                                         'assets/apple.png',
//                                       ),
//                                       height: 110,
//                                       width: 110,
//                                       fit: BoxFit.cover,
//                                       child: InkWell(
//                                         onTap: () => showModalBottomSheet(
//                                           isScrollControlled: true,
//                                           backgroundColor: Colors.transparent,
//                                           context: context,
//                                           builder: (context) =>
//                                               ItemDetail(dobj),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: (2),
//                                   ),
//                                   Text(
//                                     snapshot.data![index].name.toString(),
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         } else {
//                           return Container();
//                         }
//                       }),
//                     );
//                   }
//                 }),
//           ),
//           const SizedBox(
//             height: 15,
//           ),
//           // ItemDashboard(
//           //   text: 'Others',
//           //   onPress: () => showModalBottomSheet(
//           //     isScrollControlled: true,
//           //     backgroundColor: Colors.transparent,
//           //     context: context,
//           //     builder: (context) => const ItemDetail(),
//           //   ),
//           // ),

//           Padding(
//             padding: const EdgeInsets.only(
//               left: 10,
//               right: 10,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: const [
//                 Text(
//                   'Others',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 Icon(
//                   Icons.arrow_forward_ios_outlined,
//                   size: 25,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 25,
//           ),
//           SizedBox(
//             height: 160,
//             child: FutureBuilder(
//                 future: otherapi(),
//                 builder: (context, AsyncSnapshot<List<fridgeItem>> snapshot) {
//                   if (!snapshot.hasData) {
//                     return const CircularProgressIndicator();
//                   } else {
//                     return ListView.separated(
//                       // shrinkWrap: true,
//                       scrollDirection: Axis.horizontal,
//                       padding: const EdgeInsets.all(10),
//                       itemCount: olist.length,
//                       separatorBuilder: (context, index) {
//                         return const SizedBox(
//                           width: 12,
//                         );
//                       },
//                       itemBuilder: ((BuildContext context, int index) {
//                         double? quantity = snapshot.data![index].quantity;
//                         String? quantityunit =
//                             snapshot.data![index].quantityunit;
//                         String name = snapshot.data![index].name.toString();
//                         fridgeItem oobj = olist[index];

//                         if (nameController.text.isEmpty) {
//                           return Badge(
//                             badgeContent: Text(
//                               quantity.toString() == 'null' &&
//                                       quantityunit.toString() == 'null'
//                                   ? 'No Stock'
//                                   : quantityunit.toString() == 'null'
//                                       ? quantity.toString()
//                                       : quantity.toString() +
//                                           quantityunit.toString(),
//                               style: const TextStyle(color: Colors.white),
//                             ),

//                             // red / themecolor /yellow
//                             badgeColor: Colors.red,
//                             borderRadius: BorderRadius.circular(25),
//                             toAnimate: false,
//                             shape: BadgeShape.square,
//                             position: BadgePosition.topEnd(),
//                             child: Container(
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Material(
//                                     child: Ink.image(
//                                       image: const AssetImage(
//                                         'assets/apple.png',
//                                       ),
//                                       height: 110,
//                                       width: 110,
//                                       fit: BoxFit.cover,
//                                       child: InkWell(
//                                         onTap: () => showModalBottomSheet(
//                                           isScrollControlled: true,
//                                           backgroundColor: Colors.transparent,
//                                           context: context,
//                                           builder: (context) =>
//                                               ItemDetail(oobj),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: (2),
//                                   ),
//                                   Text(
//                                     snapshot.data![index].name.toString(),
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         } else if (name
//                             .toLowerCase()
//                             .contains(nameController.text.toLowerCase())) {
//                           return Badge(
//                             badgeContent: Text(
//                               quantity.toString() == 'null' &&
//                                       quantityunit.toString() == 'null'
//                                   ? 'No Stock'
//                                   : quantityunit.toString() == 'null'
//                                       ? quantity.toString()
//                                       : quantity.toString() +
//                                           quantityunit.toString(),
//                               style: const TextStyle(color: Colors.white),
//                             ),

//                             // red / themecolor /yellow
//                             badgeColor: Colors.red,
//                             borderRadius: BorderRadius.circular(25),
//                             toAnimate: false,
//                             shape: BadgeShape.square,
//                             position: BadgePosition.topEnd(),
//                             child: Container(
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Material(
//                                     child: Ink.image(
//                                       image: const AssetImage(
//                                         'assets/apple.png',
//                                       ),
//                                       height: 110,
//                                       width: 110,
//                                       fit: BoxFit.cover,
//                                       child: InkWell(
//                                         onTap: () => showModalBottomSheet(
//                                           isScrollControlled: true,
//                                           backgroundColor: Colors.transparent,
//                                           context: context,
//                                           builder: (context) =>
//                                               ItemDetail(oobj),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: (2),
//                                   ),
//                                   Text(
//                                     snapshot.data![index].name.toString(),
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         } else {
//                           return Container();
//                         }
//                       }),
//                     );
//                   }
//                 }),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//         ]),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const AddItem()),
//           );
//         },
//         tooltip: 'Increment',
//         backgroundColor: themeColor,
//         child: const Icon(
//           Icons.add,
//           size: 40,
//         ),
//       ),
//     );
//   }
// }
