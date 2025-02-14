import 'package:flutter/material.dart';
import 'package:age/age.dart';

class UserDetails {
  TextEditingController fullName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  bool termsAndConditions = false;
  bool isLogin = false;
  bool isPharmacist = false;
  String gender;
  String dob;
  TextEditingController age = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController height = TextEditingController();
  TextEditingController bmi = TextEditingController();
  String ethnicity;
  static List<String> ethnicityList = ['Malay', 'Chinese', 'Indian'];
  String educationStatus;
  static List<String> educationList = ['Primary', 'Secondary', 'Tertiary'];
  String employmentStatus;
  TextEditingController occupation = TextEditingController();
  String maritalStatus;
  static List<String> maritalStatusList = ['Single', 'Married', 'Divorced', 'Widower'];
  String smoke;
  TextEditingController smokePerDay = TextEditingController();
  String eCig;

  void disposeTexts() {
    fullName.dispose();
    phoneNumber.dispose();
    age.dispose();
    weight.dispose();
    height.dispose();
    bmi.dispose();
    occupation.dispose();
    smokePerDay.dispose();
  }

  void setIsLogin({bool isLogin}) {
    this.isLogin = isLogin;
  }

  void setAge({DateTime dateOfBirth}) {
    DateTime today = DateTime.now();

    this.age.text = Age.dateDifference(
        fromDate: dateOfBirth, toDate: today, includeToDate: false).years.toString();
  }

  void calcBMI({int weight, int height}) {
    double bmiValue = weight/((height/100) * (height/100));
    String bmiString = bmiValue.toStringAsFixed(1);
    this.bmi = new TextEditingController(text: bmiString);
  }
}
