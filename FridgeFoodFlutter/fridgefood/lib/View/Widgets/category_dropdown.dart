//https://www.youtube.com/watch?v=i5M6UEpBzBg&ab_channel=TheTechBrothers

import 'package:flutter/material.dart';
import 'package:fridgefood/constants.dart';

class CategoryDropDown extends StatefulWidget {
  final Function(String) onCategorySelected;
  const CategoryDropDown({required this.onCategorySelected, super.key});

  @override
  State<CategoryDropDown> createState() => _CategoryDropDownState();
}

class _CategoryDropDownState extends State<CategoryDropDown> {
  bool isOpen = false;
  String selectedoption = 'Select Category';
  List<String> categoryList = [
    'Dairy',
    'Eggs',
    'Fruits',
    'Vegetables',
    'Meat and seafood',
    'others'
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
                  children: categoryList
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
                                  widget.onCategorySelected(e);
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
