import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/landing/user_details.dart';
import 'package:summer_healthcare_app/services/firebase/auth_service.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationPage extends StatefulWidget {
  final String verificationId;
  final UserDetails userDetails;
  VerificationPage({Key key, @required this.verificationId, this.userDetails})
      : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  TextEditingController verificationNumberController = TextEditingController();
  bool isButtonDisabled = true;

  @override
  void dispose() {
    super.dispose();
    verificationNumberController.dispose();
    print('Disposed text editor on verification page');
  }

  void showSmsCodeError() {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext alertContext) {
          return AlertDialog(
            title: Text('Notice'),
            content: Text(
              'The OTP You Entered is Invalid. Please Try Again.',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colours.black),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () async {
                  Navigator.of(alertContext).pop();
                },
              ),
            ],
          );
        },
    );
  }

  void showWrongLoginError() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text(
            'Account Does Not Exist. Please Try Signing Up First.',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colours.black),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(alertContext).pop();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colours.white,
            appBar: AppBar(
              backgroundColor: Colours.white,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                'Account Verification',
              ),
              centerTitle: true,
              elevation: 0.0,
            ),
            body: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Padding(
                    padding: Paddings.signUpPage,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: Dimensions.d_65),
                        Text(
                          'Please Enter the OTP You Received Here',
                          style: TextStyle(fontSize: FontSizes.buttonText),
                        ),
                        InputField(
                          controller: verificationNumberController,
                          labelText: 'Your OTP',
                          keyboardType: TextInputType.phone,
                          isShortInput: true,
                          isPassword: true,
                          onChanged: (String text) {
                            setState(() {
                              if (verificationNumberController.text.length == 6)
                                isButtonDisabled = false;
                              else
                                isButtonDisabled = true;
                            });
                          },
                        ),
                        UserButton(
                          text: 'Verify',
                          color: Colours.secondaryColour,
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.d_65, vertical: Dimensions.d_20),
                          onClick: isButtonDisabled ? null : () async {
                            showLoadingAnimation(context: context);
                            String token = await AuthService().signInWithOTP(
                                context: context,
                                userDetails: widget.userDetails,
                                smsCode: verificationNumberController.text,
                                verId: widget.verificationId);
                            if (token != null) {
                              if (token == 'wrongLogin') {
                                Navigator.pop(context);
                                showWrongLoginError();
                              }
                              else {
                                // set shared preference
                                SharedPreferences preferences = await SharedPreferences
                                    .getInstance();
                                preferences.setBool('isSLI',
                                    widget.userDetails.isPharmacist);
                                widget.userDetails.disposeTexts();
                              }
                            }
                            else {
                              Navigator.pop(context);
                              showSmsCodeError();
                            }
                          },
                        ),
                      ],
                    )),
              ],
            )));
  }
}
