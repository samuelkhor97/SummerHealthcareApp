import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:summer_healthcare_app/json/user.dart';
import 'package:summer_healthcare_app/landing/user_details.dart';

class UserServices {
  Future<bool> createUser(
      {String headerToken, UserDetails user}) async {
    var response = await http.post(
        'http://10.0.2.2:3000/user/create',
        headers: {
          'Authorization': headerToken,
        },
        body: {
          'fullname': user.fullName.text,
          'phone_num': user.phoneNumber.text,
          'height': user.height.text,
          'age': user.age.text,
          'gender': user.gender,
          'ethnicity': user.ethnicity.text,
          'education_status': user.educationStatus.text,
          'employment_status': user.employmentStatus,
          'occupation': user.occupation.text,
          'marital_status': user.maritalStatus.text,
          'smoker': user.smoke,
          'cigs_per_day': user.smokePerDay.text,
          'e_cig': user.e_cig
        });

    if (response.statusCode == 200) {
      print('Successfully created new user!');
      return true;
    }

    return false;
  }

  Future<User> getUser({String headerToken}) async {
    var response = await http.get(
        'http://10.0.2.2:3000/user/me',
        headers: {
          'Authorization': headerToken,
        });

    User user;
    if (response.statusCode == 200) {
      Map<String, dynamic> requestsBody = jsonDecode(response.body);
      user = User.fromJson(requestsBody);
    }

    return user;
  }
}
