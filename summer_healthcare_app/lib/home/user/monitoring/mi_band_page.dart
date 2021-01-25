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
    'https://www.googleapis.com/auth/fitness.heart_rate.write'
  ],
);

class MiBandPage extends StatefulWidget {
  @override
  _MiBandPageState createState() => _MiBandPageState();
}

class _MiBandPageState extends State<MiBandPage> {
  var todaySteps = 0;
  num currentBPM;
  List<MibandHeartRateData> heartRateData = [
    MibandHeartRateData(0, 55),
    MibandHeartRateData(1, 53),
    MibandHeartRateData(2, 52),
    MibandHeartRateData(3, 53),
    MibandHeartRateData(4, 55),
    MibandHeartRateData(5, 83),
    MibandHeartRateData(6, 85),
    MibandHeartRateData(7, 90),
    MibandHeartRateData(8, 93),
    MibandHeartRateData(9, 90),
    MibandHeartRateData(10, 92),
    MibandHeartRateData(11, 100),
    MibandHeartRateData(12, 90),
    MibandHeartRateData(13, 83),
    MibandHeartRateData(14, 85),
    MibandHeartRateData(15, 83),
    MibandHeartRateData(16, 80),
    MibandHeartRateData(17, 92),
    MibandHeartRateData(18, 90),
    MibandHeartRateData(19, 88),
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

  /// Heart rate body
  // {
  // "aggregateBy": [
  // {
  // "dataTypeName": "com.google.heart_rate.bpm"
  // }
  // ],
  // "endTimeMillis": 1610812800000,
  // "startTimeMillis": 1609430400000
  // }

  Future<void> _getFitData() async {
    var now = DateTime.now();
    var body = jsonEncode({
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

    GoogleSignInAuthentication googlesigninauthentication =
        await _currentUser.authentication;
    var response = await http.post(
        'https://www.googleapis.com/fitness/v1/users/me/dataset:aggregate',
        headers: {
          'authorization': 'Bearer ' + googlesigninauthentication.accessToken
        },
        body: body);
    var output = jsonDecode(response.body);
    setState(() {
      // The integer after bucket is subject to change, to get today's step value, then it's 7
      todaySteps = output["bucket"][7]["dataset"][0]["point"][0]["value"][0]["intVal"];
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
          body: ListView(
            children: <Widget>[
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
                              )
                            ],
                          ),
                          Icon(
                            Icons.directions_run,
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
                                '8h 32min',
                                style: TextStyle(
                                    fontSize: FontSizes.biggerText,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: Dimensions.d_10),
                              Text(
                                'Deep sleep: 2h 20min',
                                style: TextStyle(fontSize: FontSizes.smallText),
                              ),
                              Text(
                                'Light sleep: 6h 12min',
                                style: TextStyle(fontSize: FontSizes.smallText),
                              ),
                              Text(
                                'Awake: 0min',
                                style: TextStyle(fontSize: FontSizes.smallText),
                              ),
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
                            child: charts.LineChart(
                              _getSeriesData(),
                              animate: true,
                              selectionModels: [
                                charts.SelectionModelConfig(
                                  type: charts.SelectionModelType.info,
                                  changedListener: _onSelectionChanged
                                )
                              ],
                            )),
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
    List<charts.Series<MibandHeartRateData, int>> series = [
      charts.Series(
          id: "Heart_rate",
          data: this.heartRateData,
          domainFn: (MibandHeartRateData series, _) => series.time,
          measureFn: (MibandHeartRateData series, _) => series.heart_data,
          colorFn: (MibandHeartRateData series, _) => charts.MaterialPalette.blue.shadeDefault
      )
    ];
    return series;
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
}

class MibandHeartRateData {
  final int time;
  final int heart_data;

  MibandHeartRateData(this.time, this.heart_data);
}

// Column(
// children: <Widget>[
// ElevatedButton(
// child: const Text('SIGN IN'),
// onPressed: _handleSignIn,
// )
// ],
// ),
