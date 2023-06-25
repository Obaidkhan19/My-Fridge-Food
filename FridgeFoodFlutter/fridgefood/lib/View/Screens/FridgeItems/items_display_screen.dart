import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
//https://www.youtube.com/watch?v=4okl2LsLUaU&ab_channel=JohannesMilke

class ItemDashboard extends StatelessWidget {
  String text;
  VoidCallback onPress;
  Color? itemheadingcolor;
  ItemDashboard({
    super.key,
    required this.text,
    required this.onPress,
    this.itemheadingcolor,
  });
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: itemheadingcolor ?? Colors.black,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 25,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(10),
            itemCount: 10,
            separatorBuilder: (context, index) {
              return const SizedBox(
                width: 12,
              );
            },
            itemBuilder: ((context, index) {
              return buildCard(index);
            }),
          ),
        ),
      ]),
    );
  }

  Widget buildCard(int index) => Badge(
        badgeContent: const Text(
          '900ml',
          style: TextStyle(color: Colors.white),
        ),
        badgeColor: Colors.red,
        borderRadius: BorderRadius.circular(25),
        toAnimate: false,
        shape: BadgeShape.square,
        position: BadgePosition.topEnd(),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                child: Ink.image(
                  image: const AssetImage(
                    'assets/apple.png',
                  ),
                  height: 110,
                  width: 110,
                  fit: BoxFit.cover,
                  child: InkWell(
                    onTap: onPress,
                  ),
                ),
              ),
              const SizedBox(
                height: (4),
              ),
              Text(
                'Apple $index',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
}
