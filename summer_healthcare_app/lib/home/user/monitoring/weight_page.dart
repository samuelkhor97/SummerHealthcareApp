import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';

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

  Widget addWeight(date, weight, lastWeight) {
    return ListTile(
      title: Text(
        date.toString(),
        style: TextStyle(fontSize: FontSizes.normalText),
      ),
      trailing: Text(
        weight.toString() + ' kg',
        style: TextStyle(
            fontSize: FontSizes.biggerText,
            color: weight > lastWeight
                ? Colours.red
                : weight < lastWeight
                    ? Colours.green
                    : Colours.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (weightList == null) {
      weightList = [
        addWeight('15/1/2021', 66, 67),
        addWeight('14/1/2021', 67, 70),
        addWeight('13/1/2021', 70, 69),
        addWeight('12/1/2021', 69, 69)
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
