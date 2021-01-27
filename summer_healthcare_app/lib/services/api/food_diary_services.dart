import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:summer_healthcare_app/json/food_item.dart';

class FoodDiaryServices {
  Future<List<FoodItem>> getAllFoodDiary(
      {String headerToken}) async {
    var response = await http.get(
        'http://10.0.2.2:3000/food-diary/all',
        headers: {
          'Authorization': 'adminuser',
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

  Future<void> createCard(
      {String headerToken, String date, String card_name}) async {
    var response = await http.post(
        'http://10.0.2.2:3000/food-diary/create-card',
        headers: {'Authorization': headerToken},
        body: {"date": date, "card_name": card_name});
    print('Response: ${response.statusCode}');
  }
}
