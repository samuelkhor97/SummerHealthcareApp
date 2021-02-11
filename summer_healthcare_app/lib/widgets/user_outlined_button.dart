import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';

class MonitoringButton extends StatelessWidget {
  final String text;
  final Color textColour;
  final Color color;
  final Function onClick;
  final IconData icon;

  MonitoringButton({this.text, this.textColour, @required this.color, this.onClick, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.d_140,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith((states) => color),
        ),
        onPressed: onClick,
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Icon(
                icon,
                size: Dimensions.d_35,
              ),
            ),
            Expanded(
              flex: 14,
              child: Text(
                text,
                style: TextStyle(
                    fontSize: FontSizes.title, fontWeight: FontWeight.bold, color: textColour == null ? Colours.white : textColour),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
