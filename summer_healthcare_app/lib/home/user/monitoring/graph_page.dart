import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:charts_flutter/flutter.dart' as chart;

class GraphPage extends StatefulWidget {
  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  bool _hasBeenPressed = false;
  var lineData;
  List<bool> daysList = [true, false, false, false];
  List<chart.Series<DataPoints, DateTime>> _seriesLineData;
  List<chart.Series<DataPoints, DateTime>> _seriesLineData_1;
  List<chart.Series<DataPoints, DateTime>> _seriesLineData_2;
  List<chart.Series<DataPoints, DateTime>> _seriesLineData_3;

  var lineData_1 = [
    new DataPoints(new DateTime(2017, 9, 1), 7.0),
    new DataPoints(new DateTime(2017, 9, 2), 8.0),
    new DataPoints(new DateTime(2017, 9, 3), 7.0),
    new DataPoints(new DateTime(2017, 9, 4), 8.9),
    new DataPoints(new DateTime(2017, 9, 5), 6.0),
    new DataPoints(new DateTime(2017, 9, 6), 10.0),
    new DataPoints(new DateTime(2017, 9, 7), 7.0),
  ];

  var lineData_2 = [
    new DataPoints(new DateTime(2017, 9, 1), 7.0),
    new DataPoints(new DateTime(2017, 9, 2), 8.0),
    new DataPoints(new DateTime(2017, 9, 3), 7.0),
    new DataPoints(new DateTime(2017, 9, 4), 8.9),
    new DataPoints(new DateTime(2017, 9, 5), 6.0),
    new DataPoints(new DateTime(2017, 9, 6), 10.0),
    new DataPoints(new DateTime(2017, 9, 7), 7.0),
    new DataPoints(new DateTime(2017, 9, 8), 7.0),
    new DataPoints(new DateTime(2017, 9, 9), 8.0),
    new DataPoints(new DateTime(2017, 9, 10), 7.0),
    new DataPoints(new DateTime(2017, 9, 11), 8.9),
    new DataPoints(new DateTime(2017, 9, 12), 6.0),
    new DataPoints(new DateTime(2017, 9, 13), 10.0),
    new DataPoints(new DateTime(2017, 9, 14), 7.0),
  ];

  var lineData_3 = [
    new DataPoints(new DateTime(2017, 9, 1), 7.0),
    new DataPoints(new DateTime(2017, 9, 8), 8.0),
    new DataPoints(new DateTime(2017, 9, 15), 7.0),
    new DataPoints(new DateTime(2017, 9, 22), 8.9),
  ];

  var lineData_4 = [
    new DataPoints(new DateTime(2017, 9, 1), 7.0),
    new DataPoints(new DateTime(2017, 10, 1), 8.0),
    new DataPoints(new DateTime(2017, 10, 15), 7.0),
  ];

  void _generateData() {
    _seriesLineData.add(
      chart.Series<DataPoints, DateTime>(
        data: lineData_1,
        domainFn: (DataPoints time, _) => time.dateTime,
        measureFn: (DataPoints time, _) => time.val,
        colorFn: (_, __) => chart.MaterialPalette.blue.shadeDefault,
        id: 'Glucose Level',
      ),
    );
  }

  void graphBuilder(int dayIdentifier) {
    // TODO: Switch from using variables to dynamically choosing data sample
    setState(() {
      _seriesLineData = List<chart.Series<DataPoints, DateTime>>();
      for (var i = 0; i < daysList.length; i++) {
        if (i == dayIdentifier) {
          daysList[i] = true;
          if (i == 0) {
            lineData = lineData_1;
          } else if (i == 1) {
            lineData = lineData_2;
          } else if (i == 2) {
            lineData = lineData_3;
          } else {
            lineData = lineData_4;
          }
        } else {
          daysList[i] = false;
        }
      }
      _seriesLineData.add(
        chart.Series<DataPoints, DateTime>(
          data: lineData,
          domainFn: (DataPoints time, _) => time.dateTime,
          measureFn: (DataPoints time, _) => time.val,
          colorFn: (_, __) => chart.MaterialPalette.blue.shadeDefault,
          id: 'Glucose Level',
        ),
      );
    });
  }

  void initState() {
    super.initState();
    _seriesLineData = List<chart.Series<DataPoints, DateTime>>();
    _generateData();
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
            'Sugar Level',
          ),
          centerTitle: true,
          elevation: Dimensions.d_3,
        ),
        body: SafeArea(
          child: Column(
            children: [
              ButtonBar(
                alignment: MainAxisAlignment.center,
                buttonPadding: EdgeInsets.all(0.0),
                children: [
                  SizedBox(
                    width: 110,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colours.secondaryColour,
                        padding: EdgeInsets.all(8.0),
                        side: BorderSide(color: Colours.secondaryColour),
                        shape: BeveledRectangleBorder(),
                      ),
                      onPressed: null,
                      child: Text(
                        'Sugar Level',
                        style: TextStyle(color: Colours.primaryColour),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 110,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.all(8.0),
                        side: BorderSide(color: Colours.secondaryColour),
                        shape: BeveledRectangleBorder(),
                      ),
                      onPressed: null,
                      child: Text(
                        'Weight',
                        style: TextStyle(color: Colours.grey),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 110,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.all(8.0),
                        side: BorderSide(color: Colours.secondaryColour),
                        shape: BeveledRectangleBorder(),
                      ),
                      onPressed: null,
                      child: Text(
                        'Mi-Band',
                        style: TextStyle(color: Colours.grey),
                      ),
                    ),
                  )
                ],
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                buttonPadding: EdgeInsets.all(0.0),
                children: [
                  SizedBox(
                    width: 90,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: daysList[0]
                              ? Colours.secondaryColour
                              : Colours.primaryColour),
                      onPressed: () => graphBuilder(0),
                      child: Text(
                        '7 Days',
                        style: TextStyle(
                            color: daysList[0]
                                ? Colours.primaryColour
                                : Colours.grey),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: daysList[1]
                              ? Colours.secondaryColour
                              : Colours.primaryColour),
                      onPressed: () => graphBuilder(1),
                      child: Text(
                        '14 Days',
                        style: TextStyle(
                            color: daysList[1]
                                ? Colours.primaryColour
                                : Colours.grey),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: daysList[2]
                              ? Colours.secondaryColour
                              : Colours.primaryColour),
                      onPressed: () => graphBuilder(2),
                      child: Text(
                        '30 Days',
                        style: TextStyle(
                            color: daysList[2]
                                ? Colours.primaryColour
                                : Colours.grey),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: daysList[3]
                              ? Colours.secondaryColour
                              : Colours.primaryColour),
                      onPressed: () => graphBuilder(3),
                      child: Text(
                        '90 Days',
                        style: TextStyle(
                            color: daysList[3]
                                ? Colours.primaryColour
                                : Colours.grey),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.all(14.0),
                height: 400,
                width: 400,
                child: chart.TimeSeriesChart(
                  _seriesLineData,
                  animate: false,
                  dateTimeFactory: const chart.LocalDateTimeFactory(),
                  defaultInteractions: true,
                  behaviors: [
                    new chart.ChartTitle('Date',
                        behaviorPosition: chart.BehaviorPosition.bottom,
                        titleOutsideJustification:
                            chart.OutsideJustification.middleDrawArea),
                    new chart.ChartTitle('mmo/L',
                        behaviorPosition: chart.BehaviorPosition.start,
                        titleOutsideJustification:
                            chart.OutsideJustification.middleDrawArea),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DataPoints {
  DateTime dateTime;
  double val;

  DataPoints(this.dateTime, this.val);
}
