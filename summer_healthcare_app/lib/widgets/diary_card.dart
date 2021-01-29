import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/home/user/diary/add_food_item_page.dart';
import 'package:summer_healthcare_app/json/food_diary_card.dart';
import 'package:summer_healthcare_app/json/food_item.dart';
import 'package:summer_healthcare_app/services/api/food_diary_services.dart';
import 'package:summer_healthcare_app/services/firebase/auth_service.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';

class DiaryCard extends StatefulWidget {
  final TextEditingController title;
  final FoodDiaryCard foodDiaryCard;

  DiaryCard({
    Key key,
    this.title, this.foodDiaryCard,
  }) : super(key: key);

  @override
  _DiaryCardState createState() => _DiaryCardState();
}

class _DiaryCardState extends State<DiaryCard> {
  double totalCalories = 0;
  List<FoodDiaryItem> foodDiaryItems = [];
  FoodDiaryCard foodDiaryCard;

  void _refreshFoodItems() {
    foodDiaryItems.clear();
    totalCalories = 0;
    for (int i = 0; i < foodDiaryCard.foodData.length; i++) {
      foodDiaryItems.add(FoodDiaryItem(
        name: foodDiaryCard.foodData[i].foodName,
        calories: foodDiaryCard.foodData[i].calories.substring(0, foodDiaryCard.foodData[i].calories.length - 5),
        picture: 'bitches',
      ),);
      totalCalories += double.parse(foodDiaryCard.foodData[i].calories.substring(0, foodDiaryCard.foodData[i].calories.length - 5));
    }
  }

  void editTitlePopUp() {
    showDialog<TextEditingController>(
      context: context,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: Text('Change Title'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return InputField(
                hintText: 'Breakfast',
                controller: widget.title,
              );
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('UPDATE'),
              onPressed: () async {
                Navigator.of(alertContext).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (foodDiaryCard == null) {
      foodDiaryCard = widget.foodDiaryCard;
      _refreshFoodItems();
    }
    return (foodDiaryCard == null) ? Container() : Padding(
      padding: EdgeInsets.fromLTRB(Dimensions.d_15, Dimensions.d_15, Dimensions.d_15, Dimensions.d_0),
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
                          widget.title.text,
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
                    onTap: () {
                      editTitlePopUp();
                    },
                  ),
                  InkWell(
                    child: Text(
                      'Add Item',
                      style: TextStyle(
                          color: Colours.secondaryColour,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    onTap: () async {
                      FoodItem newFoodItem = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              AddFoodItemPage()
                          ));
                      if (newFoodItem != null) {
                        String authToken = await AuthService.getToken();
                        await FoodDiaryServices().addFoodItem(
                            headerToken: authToken,
                            foodId: newFoodItem.foodId,
                            cardName: widget.title.text,
                            date: foodDiaryCard.date.substring(0, 10)
                        );
                        foodDiaryCard.foodData.add(
                          FoodData(
                            foodId: newFoodItem.foodId,
                            foodName: newFoodItem.foodName,
                            calories: newFoodItem.calories
                          )
                        );
                        setState(() {
                          _refreshFoodItems();
                          // totalCalories += double.parse(newFoodItem.calories.substring(0, newFoodItem.calories.length - 5));
                        });
                      }
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
                  reverse: true,
                  itemCount: foodDiaryItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return foodDiaryItems[index];
                  }),
              SizedBox(
                height: Dimensions.d_10,
              ),
              Text(
                'Total Calories: ${double.parse(totalCalories.toStringAsFixed(2))} kcal',
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