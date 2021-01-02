import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';

class SugarList extends StatefulWidget {
  final double readings;
  final String readingTitle;
  final String day;
  final String date;

  SugarList({
    Key key,
    this.readings = 0,
    this.day,
    this.date,
    this.readingTitle,
  }) : super(key: key);

  @override
  _SugarListState createState() => _SugarListState();
}

class _SugarListState extends State<SugarList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.d_10, horizontal: Dimensions.d_10),
      child: GestureDetector(
        onTap: () {
          print('yes');
        },
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(Dimensions.d_10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.d_10),
                  child: Text(this.widget.day + ', ' + this.widget.date, style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Divider(
                  thickness: Dimensions.d_2,
                ),
                ListTile(
                  leading: Column(
                    children: <Widget>[
                      Text(
                        this.widget.readings.toString(),
                        style: TextStyle(
                            fontSize: 30,
                            color: widget.readings > 7.8
                                ? Colours.red
                                : widget.readings < 4.0
                                    ? Colours.blue
                                    : Colours.green),
                      ),
                      Text("mmo/L")
                    ],
                  ),
                  title: Text(
                    this.widget.readingTitle == null
                        ? 'Select Description'
                        : this.widget.readingTitle,
                    style: TextStyle(
                        color: this.widget.readingTitle == null
                            ? Colours.grey
                            : Colours.black),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colours.secondaryColour,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
