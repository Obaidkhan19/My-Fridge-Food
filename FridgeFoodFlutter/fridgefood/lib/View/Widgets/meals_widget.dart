import 'package:flutter/material.dart';
import 'package:fridgefood/Models/meal.dart';

import '../../utils/utilities.dart';

class MealsWidget extends StatefulWidget {
  Meals mealobj;
  MealsWidget({required this.mealobj, super.key});

  @override
  State<MealsWidget> createState() => _MealsWidgetState();
}

class _MealsWidgetState extends State<MealsWidget> {
  @override
  Widget build(BuildContext context) {
    int servings = widget.mealobj.servings!;
    return Column(children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            child: Ink.image(
              image: NetworkImage(
                imgpath + widget.mealobj.image!,
              ),
              height: 110,
              width: 110,
              fit: BoxFit.cover,
              child: InkWell(onTap: () {
                //   showModalBottomSheet(
                //   backgroundColor: Colors.transparent,
                //   isScrollControlled: true,
                //   context: context,
                //   builder: (context) (){},
                // )
              }),
            ),
          ),
          const SizedBox(
            height: (4),
          ),
          Text(
            widget.mealobj.name!,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(
            height: (4),
          ),
          Text(
            'Servings $servings',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    ]);
  }
}
