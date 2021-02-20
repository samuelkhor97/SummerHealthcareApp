import 'package:flutter/cupertino.dart';

class FoodDiaryCard {
  int cardId;
  TextEditingController cardName = TextEditingController();
  String date;
  String uid;
  List<FoodData> foodData;

  FoodDiaryCard(
      {this.cardId, this.cardName, this.date, this.uid, this.foodData});

  FoodDiaryCard.fromJson(Map<String, dynamic> json) {
    cardId = json['card_id'];
    cardName.text = json['card_name'];
    date = json['date'];
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
  FoodBridge foodBridge;

  FoodData({this.foodId, this.foodName, this.calories, this.foodBridge});

  FoodData.fromJson(Map<String, dynamic> json) {
    foodId = json['food_id'];
    foodName = json['food_name'];
    calories = json['calories'];
    foodBridge = json['Food_Bridge'] != null
        ? new FoodBridge.fromJson(json['Food_Bridge'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['food_id'] = this.foodId;
    data['food_name'] = this.foodName;
    data['calories'] = this.calories;
    if (this.foodBridge != null) {
      data['Food_Bridge'] = this.foodBridge.toJson();
    }
    return data;
  }
}

class FoodBridge {
  String photoUrl;

  FoodBridge({this.photoUrl});

  FoodBridge.fromJson(Map<String, dynamic> json) {
    photoUrl = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo_url'] = this.photoUrl;
    return data;
  }
}
