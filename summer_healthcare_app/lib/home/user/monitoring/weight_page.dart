import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';
class WeightPage extends StatefulWidget {
  @override
  _WeightPageState createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {

  @override
  void initState() {
    super.initState();
  }

  Widget addWeight(date, weight, startWeight) {
    return Row(
      children: <Widget>[
        Text(date.toString()),
        Text(
            weight.toString(),
          style: TextStyle(
              fontSize: 30,
              color: weight > startWeight
                  ? Colours.red
                  : weight < startWeight
                  ? Colours.green
                  : Colours.grey),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  @override
  Widget build(BuildContext context) {

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
            Container(
              child: Column(
                children: <Widget>[

                ],
              ),
            )
            // ListView.builder(
            //   physics: NeverScrollableScrollPhysics(),
            //   shrinkWrap: true,
            //   itemCount: this.sugarLevelList.length,
            //   itemBuilder: (BuildContext context, int index) {
            //     return this.sugarLevelList[index];
            //   },
            // )
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
