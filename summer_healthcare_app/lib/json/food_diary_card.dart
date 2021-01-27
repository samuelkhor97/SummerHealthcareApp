import 'package:flutter/cupertino.dart';

class FoodDiaryCard {
  int cardId;
  TextEditingController cardName = TextEditingController();
  String date;
  String photoUrl;
  String uid;
  List<FoodData> foodData;

  FoodDiaryCard(
      {this.cardId,
        this.cardName,
        this.date,
        this.photoUrl,
        this.uid,
        this.foodData});

  FoodDiaryCard.fromJson(Map<String, dynamic> json) {
    cardId = json['card_id'];
    cardName.text = json['card_name'];
    date = json['date'];
    photoUrl = json['photo_url'];
    uid = json['uid'];
    if (json['Food_Data'] != null) {
      foodData = new List<FoodData>();
      json['Food_Data'].forEach((v) {
        foodData.add(new FoodData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['card_id'] = this.cardId;
    data['card_name'] = this.cardName.text;
    data['date'] = this.date;
    data['photo_url'] = this.photoUrl;
    data['uid'] = this.uid;
    if (this.foodData != null) {
      data['Food_Data'] = this.foodData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FoodData {
  int foodId;
  String foodName;
  String calories;

  FoodData({this.foodId, this.foodName, this.calories});

  FoodData.fromJson(Map<String, dynamic> json) {
    foodId = json['food_id'];
    foodName = json['food_name'];
    calories = json['calories'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['food_id'] = this.foodId;
    data['food_name'] = this.foodName;
    data['calories'] = this.calories;
    return data;
  }
}
