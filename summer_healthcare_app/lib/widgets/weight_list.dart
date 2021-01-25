import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';

class WeightList extends StatefulWidget {
  final String currentDate;
  final String lastWeight;
  final TextEditingController weight;

  WeightList({this.currentDate, this.lastWeight, this.weight});

  @override
  _WeightListState createState() => _WeightListState();
}

class _WeightListState extends State<WeightList> {
  TextEditingController weight;

  void showWeightChangePopUp() {
    showDialog<TextEditingController>(
      context: context,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: Text('Change Weight'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InputField(
                    hintText: '69',
                    controller: weight,
                    labelText: 'Weight (kg)',
                    keyboardType: TextInputType.number,
                  ),
                  Text(
                    'Date: ${widget.currentDate}',
                    style: TextStyle(
                        color: Colours.grey
                    ),
                  ),
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
    if (weight == null) {
      weight = widget.weight;
    }
    return ListTile(
      title: Text(
        widget.currentDate,
        style: TextStyle(fontSize: FontSizes.normalText),
      ),
      trailing: Text(
        weight.text + ' kg',
        style: TextStyle(
            fontSize: FontSizes.biggerText,
            color: int.parse(weight.text) > int.parse(widget.lastWeight)
                ? Colours.red
                : int.parse(weight.text) < int.parse(widget.lastWeight)
                ? Colours.green
                : Colours.grey),
      ),
      onTap: () {
        showWeightChangePopUp();
      },
    );
  }
}
