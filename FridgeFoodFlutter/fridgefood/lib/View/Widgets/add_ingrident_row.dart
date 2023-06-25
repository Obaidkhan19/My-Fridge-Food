//https://www.youtube.com/watch?v=H2pVgDjDrxQ&ab_channel=Kodeversitas

import 'package:flutter/material.dart';
import 'package:fridgefood/View/Widgets/small_unit_dropdown.dart';
import 'package:fridgefood/constants.dart';

class AddIngridentRow extends StatefulWidget {
  const AddIngridentRow({super.key});

  @override
  State<AddIngridentRow> createState() => _AddIngridentRowState();
}

class _AddIngridentRowState extends State<AddIngridentRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 5,
        left: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ingrdeient name
          SizedBox(
            width: 125,
            child: TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: 'Name',
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
            width: 85,
            child: TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: 'Quantity',
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
          const SizedBox(
            width: 140,
            child: SmallUnitDropDown(),
          ),
        ],
      ),
    );
  }
}
