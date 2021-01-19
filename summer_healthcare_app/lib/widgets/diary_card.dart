import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';

class DiaryCard extends StatefulWidget {
  final String title;

  DiaryCard({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  _DiaryCardState createState() => _DiaryCardState();
}

class _DiaryCardState extends State<DiaryCard> {
  int totalCalories = 0;
  List<FoodDiaryItem> foodDiaryItems = [
    FoodDiaryItem(
      name: 'Sandwich',
      calories: '200',
      picture: 'bitch',
    ),
    FoodDiaryItem(
      name: 'Coffee',
      calories: '69',
      picture: 'bitches',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.d_15),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(Dimensions.d_15),
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Row(
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                              color: Colours.black,
                              fontWeight: FontWeight.bold,
                              fontSize: FontSizes.biggerText),
                        ),
                        SizedBox(width: Dimensions.d_10),
                        Icon(
                          Icons.create,
                          color: Colours.black,
                          size: Dimensions.d_20,
                        )
                      ],
                    ),
                    onTap: () {},
                  ),
                  InkWell(
                    child: Text(
                      'Add Item',
                      style: TextStyle(
                          color: Colours.secondaryColour,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    onTap: () {
                      print('add item');
                    },
                  )
                ],
              ),
              SizedBox(
                height: Dimensions.d_10,
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: foodDiaryItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return foodDiaryItems[index];
                  }),
              SizedBox(
                height: Dimensions.d_10,
              ),
              Text(
                'Total Calories: $totalCalories cals',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
