import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:summer_healthcare_app/json/food_diary_card.dart';
import 'package:summer_healthcare_app/json/food_item.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

final String backendUrl = env['backendUrl'];

class FoodDiaryServices {
  Future<List<FoodItem>> getAllFoodItems({String headerToken}) async {
    var response =
        await http.get('$backendUrl/food-diary/all', headers: {
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
        '$backendUrl/food-diary/all-cards?date=$date',
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

  Future<FoodDiaryCard> getFoodCard(
      {String headerToken, String cardId}) async {
    var response = await http.get(
        '$backendUrl/food-diary/get-card?card_id=$cardId',
        headers: {'Authorization': headerToken});

    FoodDiaryCard foodCard;
    if (response.statusCode == 200) {
      dynamic requestsBody = jsonDecode(response.body);
      foodCard = FoodDiaryCard.fromJson(requestsBody);
    }

    return foodCard;
  }

  Future<void> createCard(
      {String headerToken, String date, String cardName}) async {
    var response = await http.post(
        '$backendUrl/food-diary/create-card',
        headers: {'Authorization': headerToken},
        body: {"date": date, "card_name": cardName});

    print('Response: ${response.statusCode}');
  }

  Future<bool> addFoodItem(
      {String headerToken, int foodId, String cardName, String date}) async {
    var response =
        await http.post('$backendUrl/food-diary/add-food', headers: {
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

  Future<void> uploadFoodItemPicture({String headerToken, File image, String foodId, String date, String cardName}) async {
    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        image.path,
      ),
    });
    print(date);
    Dio dio = Dio();
    var response = await dio.post('$backendUrl/food-diary/food_pic?food_id=$foodId&date=$date&card_name=$cardName',
      data: formData,
      options: Options(
        headers: {
          'Authorization': headerToken, // set content-length
        },
      ),);

    print('Upload Profile Picture: ${response.statusCode}, body: ${response.data}');
  }
}
