import 'package:flutter/material.dart';

class FoodDiaryItem extends StatefulWidget {
  final String name;
  final String calories;
  final String picture;

  FoodDiaryItem({this.name, this.calories, this.picture});

  @override
  _FoodDiaryItemState createState() => _FoodDiaryItemState();
}

class _FoodDiaryItemState extends State<FoodDiaryItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.fastfood_outlined
      ),
      title: Text(
        widget.name,
      ),
      trailing: Text(
        widget.calories + ' cals',
      ),
    );
  }
}
