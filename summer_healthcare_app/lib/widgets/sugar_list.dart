import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';

class SugarList extends StatefulWidget {
  final double readings;
  final String day;
  final String date;

  SugarList(
      {Key key,
      this.readings = 0,
      this.day,
      this.date,})
      : super(key: key);

  @override
  _SugarListState createState() => _SugarListState();
}

class _SugarListState extends State<SugarList> {
  String description;

  void showDescriptionChangePopUp() {
    showDialog<void>(
      context: context,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: Text('Change Description'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(
                      title: Text(
                        'Wake Up',
                      ),
                      value: 'Wake Up',
                      groupValue: description,
                      onChanged: (String value) {
                        setState(() {
                          description = value;
                        });
                      }),
                  RadioListTile(
                      title: Text(
                        'Before Meal',
                      ),
                      value: 'Before Meal',
                      groupValue: description,
                      onChanged: (String value) {
                        setState(() {
                          description = value;
                        });
                      }),
                  RadioListTile(
                      title: Text(
                        'After Meal',
                      ),
                      value: 'After Meal',
                      groupValue: description,
                      onChanged: (String value) {
                        setState(() {
                          description = value;
                        });
                      }),
                ],
              );
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('UPDATE'),
              onPressed: () async {
                Navigator.of(alertContext).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.d_10, horizontal: Dimensions.d_10),
      child: GestureDetector(
        onTap: () {
          showDescriptionChangePopUp();
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
                  child: Text(
                    widget.day + ', ' + widget.date,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(
                  thickness: Dimensions.d_2,
                ),
                ListTile(
                  leading: Column(
                    children: <Widget>[
                      Text(
                        widget.readings.toString(),
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
                    description == null ? 'Select Description' : description,
                    style: TextStyle(
                        color: description == null
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
