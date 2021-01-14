import 'package:flutter/material.dart';

void showLoadingAnimation({BuildContext context}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Center(child: CircularProgressIndicator());
    },
  );
}