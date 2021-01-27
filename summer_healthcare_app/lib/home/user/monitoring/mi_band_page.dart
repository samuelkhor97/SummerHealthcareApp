import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import "package:http/http.dart" as http;
import 'package:charts_flutter/flutter.dart' as charts;

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/fitness.activity.read',
    'https://www.googleapis.com/auth/fitness.activity.write',
    'https://www.googleapis.com/auth/fitness.heart_rate.read',
    'https://www.googleapis.com/auth/fitness.heart_rate.write',
    'https://www.googleapis.com/auth/fitness.sleep.read',
    'https://www.googleapis.com/auth/fitness.sleep.write'
  ],
);

class MiBandPage extends StatefulWidget {
  @override
  _MiBandPageState createState() => _MiBandPageState();
}

class _MiBandPageState extends State<MiBandPage> {
  var todaySteps = 0;
  num currentBPM;
  bool showAllData = false;
  var sleepDuration;
  bool stepsCard = false;
  bool sleepCard = false;
  List<MibandHeartRateData> heartRateData = [
    MibandHeartRateData(DateTime(2021, 1, 1, 0, 0), 0),
  ];
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();
    if (_googleSignIn.currentUser == null) {
      _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
        setState(() {
          _currentUser = account;
        });
        if (_currentUser != null) {
          _getFitData();
        } else {
          _handleSignIn();
        }
      });
    } else {
      _currentUser = _googleSignIn.currentUser;
      _getFitData();
    }
    currentBPM = heartRateData[heartRateData.length-1].heart_data;
    _googleSignIn.signInSilently();
  }


  Future<void> _getFitData() async {
    var now = DateTime.now();
    List<MibandHeartRateData> heartRateList = [];
    var stepsBody = jsonEncode({
      "aggregateBy": [
        {
          "dataTypeName": "com.google.step_count.delta",
          "dataSourceId":
              "derived:com.google.step_count.delta:com.google.android.gms:estimated_steps"
        }
      ],
      "bucketByTime": {"durationMillis": 86400000},
      "startTimeMillis": DateTime(now.year, now.month, now.day - 7)
          .toUtc()
          .millisecondsSinceEpoch,
      "endTimeMillis": now.toUtc().millisecondsSinceEpoch
    });

    var heartRateBody = jsonEncode({
      "aggregateBy": [
        {
          "dataTypeName": "com.google.heart_rate.bpm"
        }
      ],
      "startTimeMillis": DateTime(now.year, now.month, now.day).toUtc().millisecondsSinceEpoch,
      "endTimeMillis": now.toUtc().millisecondsSinceEpoch
    });

    var sleepBody = jsonEncode({
      "aggregateBy": [
        {
          "dataTypeName": "com.google.sleep.segment"
        }
      ],
      "startTimeMillis": 1609495200000,
      "endTimeMillis": 1609560000000

    });


    GoogleSignInAuthentication googlesigninauthentication =
        await _currentUser.authentication;


    var stepsResponse = await http.post(
        'https://www.googleapis.com/fitness/v1/users/me/dataset:aggregate',
        headers: {
          'authorization': 'Bearer ' + googlesigninauthentication.accessToken
        },
        body: stepsBody);
    var stepsOutput = jsonDecode(stepsResponse.body);


    var heartRateResponse = await http.post(
        'https://www.googleapis.com/fitness/v1/users/me/dataset:aggregate',
        headers: {
          'authorization': 'Bearer ' + googlesigninauthentication.accessToken
        },
        body: heartRateBody);
    var heartRateOutput = jsonDecode(heartRateResponse.body);
    var heartRateValues = heartRateOutput["bucket"][0]["dataset"][0]["point"];


    for (int i = 0; i < heartRateValues.length; i ++) {
      heartRateList.add(MibandHeartRateData(DateTime.fromMicrosecondsSinceEpoch((int.parse(heartRateValues[i]["endTimeNanos"]) / 1000).round()).add(Duration(hours: 8)),heartRateValues[i]["value"][0]["fpVal"]));
    }


    var sleepResponse = await http.post(
        'https://www.googleapis.com/fitness/v1/users/me/dataset:aggregate',
        headers: {
          'authorization': 'Bearer ' + googlesigninauthentication.accessToken
        },
        body: sleepBody);
    var sleepOutput = jsonDecode(sleepResponse.body);
    var sleepValues = sleepOutput["bucket"][0]["dataset"][0]["point"];

    var sleepTime = sleepValues[0]["startTimeNanos"];
    var wakeTime = sleepValues.last["endTimeNanos"];

    var totalSleepMinutes = (DateTime.fromMicrosecondsSinceEpoch((int.parse(wakeTime) / 1000).round()).difference(DateTime.fromMicrosecondsSinceEpoch((int.parse(sleepTime) / 1000).round())).inMinutes);


    /// SLEEP DATA FOR AWAKE, LIGHT SLEEP AND DEEP SLEEP (DATA IS NOT COMPLETELY RECORDED BY GOOGLE)
    // var one = 0;
    // var four = 0;
    // var five = 0;
    //
    // for (int i = 0; i < sleepValues.length; i ++) {
    //   var sleepStage = sleepValues[i]["value"][0]["intVal"];
    //   var startStageTime = sleepValues[i]["startTimeNanos"];
    //   var endStageTime = sleepValues[i]["endTimeNanos"];
    //   if (sleepStage == 1) {
    //     one += (DateTime.fromMicrosecondsSinceEpoch((int.parse(endStageTime) / 1000).round()).difference(DateTime.fromMicrosecondsSinceEpoch((int.parse(startStageTime) / 1000).round())).inMinutes);
    //   }
    //   else if (sleepStage == 4) {
    //     four += (DateTime.fromMicrosecondsSinceEpoch((int.parse(endStageTime) / 1000).round()).difference(DateTime.fromMicrosecondsSinceEpoch((int.parse(startStageTime) / 1000).round())).inMinutes);
    //   }
    //   else if (sleepStage == 5) {
    //     five += (DateTime.fromMicrosecondsSinceEpoch((int.parse(endStageTime) / 1000).round()).difference(DateTime.fromMicrosecondsSinceEpoch((int.parse(startStageTime) / 1000).round())).inMinutes);
    //   }
    // }


    setState(() {
      // The integer after bucket is subject to change, to get today's step value, then it's 7
      todaySteps = stepsOutput["bucket"][7]["dataset"][0]["point"][0]["value"][0]["intVal"];

      heartRateData = heartRateList;
      currentBPM = heartRateValues[heartRateValues.length-1]["value"][0]["fpVal"];

      sleepDuration = durationToString(totalSleepMinutes);

      showAllData = true;
    });
  }

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
              'Mi Band',
            ),
            centerTitle: true,
            elevation: Dimensions.d_3,
          ),
          body: (showAllData == false) ? Center(child: CircularProgressIndicator()):ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: Dimensions.d_15,
                    left: Dimensions.d_15,
                    right: Dimensions.d_15),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (stepsCard == true) {
                        stepsCard = false;
                      }
                      else {
                        stepsCard = true;
                      }
                    });
                    print(stepsCard);
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.d_15),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Steps Today:',
                                      style:
                                          TextStyle(fontSize: FontSizes.biggerText),
                                    ),
                                    Text(
                                      '$todaySteps',
                                      style: TextStyle(
                                          fontSize: FontSizes.biggerText,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: Dimensions.d_10),
                                    Text(
                                      'Distance: ${(todaySteps / 1312.33595801).toStringAsFixed(2)} KM',
                                      style: TextStyle(fontSize: FontSizes.smallText),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.directions_run,
                                  color: Colours.secondaryColour,
                                  size: Dimensions.d_50,
                                ),
                              ]
                          ),
                          (stepsCard == false) ? SizedBox.shrink() : Container(
                              height: 180,
                              child: charts.TimeSeriesChart(
                                _getSeriesData(),
                                domainAxis: charts.DateTimeAxisSpec(
                                  tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                                      hour: charts.TimeFormatterSpec(
                                          format: 'HH:mm',
                                          transitionFormat: 'HH:mm'
                                      )
                                  ),
                                ),
                                animate: true,
                                selectionModels: [
                                  charts.SelectionModelConfig(
                                      type: charts.SelectionModelType.info,
                                      changedListener: _onSelectionChanged
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: Dimensions.d_15,
                    left: Dimensions.d_15,
                    right: Dimensions.d_15),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.d_15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Last Night Sleep Hours:',
                                style:
                                    TextStyle(fontSize: FontSizes.biggerText),
                              ),
                              Text(
                                '$sleepDuration',
                                style: TextStyle(
                                    fontSize: FontSizes.biggerText,
                                    fontWeight: FontWeight.bold),
                              ),
                              // SizedBox(height: Dimensions.d_10),
                              // Text(
                              //   'Deep sleep: 2h 20min',
                              //   style: TextStyle(fontSize: FontSizes.smallText),
                              // ),
                              // Text(
                              //   'Light sleep: 6h 12min',
                              //   style: TextStyle(fontSize: FontSizes.smallText),
                              // ),
                              // Text(
                              //   'Awake: 0min',
                              //   style: TextStyle(fontSize: FontSizes.smallText),
                              // ),
                            ],
                          ),
                          Icon(
                            Icons.king_bed_rounded,
                            color: Colours.secondaryColour,
                            size: Dimensions.d_50,
                          ),
                        ]
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: Dimensions.d_15,
                    left: Dimensions.d_15,
                    right: Dimensions.d_15),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.d_15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Heart Rate:',
                          style:
                          TextStyle(fontSize: FontSizes.biggerText),
                        ),
                        Text(
                          '$currentBPM BPM',
                          style: TextStyle(
                              fontSize: FontSizes.biggerText,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                            height: 180,
                            child: charts.TimeSeriesChart(
                              _getSeriesData(),
                              domainAxis: charts.DateTimeAxisSpec(
                                tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                                  hour: charts.TimeFormatterSpec(
                                    format: 'HH:mm',
                                    transitionFormat: 'HH:mm'
                                  )
                                ),
                              ),
                              animate: true,
                              selectionModels: [
                                charts.SelectionModelConfig(
                                  type: charts.SelectionModelType.info,
                                  changedListener: _onSelectionChanged
                                )
                              ],
                            )),
                        // ElevatedButton(
                        //   child: const Text('SIGN IN'),
                        //   onPressed: _handleSignIn,
                        // ),
                      ]
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  // signout function
  Future<void> handleSignOut() => _googleSignIn.disconnect();

  _getSeriesData() {
    return <charts.Series<MibandHeartRateData, DateTime>> [
      charts.Series(
          id: "Heart_rate",
          data: this.heartRateData,
          domainFn: (MibandHeartRateData series, _) => series.time,
          measureFn: (MibandHeartRateData series, _) => series.heart_data,
          colorFn: (MibandHeartRateData series, _) => charts.MaterialPalette.blue.shadeDefault
      )
    ];
  }

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    final measures = <String, num>{};

    if (selectedDatum.isNotEmpty) {
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.heart_data;
      });
    }
    setState(() {
      currentBPM = measures["Heart_rate"];
    });
  }


  String durationToString(int minutes) {
    var d = Duration(minutes:minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padRight(2, 'h')}  ${parts[1].padRight(3, 'min')}';
  }

}

class MibandHeartRateData {
  final DateTime time;
  final int heart_data;

  MibandHeartRateData(this.time, this.heart_data);
}

