import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';
import "package:http/http.dart" as http;

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
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _getFitData();
      }
    });
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
    var body = jsonEncode({
      "aggregateBy": [{
        "dataTypeName": "com.google.step_count.delta",
        "dataSourceId": "derived:com.google.step_count.delta:com.google.android.gms:estimated_steps"
      }],
      "bucketByTime": { "durationMillis": 86400000 },
      "startTimeMillis": 1609430400000,
      "endTimeMillis": 1610812800000
    });

    GoogleSignInAuthentication googlesigninauthentication = await _currentUser.authentication;
    var response = await http
        .post('https://www.googleapis.com/fitness/v1/users/me/dataset:aggregate',
        headers: {'authorization': 'Bearer ' + googlesigninauthentication.accessToken},
        body: body
        );
    var output = jsonDecode(response.body);
    print(output["bucket"][5]);
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
        body: Column(
          children: <Widget>[
            ElevatedButton(
              child: const Text('SIGN IN'),
              onPressed: _handleSignIn,
            )
          ],
        ),
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
  Future<void> _handleSignOut() => _googleSignIn.disconnect();
}