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

  void disposeTexts() {
    fullName.dispose();
    phoneNumber.dispose();
    age.dispose();
    weight.dispose();
    height.dispose();
  }

  void setIsLogin({bool isLogin}) {
    this.isLogin = isLogin;
  }
}
