import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';

class WeightPage extends StatefulWidget {
  @override
  _WeightPageState createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  List<WeightList> weightList;

  @override
  void initState() {
    super.initState();
  }

  void showAddWeightPopUp() {
    TextEditingController weight = TextEditingController();
    String currentDate = DateTime.now().day.toString() + '/' + DateTime.now().month.toString() + '/' + DateTime.now().year.toString();
        showDialog<void>(
      context: context,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: Text('Weight Check In'),
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
              child: Text('ADD WEIGHT'),
              onPressed: () async {
                Navigator.of(alertContext).pop();
                weightList.add(WeightList(currentDate: currentDate, weight: weight, lastWeight: '67',));
                setState(() {

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
    if (weightList == null) {
      weightList = [
        WeightList(currentDate: '12/1/2021', weight: TextEditingController(text: '69'), lastWeight: '69',),
        WeightList(currentDate: '13/1/2021', weight: TextEditingController(text: '70'), lastWeight: '69',),
        WeightList(currentDate: '14/1/2021', weight: TextEditingController(text: '67'), lastWeight: '70',),
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
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: this.weightList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return index == 0
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
          tooltip: 'Add Weight',
          child: Icon(
            Icons.add,
            size: Dimensions.d_35,
          ),
          onPressed: () {
            showAddWeightPopUp();
          },
        ),
      ),
    );
  }
}
