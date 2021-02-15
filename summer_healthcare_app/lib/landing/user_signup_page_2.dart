import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/landing/user_details.dart';
import 'package:summer_healthcare_app/landing/verification_page.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

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

  bool allFieldsFilled() {
    bool fieldCheck = userDetails.bmi.text.isNotEmpty &&
        userDetails.ethnicity != null &&
        userDetails.educationStatus != null &&
        userDetails.employmentStatus != null &&
        userDetails.occupation.text.isNotEmpty &&
        userDetails.maritalStatus != null &&
        userDetails.smoke != null &&
        userDetails.eCig != null &&
        userDetails.smokePerDay.text.isNotEmpty;

    return fieldCheck;
  }

  void checkAllInformationFilled({bool checkBox}) {
    if (checkBox == true || allFieldsFilled() == true)
      isButtonDisabled = false;
    else
      isButtonDisabled = true;
  }

  void popUpAlert({String title, String body, List<Widget> actions, bool canDismiss = true}) {
    showDialog<void>(
      context: context,
      barrierDismissible: canDismiss,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(body,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colours.black),
          ),
          actions: actions
        );
      },
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    final auth.PhoneVerificationCompleted verified = (auth.AuthCredential authResult) async {
    };

    final auth.PhoneVerificationFailed verificationFailed =
        (auth.FirebaseAuthException authException) {
      debugPrint('${authException.message}');
      popUpAlert(
        title: 'Notice',
        body: 'Phone Number Entered is Invalid. Please Fill in a Valid Phone Number',
        canDismiss: false,
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ]
      );
    };

    final auth.PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });

      popUpAlert(
          title: 'Notice',
          body: 'Sign Up Successful! Press OK to Proceed onto the Verification Page',
          canDismiss: false,
          actions: [
            FlatButton(
              child: Text('OK'),
              onPressed: () async {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        VerificationPage(verificationId: verificationId, userDetails: userDetails,)
                    ));
              },
            ),
          ],
      );
    };

    final auth.PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
      this.codeSent = true;
    };

    await auth.FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
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
                  Padding(
                    padding: EdgeInsets.only(top: Dimensions.d_15),
                    child: Text(
                      'Ethnicity',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  DropdownButton(
                    hint: Text('Choose An Ethnicity'),
                    isExpanded: true,
                    value: userDetails.ethnicity,
                    items: userDetails.ethnicityList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() {
                        userDetails.ethnicity = newValue;
                        checkAllInformationFilled(checkBox: userDetails
                            .termsAndConditions);
                      });
                    }),
                  Padding(
                    padding: EdgeInsets.only(top: Dimensions.d_25),
                    child: Text(
                      'Education Status',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  DropdownButton(
                    hint: Text('Choose An Education Status'),
                    isExpanded: true,
                    value: userDetails.educationStatus,
                    items: userDetails.educationList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() {
                        userDetails.educationStatus = newValue;
                        checkAllInformationFilled(checkBox: userDetails
                            .termsAndConditions);
                      });
                    }),
                  SizedBox(height: Dimensions.d_25),
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
                        flex: 50,
                        child: RadioListTile(
                            dense: true,
                            title: Text(
                              'Employed',
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
                      Flexible(
                        flex: 52,
                        child: RadioListTile(
                            dense: true,
                            title: Text(
                              'Not Employed',
                            ),
                            value: 'Not Employed',
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
                  Padding(
                    padding: EdgeInsets.only(top: Dimensions.d_15),
                    child: Text(
                      'Marital Status',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  DropdownButton(
                      hint: Text('Select A Marital Status'),
                      isExpanded: true,
                      value: userDetails.maritalStatus,
                      items: userDetails.maritalStatusList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String newValue) {
                        setState(() {
                          userDetails.maritalStatus = newValue;
                          checkAllInformationFilled(checkBox: userDetails
                              .termsAndConditions);
                        });
                      }),
                  // InputField(
                  //   hintText: 'Single/Married/Divorced/Widower',
                  //   controller: userDetails.maritalStatus,
                  //   labelText: 'Marital Status',
                  //   onChanged: (String text) {
                  //     setState(() {
                  //       checkAllInformationFilled(checkBox: userDetails
                  //           .termsAndConditions);
                  //     });
                  //   },
                  // ),
                  SizedBox(height: Dimensions.d_25),
                  Padding(
                    padding: Paddings.vertical_5,
                    child: Text(
                      'Do you smoke?',
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
                    keyboardType: TextInputType.number,
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
                      'Do you use e-cigarette?',
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
                            groupValue: userDetails.eCig,
                            onChanged: (String value) {
                              setState(() {
                                userDetails.eCig = value;
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
                            groupValue: userDetails.eCig,
                            onChanged: (String value) {
                              setState(() {
                                userDetails.eCig = value;
                                checkAllInformationFilled(
                                    checkBox: userDetails.termsAndConditions);
                              });
                            }),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dimensions.d_45,
                  ),
                  UserButton(
                    text: 'Sign Up',
                    color: Colours.secondaryColour,
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.d_45),
                    onClick: isButtonDisabled ? null : () async {
                      print(userDetails.fullName.text);
                      print(userDetails.smokePerDay.text);
                      showLoadingAnimation(context: context);
                      verifyPhone(userDetails.phoneNumber.text);
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