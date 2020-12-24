import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';

class SugarList extends StatelessWidget {
  final double readings;
  final readingTitle;
  final readingTime;

  SugarList({Key key, this.readings = 0, this.readingTitle, this.readingTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Column(
          children: <Widget>[
            Text(
              this.readings.toString(),
              style: TextStyle(fontSize: 30, color: readings > 7.8 ? Colours.red : readings < 4.0 ? Colours.blue : Colours.green),
            ),
            Text("mmo/L")
          ],
        ),
        title: Text(this.readingTitle),
        subtitle: Text(this.readingTime)
    );
  }
}
