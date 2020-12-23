import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';

class MonitoringPage extends StatefulWidget {
  @override
  _MonitoringPageState createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  @override
  void initState() {
    super.initState();
  }


  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold (
          backgroundColor: Colours.primaryColour,
          body: Column (
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              sugar_container(
                day: 'SAT',
                date: '5/12/20',
                avg: '3',
              )
            ],
          ),
        ),
    );
  }
}
