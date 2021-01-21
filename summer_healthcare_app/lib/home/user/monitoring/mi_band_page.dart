import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import "package:http/http.dart" as http;

import '../../../constants.dart';

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
  FirebaseAuth _auth = FirebaseAuth.instance;
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
    }
    else {
      _currentUser = _googleSignIn.currentUser;
      _getFitData();
    }
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
    // print(now.toUtc().millisecondsSinceEpoch);
    // print(DateTime(now.year, now.month, now.day).toUtc().millisecondsSinceEpoch);
    var body = jsonEncode({
      "aggregateBy": [
        {
          "dataTypeName": "com.google.step_count.delta",
          "dataSourceId":
              "derived:com.google.step_count.delta:com.google.android.gms:estimated_steps"
        }
      ],
      "bucketByTime": {"durationMillis": 86400000},
      "startTimeMillis": DateTime(now.year, now.month, now.day - 7).toUtc().millisecondsSinceEpoch,
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
    // The integer after bucket is subject to change, to get today's step value, then it's 7
    print(output["bucket"][7]["dataset"][0]["point"][0]["value"][0]["intVal"]);
    setState(() {
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
                    child: ListTile(
                      leading: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Steps Today:',
                            style: TextStyle(
                              fontSize: FontSizes.biggerText
                            ),
                          ),
                          Text(
                            '$todaySteps',
                            style: TextStyle(
                              fontSize: FontSizes.biggerText,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: Dimensions.d_10),
                          Text(
                            'Distance: ${(todaySteps/1312.33595801).toStringAsFixed(2)} KM',
                            style: TextStyle(
                                fontSize: FontSizes.smallText
                            ),
                          )
                        ],
                      ),
                      trailing: Icon(
                        Icons.directions_run,
                        color: Colours.secondaryColour,
                        size: Dimensions.d_50,
                      ),
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(
              //       top: Dimensions.d_15,
              //       left: Dimensions.d_15,
              //       right: Dimensions.d_15),
              //   child: Card(
              //     clipBehavior: Clip.antiAlias,
              //     elevation: 5,
              //     child: Padding(
              //       padding: EdgeInsets.all(Dimensions.d_15),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           ListTile(
              //             leading: Column(
              //               children: <Widget>[
              //                 Text(
              //                   'Last Night Sleep Hours:',
              //                   style: TextStyle(
              //                       fontSize: FontSizes.biggerText
              //                   ),
              //                 ),
              //                 Text(
              //                   '8h 32min',
              //                   style: TextStyle(
              //                       fontSize: FontSizes.biggerText,
              //                       fontWeight: FontWeight.bold
              //                   ),
              //                 ),
              //                 Text(
              //                   'Deep sleep: 2h 20min',
              //                   style: TextStyle(
              //                       fontSize: FontSizes.smallText
              //                   ),
              //                 ),
              //                 Text(
              //                   'Light sleep: 6h 12min',
              //                   style: TextStyle(
              //                       fontSize: FontSizes.smallText
              //                   ),
              //                 ),
              //                 Text(
              //                   'Awake: 0min',
              //                   style: TextStyle(
              //                       fontSize: FontSizes.smallText
              //                   ),
              //                 ),
              //               ],
              //             ),
              //             trailing: Icon(
              //               Icons.king_bed_rounded,
              //               color: Colours.secondaryColour,
              //               size: Dimensions.d_50,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // )
            ],
          )),
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
  Future<void> _handleSignOut() => _googleSignIn.disconnect();
}

// Column(
// children: <Widget>[
// ElevatedButton(
// child: const Text('SIGN IN'),
// onPressed: _handleSignIn,
// )
// ],
// ),