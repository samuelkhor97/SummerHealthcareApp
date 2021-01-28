import 'package:flutter/material.dart';

import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/json/user.dart';
import 'package:summer_healthcare_app/services/api/user_services.dart';
import 'package:summer_healthcare_app/main.dart' show preferences;
import 'package:summer_healthcare_app/services/firebase/auth_service.dart';

class UserDetailsPage extends StatefulWidget {
  final String patientUserId;
  final bool appBar;
  final bool pharmacistView;

  UserDetailsPage(
      {this.patientUserId, this.appBar = false, this.pharmacistView = false});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  String myUserId;
  String patientUserId;
  Future<User> userDetails;

  @override
  void initState() {
    super.initState();
    myUserId = preferences.getString('id');
    patientUserId = widget.patientUserId;
    userDetails = getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: widget.appBar
            ? AppBar(
                leading: SizedBox.shrink(),
                title: Text(
                  widget.pharmacistView
                      ? 'Patient\'s Details'
                      : 'User\'s Details',
                  style: TextStyle(
                    fontSize: FontSizes.mainTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colours.primaryColour,
              )
            : PreferredSize(
                child: Container(),
                preferredSize: Size.zero,
              ),
        body: FutureBuilder(
          future: userDetails,
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  // TODO: ensure synchronization of user details (between fireauth,
                  // firestore and backend database) after enabling some fields for edit by user themselves
                  buildInputField(
                    readOnly: true,
                    labelText: 'Full Name',
                    valueText: snapshot.data.fullName,
                  ),
                  buildInputField(
                    readOnly: true,
                    labelText: 'Mobile Phone Number',
                    valueText: snapshot.data.phoneNum,
                  ),
                  buildInputField(
                    readOnly: true,
                    labelText: 'Weight (kg)',
                    valueText: snapshot.data.weight,
                  ),
                  buildInputField(
                    readOnly: true,
                    labelText: 'Height (cm)',
                    valueText: snapshot.data.height,
                  ),
                  buildInputField(
                    readOnly: true,
                    labelText: 'Age',
                    valueText: snapshot.data.age?.toString() ?? '',
                  ),
                  buildInputField(
                    readOnly: true,
                    labelText: 'Gender',
                    valueText: snapshot.data.gender,
                  ),
                  buildInputField(
                    readOnly: true,
                    labelText: 'Body Mass Index (BMI)',
                    valueText: calcBMI(
                      height: int.parse(snapshot.data.height),
                      weight: int.parse(snapshot.data.weight),
                    ),
                  ),
                  buildInputField(
                    readOnly: true,
                    labelText: 'Ethnicity',
                    valueText: snapshot.data.ethnicity,
                  ),
                  buildInputField(
                    readOnly: true,
                    labelText: 'Education status',
                    valueText: snapshot.data.educationStatus,
                  ),
                  buildInputField(
                    readOnly: true,
                    labelText: 'Employment Status',
                    valueText: snapshot.data.employmentStatus,
                  ),
                  buildInputField(
                    readOnly: true,
                    labelText: 'Occupation',
                    valueText: snapshot.data.occupation,
                  ),
                  buildInputField(
                    readOnly: true,
                    labelText: 'Marital Status',
                    valueText: snapshot.data.maritalStatus,
                  ),
                  buildInputField(
                    readOnly: true,
                    labelText: 'Smoker?',
                    valueText: snapshot.data.smoker?.toString() ?? '',
                  ),
                  buildInputField(
                    readOnly: true,
                    labelText: 'Number of Cigarettes per Day',
                    valueText: snapshot.data.cigsPerDay?.toString() ?? '',
                  ),
                  buildInputField(
                    readOnly: true,
                    labelText: 'Using e-Cigarette?',
                    valueText: snapshot.data.eCig?.toString() ?? '',
                  ),
                  buildInputField(
                    readOnly: widget.pharmacistView ? false : true,
                    labelText: 'Body Fat Percentage (%)',
                    valueText: snapshot.data.eCig?.toString() ?? '',
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colours.secondaryColour),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<User> getUserDetails() async {
    String authToken = await AuthService.getToken();
    Future<User> retVal = UserServices()
        .getUserById(headerToken: authToken, userId: patientUserId);
    return retVal;
  }
}

Padding buildInputField({String labelText, String valueText, bool readOnly}) {
  return Padding(
    padding: Paddings.vertical_15,
    child: TextFormField(
      readOnly: readOnly,
      initialValue: valueText,
      decoration: InputDecoration(
        contentPadding: Paddings.horizontal_5,
        labelText: labelText,
        labelStyle: TextStyle(color: Colours.grey),
      ),
    ),
  );
}

String calcBMI({int weight, int height}) {
  double bmiValue = weight / ((height / 100) * (height / 100));
  String bmiString = bmiValue.toStringAsFixed(1);

  return bmiString;
}
