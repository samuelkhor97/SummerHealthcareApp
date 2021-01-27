import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:summer_healthcare_app/json/food_diary_card.dart';
import 'package:summer_healthcare_app/json/food_item.dart';

class FoodDiaryServices {
  Future<List<FoodItem>> getAllFoodItems({String headerToken}) async {
    var response =
        await http.get('http://10.0.2.2:3000/food-diary/all', headers: {
      'Authorization': headerToken,
    });

    List<FoodItem> foodDiaries = [];
    if (response.statusCode == 200) {
      List<dynamic> requestsBody = jsonDecode(response.body);
      for (int i = 0; i < requestsBody.length; i++) {
        FoodItem foodDiary = FoodItem.fromJson(requestsBody[i]);
        foodDiaries.add(foodDiary);
      }
    }

    return foodDiaries;
  }

  Future<List<FoodDiaryCard>> getAllCards(
      {String headerToken, String date}) async {
    var response = await http.get(
        'http://10.0.2.2:3000/food-diary/all-cards?date=$date',
        headers: {'Authorization': headerToken});

    List<FoodDiaryCard> foodCards = [];
    if (response.statusCode == 200) {
      List<dynamic> requestsBody = jsonDecode(response.body);
      for (int i = 0; i < requestsBody.length; i++) {
        FoodDiaryCard foodCard = FoodDiaryCard.fromJson(requestsBody[i]);
        foodCards.add(foodCard);
      }
    }

    return foodCards;
  }

  Future<void> createCard(
      {String headerToken, String date, String cardName}) async {
    var response = await http.post(
        'http://10.0.2.2:3000/food-diary/create-card',
        headers: {'Authorization': headerToken},
        body: {"date": date, "card_name": cardName});

    print('Response: ${response.statusCode}');
  }

  Future<bool> addFoodItem(
      {String headerToken, int foodId, String cardName, String date}) async {
    var response =
        await http.post('http://10.0.2.2:3000/food-diary/add-food', headers: {
      'Authorization': headerToken,
    }, body: {
      'food_id': foodId.toString(),
      'card_name': cardName,
      'date': date
    });

    if (response.statusCode == 200) {
      print('Successfully Added New Food Item!');
      return true;
    }

    return false;
  }
}