import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:summer_healthcare_app/constants.dart';

class SugarList extends StatefulWidget {
  final double readings;
  final DateTime date;
  @required
  final bool editable;

  SugarList({
    Key key,
    this.readings = 0,
    this.date,
    this.editable,
  }) : super(key: key);

  @override
  _SugarListState createState() => _SugarListState();
}

class _SugarListState extends State<SugarList> {
  String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.d_10, horizontal: Dimensions.d_10),
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
                child: Text(
                  DateFormat('EEE').format(widget.date) + ', ' + DateFormat('dd/MM/yy').format(widget.date),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                thickness: Dimensions.d_2,
              ),
              ListTile(
                leading: Column(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        widget.readings.toString(),
                        style: TextStyle(
                            fontSize: 30,
                            color: widget.readings > 7.8
                                ? Colours.red
                                : widget.readings < 4.0
                                    ? Colours.blue
                                    : Colours.green),
                      ),
                      flex: 4,
                    ),
                    Flexible(
                      child: Text("mmo/L"),
                      flex: 2,
                    )
                  ],
                ),
                title: Text(
                    'Time: ' + DateFormat('hh:mm').format(widget.date),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
