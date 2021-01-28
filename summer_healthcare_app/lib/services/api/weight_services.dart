import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:summer_healthcare_app/json/weight.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String backendUrl = env['backendUrl'];

class WeightServices {
  Future<List<Weight>> getAllWeight({String headerToken}) async {
    var response = await http.get(
      '$backendUrl/weight/all',
      headers: {
        'Authorization': headerToken,
      },
    );

    List<Weight> allWeights = [];
    if (response.statusCode == 200) {
      List<dynamic> requestsBody = jsonDecode(response.body);
      for (int i = 0; i < requestsBody.length; i++) {
        Weight weight = Weight.fromJson(requestsBody[i]);
        allWeights.add(weight);
      }
    }

    return allWeights;
  }

  Future<void> addWeight(
      {String headerToken, String date, String weight}) async {
    var response = await http.post('$backendUrl/weight/add', headers: {
      'Authorization': headerToken,
    }, body: {
      'date': date,
      'weight': weight
    });

    print('Response: ${response.statusCode} and ${response.body}');
  }

  Future<void> editWeight(
      {String headerToken,
      String date,
      String oldWeight,
      String newWeight}) async {
    var response = await http.post('$backendUrl/weight/edit', headers: {
      'Authorization': headerToken,
    }, body: {
      'date': date,
      'old_weight': oldWeight,
      'new_weight': newWeight
    });

    print('Response: ${response.statusCode} and ${response.body}');
  }
}
