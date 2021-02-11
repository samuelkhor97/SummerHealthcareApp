import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:summer_healthcare_app/constants.dart';
import "package:http/http.dart" as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart' as store;
import 'package:summer_healthcare_app/main.dart';

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
  final bool appBar;
  final String uid;

  MiBandPage({@required this.appBar, this.uid});

  @override
  _MiBandPageState createState() => _MiBandPageState();
}

class _MiBandPageState extends State<MiBandPage> {
  store.FirebaseFirestore _firestore = store.FirebaseFirestore.instance;
  var todaySteps = 0;
  num currentBPM;
  bool showAllData = false;
  var sleepDuration;
  bool stepsCard = false;
  bool sleepCard = false;
  List<MibandHeartRateData> heartRateData = [
    MibandHeartRateData(DateTime(2021, 1, 1, 0, 0), 0),
  ];
  List<MiBandStepsData> stepsData = [
    MiBandStepsData(DateFormat('EEEE').format(DateTime(2021, 1, 1)), 0)
  ];
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();
    // if uid is passed to current page, it means it is from Pharmacist View -> Patient Monitoring
    if (widget.uid != null) {
      _getFitDataFirestore(uid: widget.uid);
    } else {
      print('here ${_googleSignIn.currentUser}');
      if (_googleSignIn.currentUser == null) {
        _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
          if (mounted) {
            setState(() {
              _currentUser = account;
            });
          }
          if (_currentUser != null) {
            _getFitDataGoogle();
          }
        });
      } else {
        _currentUser = _googleSignIn.currentUser;
        _getFitDataGoogle();
      }
      currentBPM = heartRateData[heartRateData.length-1].heart_data;
      _googleSignIn.signInSilently();
    }
  }

  Future<void> _getFitDataGoogle() async {
    var now = DateTime.now();
    List<MibandHeartRateData> heartRateList = [];
    List<MiBandStepsData> stepsList = [];

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
      "startTimeMillis":  DateTime(now.year, now.month, now.day - 1, 18, 0 , 0).toUtc().millisecondsSinceEpoch,
      "endTimeMillis": now.toUtc().millisecondsSinceEpoch

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
    var stepsValues = stepsOutput["bucket"];

    if (stepsValues == null) {
      var formatedDate = DateFormat('EEE').format(DateTime.now());
      stepsList.add(MiBandStepsData(formatedDate, 0));
    }
    else {
      for (int i = 0; i < stepsValues.length; i++) {
        var dateMili = int.parse(stepsValues[i]["startTimeMillis"]);
        var formatedDate = DateFormat('EEE').format(DateTime.fromMillisecondsSinceEpoch(dateMili).add(Duration(hours: 8)));
        if (stepsValues[i]["dataset"][0]["point"].length == 0) {
          stepsList.add(MiBandStepsData(formatedDate, 0));
        }
        else {
          var steps = stepsValues[i]["dataset"][0]["point"][0]["value"][0]["intVal"];

          stepsList.add(MiBandStepsData(formatedDate, steps));
        }
      }
    }


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
    var totalSleepMinutes = 0;

    if (sleepValues.length == 0) {
      totalSleepMinutes = 0;
    }
    else {
      var sleepTime = sleepValues[0]["startTimeNanos"];
      var wakeTime = sleepValues.last["endTimeNanos"];
      totalSleepMinutes = (DateTime.fromMicrosecondsSinceEpoch((int.parse(wakeTime) / 1000).round()).difference(DateTime.fromMicrosecondsSinceEpoch((int.parse(sleepTime) / 1000).round())).inMinutes);
    }

    setState(() {
      if (stepsValues == null) {
        todaySteps = 0;
      }
      else if (stepsValues.last["dataset"][0]["point"].length == 0) {
        todaySteps = 0;
      }
      else {
        todaySteps = stepsValues.last["dataset"][0]["point"][0]["value"][0]["intVal"];
      }
      stepsData = stepsList;

      heartRateData = heartRateList;
      if (heartRateValues.length == 0) {
        currentBPM = 0;
      }
      else {
        currentBPM = heartRateValues.last["value"][0]["fpVal"];
      }

      sleepDuration = durationToString(totalSleepMinutes);

      showAllData = true;
    });
    saveToFirebase(showAllData);
  }

  Future<void> _getFitDataFirestore({@required String uid}) async {
    // code below is done out of hurry, please optimize when there is time
    DateTime todayDate = DateTime.now().add(Duration(hours: 8));
    // dates will be storing data in ascending order with respect to date (ie earliest date in front of list)
    List<DateTime> dates = [];
    for (int i = 7; i >= 0; i--) {
      dates.add(DateTime(todayDate.year, todayDate.month, todayDate.day - i));
    }

    final List<store.QuerySnapshot> results = [];
    for (DateTime date in dates) {
      String strDate = DateFormat('dd-MM-yyyy').format(date);
      store.QuerySnapshot result = await _firestore.collection("mi-band").doc(uid).collection(strDate).get();
      results.add(result);
    }
    
    List<MiBandStepsData> stepsList = [];
    for (int i = 0; i < results.length; i++) {
      // if length == 0, data for that day does not exist at firestore
      var dayData = results[i].docs.length == 0 ? null : results[i].docs;
      // not using 'day' field in dayData in case of non-existing record
      var day = DateFormat('EEE').format(dates[i]);
      int stepNumber = dayData == null ? 0 : dayData[2]['steps data'];
      stepsList.add(MiBandStepsData(day, stepNumber));

    }

    List<MibandHeartRateData> heartRateList = [];
    Map todayHeartRate = results.last.docs.length == 0 
    ? {} 
    : jsonDecode(results.last.docs[0]['heart rate']);

    for (Map heartRate in todayHeartRate.values) {
      DateTime parsedDateTime = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(heartRate['time']);
      heartRateList.add(MibandHeartRateData(parsedDateTime, heartRate['value']));
    }

    setState(() {
      todaySteps = stepsList.last.steps;
      stepsData = stepsList;

      heartRateData = heartRateList;
      currentBPM = (heartRateList.length == 0) ? 0 : heartRateList.last.heart_data;

      sleepDuration = results.last.docs.length == 0 
      ? 'Not Available' 
      : results.last.docs[1]['duration'];

      showAllData = true;
    });
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colours.primaryColour,
          appBar: widget.appBar ? AppBar(
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
            actions: [
              (_googleSignIn.currentUser == null) ?
              IconButton(
                icon: Icon(Icons.login),
                onPressed: _handleSignIn,
                color: Colours.secondaryColour,
                tooltip: "Google Sign In",
              )
                  :
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  handleSignOut();
                  Navigator.pop(context);
                },
                color: Colours.secondaryColour,
                tooltip: "Google Sign Out",
              )
            ],
            centerTitle: true,
            elevation: Dimensions.d_3,
          ) : PreferredSize(
                child: Container(),
                preferredSize: Size.zero,
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
                              child: charts.BarChart(
                                _getStepsData(),
                                animate: true,
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
                              _getHeartRateData(),
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
                                  changedListener: _onHeartSelectionChanged
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

  _getHeartRateData() {
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

  _getStepsData() {
    List<MiBandStepsData> stepsDataList = [...this.stepsData];
    stepsDataList.removeLast();
    return <charts.Series<MiBandStepsData, String>> [
      charts.Series(
          id: "Number_of_steps",
          data: stepsDataList,
          domainFn: (MiBandStepsData series, _) => series.day,
          measureFn: (MiBandStepsData series, _) => series.steps,
          colorFn: (MiBandStepsData series, _) => charts.MaterialPalette.blue.shadeDefault
      )
    ];
  }

  _onHeartSelectionChanged(charts.SelectionModel model) {
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

  void saveToFirebase(getAllData) {
    String uid = preferences.getString('id');
    String date = DateFormat('dd-MM-yyyy').format(DateTime.now().add(Duration(hours: 8)));
    var heartRateDic = {};

    if (getAllData){
      for (var i = 0; i < heartRateData.length; i++) {
        heartRateDic["$i"] = {
          "time": heartRateData[i].time.toString(),
          "value": heartRateData[i].heart_data
        };
      }


      _firestore.collection("mi-band").doc(uid).collection(date).doc("steps").set({
        "name": 'steps',
        "steps data": stepsData.last.steps,
        "day": stepsData.last.day
      });

      _firestore.collection("mi-band").doc(uid).collection(date).doc("heart").set({
        "name": 'heartRate',
        "heart rate": jsonEncode(heartRateDic),
      });

      _firestore.collection("mi-band").doc(uid).collection(date).doc("sleep").set({
        "name": 'sleepData',
        "duration": sleepDuration,
      });

    }
    else {
      print("did not get all data");
    }
  }

}

class MibandHeartRateData {
  final DateTime time;
  final int heart_data;

  MibandHeartRateData(this.time, this.heart_data);
}


class MiBandStepsData {
  final String day;
  final int steps;

  MiBandStepsData(this.day, this.steps);
}

