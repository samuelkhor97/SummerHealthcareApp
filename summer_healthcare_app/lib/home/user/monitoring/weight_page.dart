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

  Widget addWeight(date, weight, startWeight) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, Dimensions.d_10, 0, Dimensions.d_10),
      child: Row(
        children: <Widget>[
          Text(
              date.toString(),
            style: TextStyle(
              fontSize: 20
            ),
          ),
          Text(
              weight.toString() + ' kg',
            style: TextStyle(
                fontSize: 22,
                color: weight > startWeight
                    ? Colours.red
                    : weight < startWeight
                    ? Colours.green
                    : Colours.grey),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    if (weightList == null) {
      weightList = [
        addWeight('15/1/2021', 66, 69),
        addWeight('14/1/2021', 67, 69),
        addWeight('13/1/2021', 70, 69)
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
                  padding: EdgeInsets.all(Dimensions.d_30),
                  child: Column(
                    children: <Widget>[
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: this.weightList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return this.weightList[index];
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
