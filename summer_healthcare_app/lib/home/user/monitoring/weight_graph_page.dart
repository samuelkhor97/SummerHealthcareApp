import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/services/firebase/auth_service.dart';
import 'package:summer_healthcare_app/services/api/weight_services.dart';
import 'package:summer_healthcare_app/json/weight.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class WeightGraphPage extends StatefulWidget {
  @override
  _WeightGraphPageState createState() => _WeightGraphPageState();
}

class _WeightGraphPageState extends State<WeightGraphPage> {
  List<DataPoints> graphData;
  List<bool> daysList = [true, false, false, false];
  List<charts.Series<DataPoints, DateTime>> seriesWeightData;
  List<Weight> allWeights;

  @override
  void initState() {
    super.initState();
    getAllWeights();
  }

  void getAllWeights() async {
    String token = await AuthService.getToken();
    allWeights = await WeightServices().getAllWeight(headerToken: token);
    allWeights.sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
    graphBuilder(0, 7);
    setState(() {});
  }

  void populateGraphData(int numOfData) {
    graphData = [];
    for (int i = allWeights.length - 1; i >= numOfData; i--) {
      DataPoints dataPoints = new DataPoints(DateTime.parse(allWeights[i].date), double.parse(allWeights[i].weight));
      graphData.add(dataPoints);
    }
  }

  void graphBuilder(int dayIdentifier, int numDays) async {
    seriesWeightData = List<charts.Series<DataPoints, DateTime>>();

    if (numDays > allWeights.length) {
      populateGraphData(0);
    } else {
      populateGraphData(allWeights.length - numDays);
    }

    setState(() {
      for (var i = 0; i < daysList.length; i++) {
        if (i == dayIdentifier) {
          daysList[i] = true;
        } else {
          daysList[i] = false;
        }
      }
      seriesWeightData.add(
        charts.Series<DataPoints, DateTime>(
          data: graphData,
          domainFn: (DataPoints series, _) => series.dateTime,
          measureFn: (DataPoints series, _) => series.val,
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          id: 'Glucose Level',
        ),
      );
    });
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
            'Weight Summary',
          ),
          centerTitle: true,
          elevation: Dimensions.d_3,
        ),
        body: (allWeights == null)
            ? Center(child: CircularProgressIndicator())
            : Container(
                child: Column(
                  children: <Widget>[
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      buttonPadding: EdgeInsets.all(0.0),
                      children: <Widget>[
                        SizedBox(
                          width: 90,
                          child: TextButton(
                            style: TextButton.styleFrom(backgroundColor: daysList[0] ? Colours.secondaryColour : Colours.primaryColour),
                            onPressed: () => graphBuilder(0, 7),
                            child: Text('7 Days', style: TextStyle(color: daysList[0] ? Colours.primaryColour : Colours.grey)),
                          ),
                        ),
                        SizedBox(
                          width: 90,
                          child: TextButton(
                            style: TextButton.styleFrom(backgroundColor: daysList[1] ? Colours.secondaryColour : Colours.primaryColour),
                            onPressed: () => graphBuilder(1, 14),
                            child: Text('14 Days', style: TextStyle(color: daysList[1] ? Colours.primaryColour : Colours.grey)),
                          ),
                        ),
                        SizedBox(
                          width: 90,
                          child: TextButton(
                            style: TextButton.styleFrom(backgroundColor: daysList[2] ? Colours.secondaryColour : Colours.primaryColour),
                            onPressed: () => graphBuilder(2, 30),
                            child: Text('30 Days', style: TextStyle(color: daysList[2] ? Colours.primaryColour : Colours.grey)),
                          ),
                        ),
                        SizedBox(
                          width: 90,
                          child: TextButton(
                            style: TextButton.styleFrom(backgroundColor: daysList[3] ? Colours.secondaryColour : Colours.primaryColour),
                            onPressed: () => graphBuilder(3, 100),
                            child: Text('All Days', style: TextStyle(color: daysList[3] ? Colours.primaryColour : Colours.grey)),
                          ),
                        ),
                      ],
                    ),
                    Container(
                        padding: EdgeInsets.all(14.0),
                        height: 400,
                        width: 400,
                        child: charts.TimeSeriesChart(
                          seriesWeightData,
                          animate: false,
                          dateTimeFactory: const charts.LocalDateTimeFactory(),
                          defaultInteractions: true,
                          primaryMeasureAxis: new charts.NumericAxisSpec(
                              tickProviderSpec: new charts.BasicNumericTickProviderSpec(
                            desiredTickCount: 5,
                            // zeroBound: false,
                          )),
                          behaviors: [new charts.ChartTitle('Date', behaviorPosition: charts.BehaviorPosition.bottom, titleOutsideJustification: charts.OutsideJustification.middleDrawArea), new charts.ChartTitle('kg', behaviorPosition: charts.BehaviorPosition.start, titleOutsideJustification: charts.OutsideJustification.middleDrawArea)],
                        ))
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
