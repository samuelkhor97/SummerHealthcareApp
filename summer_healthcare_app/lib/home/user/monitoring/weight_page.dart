import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';

class WeightPage extends StatefulWidget {
  @override
  _WeightPageState createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  List<Widget> weightList;

  @override
  void initState() {
    super.initState();
  }

  Widget addWeight(String date, TextEditingController weight, String lastWeight) {
    String w = weight.text;
    return ListTile(
      title: Text(
        date.toString(),
        style: TextStyle(fontSize: FontSizes.normalText),
      ),
      trailing: Text(
        w + ' kg',
        style: TextStyle(
            fontSize: FontSizes.biggerText,
            color: int.parse(weight.text) > int.parse(lastWeight)
                ? Colours.red
                : int.parse(weight.text) < int.parse(lastWeight)
                    ? Colours.green
                    : Colours.grey),
      ),
      onTap: () async {
        TextEditingController newWeight = await showWeightChangePopUp(currentDate: date, weight: weight);
        print('weight: ${newWeight.text}');
        setState(() {
          w = newWeight.text;
        });
      },
    );
  }

  Future<TextEditingController> showWeightChangePopUp({String currentDate, TextEditingController weight}) async {
    await showDialog<TextEditingController>(
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
                    // onChanged: (String text) {
                    //   setState(() {
                    //     checkAllInformationFilled(checkBox: userDetails.termsAndConditions);
                    //   });
                    // },
                  ),
                  Text(
                    'Date: $currentDate',
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
              onPressed: () {
                Navigator.of(alertContext).pop();
                print('weight1: ${weight.text}');
                return weight;
              },
            ),
          ],
        );
      },
    );
    return weight;
  }

  @override
  Widget build(BuildContext context) {
    if (weightList == null) {
      weightList = [
        addWeight('15/1/2021', TextEditingController(text: '66'), '67'),
        addWeight('14/1/2021', TextEditingController(text: '67'), '70'),
        addWeight('13/1/2021', TextEditingController(text: '70'), '69'),
        addWeight('12/1/2021', TextEditingController(text: '69'), '69')
      ];
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colours.primaryColour,
        appBar: AppBar(
          backgroundColor: Colours.primaryColour,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Weight',
          ),
          centerTitle: true,
          elevation: Dimensions.d_3,
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(Dimensions.d_15),
              child: Container(
                color: Colours.white,
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.d_15),
                  child: Column(
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '69 kg',
                                  style:
                                      TextStyle(fontSize: FontSizes.biggerText),
                                ),
                                SizedBox(
                                  height: Dimensions.d_5,
                                ),
                                Text('Start Weight',
                                    style: TextStyle(
                                        fontSize: FontSizes.normalText))
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '69 kg',
                                  style:
                                      TextStyle(fontSize: FontSizes.biggerText),
                                ),
                                SizedBox(
                                  height: Dimensions.d_5,
                                ),
                                Text('Current Weight',
                                    style: TextStyle(
                                        fontSize: FontSizes.normalText))
                              ],
                            )
                          ]),
                      SizedBox(height: Dimensions.d_10),
                      Divider(
                        color: Colours.grey,
                        thickness: Dimensions.d_2,
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: this.weightList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return index == this.weightList.length - 1
                              ? this.weightList[index]
                              : Column(
                                  children: [
                                    this.weightList[index],
                                    Divider(
                                      color: Colours.lighterGrey,
                                      thickness: Dimensions.d_1,
                                    )
                                  ],
                                );
                        },
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          // mini: true,
          tooltip: 'Add Weight',
          child: Icon(
            Icons.add,
            size: Dimensions.d_35,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
