import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';


class sugar_list extends StatelessWidget {
  final readings;
  final readingTitle;
  final readingTime;






  sugar_list({Key key, this.readings = '', this.readingTitle, this.readingTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Column(
          children: <Widget>[
            Text(
              this.readings,
              style: TextStyle(fontSize: 30, color: Colours.green),
            ),
            Text("mmo/L")
          ],
        ),
        title: Text(this.readingTitle),
        subtitle: Text(this.readingTime)
    );
  }
}
