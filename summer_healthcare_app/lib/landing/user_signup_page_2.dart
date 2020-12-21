import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/landing/user_details.dart';
import 'package:summer_healthcare_app/landing/verification_page.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';


class UserSignUpPage2 extends StatefulWidget {
  final UserDetails passUserDetails;

  const UserSignUpPage2({Key key, this.passUserDetails}) : super(key:key);

  @override
  _UserSignUpPage2State createState() => _UserSignUpPage2State();
}

class _UserSignUpPage2State extends State<UserSignUpPage2> {
  String verificationId;
  bool codeSent = false;
  UserDetails userDetails;
  bool isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    userDetails = widget.passUserDetails;
    checkAllInformationFilled(checkBox: userDetails
        .termsAndConditions);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
  
  void showSignUpSuccess() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: Text('Notice'),
          content: Text(
            'Sign Up Successful! Press OK to Proceed onto the Verification Page',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colours.black),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () async {
                Navigator.of(alertContext).pop();
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        VerificationPage(verificationId: 'example', userDetails: userDetails,)
                    ));
              },
            ),
          ],
        );
      },
    );
  }

  bool allFieldsFilled() {
    bool fieldCheck = userDetails.bmi.text.isNotEmpty &&
        userDetails.ethnicity.text.isNotEmpty &&
        userDetails.educationStatus.text.isNotEmpty &&
        userDetails.employmentStatus != null &&
        userDetails.occupation.text.isNotEmpty &&
        userDetails.maritalStatus.text.isNotEmpty &&
        userDetails.smoke != null &&
        userDetails.smokePerDay.text.isNotEmpty;

    return fieldCheck;
  }

  void checkAllInformationFilled({bool checkBox}) {
    if (checkBox == true || allFieldsFilled() == true)
      isButtonDisabled = false;
    else
      isButtonDisabled = true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colours.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Registration',
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        backgroundColor: Colours.white,
        body: ListView(
          children: <Widget>[
            Padding(
              padding: Paddings.signUpPage,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  InputField(
                    controller: userDetails.bmi,
                    labelText: 'Body Mass Index (BMI)',
                    readOnly: true,
                    onChanged: (String text) {
                      setState(() {
                        checkAllInformationFilled(checkBox: userDetails
                            .termsAndConditions);
                      });
                    },
                  ),
                  InputField(
                    hintText: 'Malay/Chinese/Indian',
                    controller: userDetails.ethnicity,
                    labelText: 'Ethnicity',
                    onChanged: (String text) {
                      setState(() {
                        checkAllInformationFilled(checkBox: userDetails
                            .termsAndConditions);
                      });
                    },
                  ),
                  InputField(
                    hintText: 'Primary/Secondary/Tertiary',
                    controller: userDetails.educationStatus,
                    labelText: 'Education status',
                    onChanged: (String text) {
                      setState(() {
                        checkAllInformationFilled(checkBox: userDetails
                            .termsAndConditions);
                      });
                    },
                  ),
                  SizedBox(height: Dimensions.d_15),
                  Padding(
                    padding: Paddings.vertical_5,
                    child: Text(
                      'Employment Status',
                      style: TextStyle(
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 22,
                        child: RadioListTile(
                            title: Text(
                              'Employed',
                            ),
                            value: 'Not employed',
                            groupValue: userDetails.employmentStatus,
                            onChanged: (String value) {
                              setState(() {
                                userDetails.employmentStatus = value;
                                checkAllInformationFilled(
                                    checkBox: userDetails.termsAndConditions);
                              });
                            }),
                      ),
                      Flexible(
                        flex: 26,
                        child: RadioListTile(
                          // dense: true,
                            title: Text(
                              'Not Employed',
                            ),
                            value: 'Employed',
                            groupValue: userDetails.employmentStatus,
                            onChanged: (String value) {
                              setState(() {
                                userDetails.employmentStatus = value;
                                checkAllInformationFilled(
                                    checkBox: userDetails.termsAndConditions);
                              });
                            }),
                      ),
                    ],
                  ),
                  InputField(
                    controller: userDetails.occupation,
                    labelText: 'Occupation',
                    onChanged: (String text) {
                      setState(() {
                        checkAllInformationFilled(checkBox: userDetails
                            .termsAndConditions);
                      });
                    },
                  ),
                  InputField(
                    hintText: 'Single/Married/Divorced/Widower',
                    controller: userDetails.maritalStatus,
                    labelText: 'Marital Status',
                    onChanged: (String text) {
                      setState(() {
                        checkAllInformationFilled(checkBox: userDetails
                            .termsAndConditions);
                      });
                    },
                  ),
                  SizedBox(height: Dimensions.d_15),
                  Padding(
                    padding: Paddings.vertical_5,
                    child: Text(
                      'Smoke or use tobacco product?',
                      style: TextStyle(
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 22,
                        child: RadioListTile(
                            title: Text(
                              'Yes',
                            ),
                            value: 'Yes',
                            groupValue: userDetails.smoke,
                            onChanged: (String value) {
                              setState(() {
                                userDetails.smoke = value;
                                checkAllInformationFilled(
                                    checkBox: userDetails.termsAndConditions);
                              });
                            }),
                      ),
                      Flexible(
                        flex: 26,
                        child: RadioListTile(
                          // dense: true,
                            title: Text(
                              'No',
                            ),
                            value: 'No',
                            groupValue: userDetails.smoke,
                            onChanged: (String value) {
                              setState(() {
                                userDetails.smoke = value;
                                checkAllInformationFilled(
                                    checkBox: userDetails.termsAndConditions);
                              });
                            }),
                      ),
                    ],
                  ),
                  InputField(
                    hintText: '5',
                    controller: userDetails.smokePerDay,
                    labelText: 'Number of cigarettes per day?',
                    onChanged: (String text) {
                      setState(() {
                        checkAllInformationFilled(checkBox: userDetails
                            .termsAndConditions);
                      });
                    },
                  ),
                  SizedBox(
                    height: Dimensions.d_45,
                  ),
                  UserButton(
                    text: 'Sign Up',
                    color: Colours.secondaryColour,
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.d_45),
                    onClick: isButtonDisabled ? null : () {
                      print(userDetails.fullName.text);
                      print(userDetails.smokePerDay.text);
                      showSignUpSuccess();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}