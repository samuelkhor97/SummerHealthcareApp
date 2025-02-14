import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:summer_healthcare_app/json/user.dart';
import 'package:summer_healthcare_app/landing/user_details.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String backendUrl = env['backendUrl'];

class UserServices {
  static Future<bool> createUser({String headerToken, UserDetails user}) async {
    var response = await http.post('$backendUrl/user/create', headers: {
      'Authorization': headerToken,
    }, body: {
      'full_name': user.fullName.text,
      'phone_num': user.phoneNumber.text,
      'height': user.height.text,
      'dob': user.dob,
      'gender': user.gender,
      'ethnicity': user.ethnicity,
      'education_status': user.educationStatus,
      'employment_status': user.employmentStatus,
      'occupation': user.occupation.text,
      'marital_status': user.maritalStatus,
      'smoker': user.smoke,
      'cigs_per_day': user.smokePerDay.text,
      'e_cig': user.eCig,
      'weight': user.weight.text
    });

    if (response.statusCode == 200) {
      print('Successfully created new user!');
      return true;
    }

    return false;
  }

  static Future<bool> doesUserExist({String headerToken}) async {
    var response = await http.get('$backendUrl/user/exists', headers: {
      'Authorization': headerToken,
    });

    print('Does User Exists response: ${response.statusCode}, body: ${response.body}');

    Map<String, dynamic> userBody = jsonDecode(response.body);
    return userBody['exists'];
  }


  static Future<User> getUser({String headerToken}) async {
    var response = await http.get('$backendUrl/user/me', headers: {
      'Authorization': headerToken,
    });

    User user;
    if (response.statusCode == 200) {
      Map<String, dynamic> requestsBody = jsonDecode(response.body);
      user = User.fromJson(requestsBody);
    }

    return user;
  }

  static Future<User> getUserById({String headerToken, String userId}) async {
    var response = await http.get('$backendUrl/user/id?id=$userId', headers: {
      'Authorization': headerToken,
    });

    User user;
    if (response.statusCode == 200) {
      Map<String, dynamic> requestsBody = jsonDecode(response.body);
      user = User.fromJson(requestsBody);
    } else {
      return Future.error(response.body.toString());
    }

    return user;
  }

  static Future<String> updateUserById({String headerToken, String userId, Map<String, dynamic> updateValues}) async {
    var response = await http.post('$backendUrl/user/update', headers: {
      'Authorization': headerToken,
    }, body: {
      'id': userId,
      'updateValues': json.encode(updateValues),
    });

    if (response.statusCode == 200) {
      return "Update successful";
    } else {
      return Future.error("Error on updateUserById: ${response.body.toString()}");
    }
  }
}
