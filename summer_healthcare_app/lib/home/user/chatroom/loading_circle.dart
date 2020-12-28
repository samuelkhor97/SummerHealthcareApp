import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';

class LoadingCircle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colours.primaryColour,
          ),
        ),
      ),
      color: Colors.white.withOpacity(0.8),
    );
  }
}
