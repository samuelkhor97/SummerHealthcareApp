import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/widgets/sugar_list.dart';

class SugarContainer extends StatelessWidget {
  final List<SugarList> tiles = <SugarList>[
    SugarList(
      readings: 7,
      readingTitle: "Wake up",
      readingTime: "9.30 a.m.",
    ),
    SugarList(
      readings: 3.5,
      readingTitle: "Afternoon",
      readingTime: "12.30 p.m.",
    ),
    SugarList(
      readings: 12,
      readingTitle: "Afternoon",
      readingTime: "12.30 p.m.",
    ),
  ];
  final sugarLevel;
  final date;
  final day;
  final avg;
  final label;
  final time;

  SugarContainer({this.sugarLevel = '', this.date = '', this.day = '', this.avg = '', this.label = '', this.time = ''});

  double getAverageSugarLevel() {
    double average = 0;
    for (int i = 0; i < tiles.length; i++) {
      average += tiles[i].readings;
    }
    return average / tiles.length;
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.d_20, horizontal: Dimensions.d_10),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(Dimensions.d_10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(this.day + ', ' + this.date),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colours.black
                      ),
                      text: '${tiles.length} test avg. ',
                      children: <TextSpan>[
                        TextSpan(text: getAverageSugarLevel().toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' mmol/L'),
                      ],
                    ),
                  )
                ],
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: this.tiles.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    this.tiles[index],
                    index != this.tiles.length - 1 ? Divider(
                      thickness: 1.5,
                    ) : SizedBox.shrink()
                  ],
                );
              },
            )
          ],
        )
      ),
    );
  }
}




