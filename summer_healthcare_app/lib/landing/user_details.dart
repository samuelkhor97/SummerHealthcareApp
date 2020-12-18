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
  TextEditingController bodyFat = TextEditingController();
  TextEditingController ethnicity = TextEditingController();
  TextEditingController educationStatus = TextEditingController();
  String employmentStatus;
  TextEditingController occupation = TextEditingController();
  TextEditingController maritalStatus = TextEditingController();
  String smoke;
  TextEditingController smokePerDay = TextEditingController();

  void disposeTexts() {
    fullName.dispose();
    phoneNumber.dispose();
    age.dispose();
    weight.dispose();
    height.dispose();
    bmi.dispose();
    bodyFat.dispose();
    ethnicity.dispose();
    educationStatus.dispose();
    occupation.dispose();
    maritalStatus.dispose();
    smokePerDay.dispose();
  }

  void setIsLogin({bool isLogin}) {
    this.isLogin = isLogin;
  }
}
