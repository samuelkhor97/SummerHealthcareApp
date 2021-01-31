import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:summer_healthcare_app/json/weight.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String backendUrl = env['backendUrl'];

class WeightServices {
  static Future<List<Weight>> getAllWeight({String headerToken, String uid}) async {
    var response = await http.get(
      '$backendUrl/weight/all?uid=$uid',
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

  static Future<void> addWeight(
      {String headerToken, String uid, String date, String weight}) async {
    var response = await http.post('$backendUrl/weight/add', headers: {
      'Authorization': headerToken,
    }, body: {
      'uid': uid,
      'date': date,
      'weight': weight
    });

    print('Response: ${response.statusCode} and ${response.body}');
  }

  static Future<void> editWeight(
      {String headerToken,
      String uid,
      String date,
      String oldWeight,
      String newWeight}) async {
    var response = await http.post('$backendUrl/weight/edit', headers: {
      'Authorization': headerToken,
    }, body: {
      'uid': uid,
      'date': date,
      'old_weight': oldWeight,
      'new_weight': newWeight
    });

    print('Response: ${response.statusCode} and ${response.body}');
  }
}
