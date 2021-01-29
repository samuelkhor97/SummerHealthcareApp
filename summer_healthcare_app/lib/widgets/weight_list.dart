import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';
import 'package:summer_healthcare_app/services/firebase/auth_service.dart';
import 'package:summer_healthcare_app/services/api/weight_services.dart';

class WeightList extends StatefulWidget {
  final String currentDate;
  final String lastWeight;
  final TextEditingController weight;
  Function callback;
  WeightList({this.currentDate, this.lastWeight, this.weight, this.callback});

  @override
  _WeightListState createState() => _WeightListState();
}

class _WeightListState extends State<WeightList> {
  TextEditingController weight;

  void showWeightChangePopUp() {
    String oldWeight = weight.text;
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
                    style: TextStyle(color: Colours.grey),
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
                String token = await AuthService.getToken();
                List dateSplit = widget.currentDate.split("/");
                String weightDate = dateSplit[2] + "-" + dateSplit[1] + "-" + dateSplit[0];
                await WeightServices().editWeight(headerToken: token, oldWeight: oldWeight, newWeight: weight.text, date: weightDate);

                setState(() {
                  widget.callback(); // callback to refresh main weight page
                });
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
