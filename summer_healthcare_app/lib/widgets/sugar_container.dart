import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/widgets/sugar_list.dart';

class sugar_container extends StatelessWidget {
  List<sugar_list> tiles = <sugar_list>[
    sugar_list(
      readings: "9",
      readingTitle: "Wake up",
      readingTime: "9.30 a.m.",
    ),
    sugar_list(
      readings: "12",
      readingTitle: "Afternoon",
      readingTime: "12.30 p.m.",
    ),
    sugar_list(
      readings: "12",
      readingTitle: "Afternoon",
      readingTime: "12.30 p.m.",
    )
  ];
  final sugarLevel;
  final date;
  final day;
  final avg;
  final label;
  final time;


  sugar_container({this.sugarLevel = '', this.date = '', this.day = '', this.avg = '', this.label = '', this.time = ''});

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.d_20),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        child: Container(
          height: this.tiles.length * 80.0,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(this.day + ', ' + this.date),
                    Text(this.avg),
                  ],
                ),
              ),
              Expanded(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: this.tiles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return this.tiles[index];
                    },
                  )
              )
            ],
          ),
        )
      ),
    );
  }
}




