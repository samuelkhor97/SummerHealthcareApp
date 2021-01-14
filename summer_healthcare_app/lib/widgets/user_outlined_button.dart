import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';

class UserOutlinedButton extends StatelessWidget {
  final String text;
  final Color textColour;
  final Color color;
  final Color outlineColor;
  final Color foregroundColor;
  final Function onClick;
  final double height;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry buttonRadius;

  UserOutlinedButton({this.text, this.textColour, this.foregroundColor, this.outlineColor, @required this.color, this.onClick, this.height, this.padding, this.buttonRadius});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding == null
          ? EdgeInsets.symmetric(
          vertical: Dimensions.d_15, horizontal: Dimensions.d_5)
          : padding,
      child: Container(
        height: height == null ? Dimensions.buttonHeight : height,
        child: OutlinedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith((states) => color),
            foregroundColor: MaterialStateColor.resolveWith((states) => foregroundColor),
            side: MaterialStateProperty.resolveWith((states) => BorderSide(color: outlineColor, width: 5)),
            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                borderRadius: buttonRadius == null ? BorderRadius.circular(Dimensions.buttonRadius) : buttonRadius),)
          ),
          onPressed: onClick,
          child: Text(
            text,
            style: TextStyle(
                fontSize: FontSizes.buttonText, fontWeight: FontWeight.bold, color: textColour == null ? Colours.white : textColour),
          ),
        ),
      ),
    );
  }
}
