import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';

class sugar_container extends StatelessWidget {
  List<ListTile> tiles = <ListTile>[
    ListTile(
    leading: Text("nien"),
    title: Text("user input"),
    subtitle: Text("current time"),
  ),
    ListTile(
      leading: Text("nien2"),
      title: Text("user input2"),
      subtitle: Text("current time2"),
    ),
    ListTile(
      leading: Text("nien3"),
      title: Text("user input3"),
      subtitle: Text("current time3"),
    )];
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
      child: Container(
        margin: EdgeInsets.all(15.0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 5,
          child: Container(
            height: this.tiles.length * 75.0,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(this.day + ', ' + this.date),
                    Text(this.avg),
                  ],
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
        )
      ),
    );
  }
}




