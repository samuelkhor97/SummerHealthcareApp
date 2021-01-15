import 'package:flutter/material.dart';

class UserDetails {
  TextEditingController fullName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  bool termsAndConditions = false;
  bool isLogin = false;
  String gender;
  TextEditingController age = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController height = TextEditingController();
  TextEditingController bmi = TextEditingController();
  TextEditingController ethnicity = TextEditingController();
  TextEditingController educationStatus = TextEditingController();
  String employmentStatus;
  TextEditingController occupation = TextEditingController();
  TextEditingController maritalStatus = TextEditingController();
  String smoke;
  TextEditingController smokePerDay = TextEditingController();
  String e_cig;

  void disposeTexts() {
    fullName.dispose();
    phoneNumber.dispose();
    age.dispose();
    weight.dispose();
    height.dispose();
    bmi.dispose();
    ethnicity.dispose();
    educationStatus.dispose();
    occupation.dispose();
    maritalStatus.dispose();
    smokePerDay.dispose();
  }

  void setIsLogin({bool isLogin}) {
    this.isLogin = isLogin;
  }

  void calcBMI({int weight, int height}) {
    double bmiValue = weight/((height/100) * (height/100));
    String bmiString = bmiValue.toStringAsFixed(1);
    this.bmi = new TextEditingController(text: bmiString);
  }
}
