import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';

class MonitoringPage extends StatefulWidget {
  @override
  _MonitoringPageState createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  List<SugarContainer> sugarContainerList = [
    SugarContainer(
      day: 'SAT',
      date: '5/12/20',
    ),
    SugarContainer(
      day: 'SUN',
      date: '6/12/20',
    ),
  ];
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colours.primaryColour,
          body: ListView(
            children: <Widget>[
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: this.sugarContainerList.length,
                itemBuilder: (BuildContext context, int index) {
                  return this.sugarContainerList[index];
                },
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            mini: true,
            tooltip: 'Monitoring Summary',
            child: Icon(
              Icons.stacked_bar_chart
            ),
            onPressed: () {},
          ),
        ),
    );
  }
}
