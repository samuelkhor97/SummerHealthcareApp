import 'package:flutter/material.dart';

class Paddings {
  static EdgeInsetsGeometry startupMain = EdgeInsets.symmetric(vertical: 40.0, horizontal: 30.0);
  static EdgeInsetsGeometry signUpPage = EdgeInsets.only(bottom: 35.0, left: 30.0, right: 30.0);
  static EdgeInsetsGeometry horizontal_5 = EdgeInsets.symmetric(horizontal: 5.0);
  static EdgeInsetsGeometry horizontal_10 = EdgeInsets.symmetric(horizontal: 10.0);
  static EdgeInsetsGeometry horizontal_15 = EdgeInsets.symmetric(horizontal: 15.0);
  static EdgeInsetsGeometry horizontal_20 = EdgeInsets.symmetric(horizontal: 20.0);
  static EdgeInsetsGeometry vertical_5 = EdgeInsets.symmetric(vertical: 5.0);
  static EdgeInsetsGeometry vertical_15 = EdgeInsets.symmetric(vertical: 15.0);
  static EdgeInsetsGeometry vertical_35 = EdgeInsets.symmetric(vertical: 35.0);
  static EdgeInsetsGeometry all_3 = EdgeInsets.all(3.0);
  static EdgeInsetsGeometry all_10 = EdgeInsets.all(10.0);
}

class Dimensions {
  static double buttonRadius = 30.0;
  static double buttonHeight = 50.0;
  static double dialogHeight = 400.0;
  static double d_0 = 0.0;
  static double d_1 = 1.0;
  static double d_2 = 2.0;
  static double d_3 = 3.0;
  static double d_5 = 5.0;
  static double d_10 = 10.0;
  static double d_15 = 15.0;
  static double d_20 = 20.0;
  static double d_25 = 25.0;
  static double d_30 = 30.0;
  static double d_35 = 35.0;
  static double d_45 = 45.0;
  static double d_50 = 50.0;
  static double d_55 = 55.0;
  static double d_65 = 65.0;
  static double d_85 = 85.0;
  static double d_95 = 95.0;
  static double d_100 = 100.0;
  static double d_120 = 120.0;
  static double d_130 = 130.0;
  static double d_140 = 140.0;
  static double d_160 = 160.0 ;
  static double d_200 = 200.0 ;
  static double d_250 = 250.0;
  static double d_280 = 280.0;
  static double d_380 = 380.0;
}

class FontSizes {
  static double mainTitle = 25.0;
  static double title = 20.0;
  static double buttonText = 17.0;
  static double biggerText = 18.0;
  static double normalText = 15.0;
  static double smallText = 12.00;
  static double tinyText = 10.0;
}

class Colours {
  static Color primaryColour = Color(0xFFF7F6F6);
  static Color secondaryColour = Color(0xFF2196f3);
  static Color tertiaryColour = Color(0xFFff8a89);
  static Color grey = Color(0xFF707070);
  static Color black = Color(0xFF333333);
  static Color white = Colors.white;
  static Color midGrey = Colors.grey[400];
  static Color lighterGrey = Colors.grey[300];
  static Color lightGrey = Colors.grey[200];
  static Color green = Color(0xFF0AC350);
  static Color red = Colors.redAccent;
  static Color blue = Color(0xFF4dd7fa);
}

class BordersRadius {
  static BorderRadius rightChatBubble = BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10));
  static BorderRadius leftChatBubble = BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomRight: Radius.circular(10));
  static BorderRadius chatImage = BorderRadius.all(Radius.circular(8.0));
  static BorderRadius userRole = BorderRadius.all(Radius.circular(5.0));
  static BorderRadius chatAvatar = BorderRadius.all(Radius.circular(18.0));
  static BorderRadius profileAvatar = BorderRadius.all(Radius.circular(45.0));
}