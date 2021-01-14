import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';

class UserButton extends StatelessWidget {
  final String text;
  final Color textColour;
  final Color color;
  final Function onClick;
  final double height;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry buttonRadius;
  UserButton({this.text, this.textColour, this.color, this.onClick, this.height, this.padding, this.buttonRadius});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding == null
          ? EdgeInsets.symmetric(
          vertical: Dimensions.d_15, horizontal: Dimensions.d_5)
          : padding,
      child: ButtonTheme(
        height: height == null ? Dimensions.buttonHeight : height,
        minWidth: double.infinity,
        child: RaisedButton(
          elevation: Dimensions.d_5,
          color: color,
          disabledColor: color.withOpacity(0.6),
          onPressed: onClick,
          child: Text(
            text,
            style: TextStyle(
                fontSize: FontSizes.buttonText, fontWeight: FontWeight.bold, color: textColour == null ? Colours.white : textColour),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: buttonRadius == null ? BorderRadius.circular(Dimensions.buttonRadius) : buttonRadius),
        ),
      ),
    );
  }
}
