import 'package:flutter/material.dart';

// Add item and recipe first Row
class AddFirstRow extends StatelessWidget {
  String text;
  VoidCallback onPress;

  AddFirstRow({
    super.key,
    required this.text,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // back arrow
        Column(
          children: [
            IconButton(
              onPressed: onPress,
              icon: const Icon(
                Icons.arrow_back_ios_new_outlined,
                size: 25,
              ),
            ),
          ],
        ),

        // add recipe text
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: width * 0.28),
              child: Text(
                text,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),

        // // save
        // Column(
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.only(right: 10),
        //       child: InkWell(
        //         onTap: () {},
        //         child: const Text(
        //           'Save',
        //           style: TextStyle(
        //               fontSize: 20,
        //               color: themeColor,
        //               fontWeight: FontWeight.w600),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
