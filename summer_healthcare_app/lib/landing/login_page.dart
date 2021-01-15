import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/landing/verification_page.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:summer_healthcare_app/landing/user_details.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String verificationId;
  bool codeSent = false;
  UserDetails userDetails;
  bool isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    userDetails = UserDetails();
  }

  @override
  void dispose() {
    super.dispose();
    userDetails.disposeTexts();
    print('Disposed text editor in login page');
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colours.white,
          body: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Padding(
                  padding: Paddings.startupMain,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: Dimensions.d_140,
                        child: Hero(
                          tag: 'appLogo',
                          child: Image(
                            image: AssetImage('images/medical_logo_new.png'),
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.d_45),
                      InputField(
                        hintText: '+60123456789',
                        controller: userDetails.phoneNumber,
                        labelText: 'Mobile Phone Number',
                        keyboardType: TextInputType.phone,
                        onChanged: (text) {
                          if (userDetails.phoneNumber.text.isNotEmpty) {
                            isButtonDisabled = false;
                          }
                          else {
                            isButtonDisabled = true;
                          }
                          setState(() {});
                        },
                      ),
                      SizedBox(height: Dimensions.d_55),
                      UserButton(
                        text: 'Login',
                        color: Colours.secondaryColour,
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.d_45),
                        onClick: isButtonDisabled ? null : () async {
                          showLoadingAnimation(context: context);
                          await verifyPhone(userDetails.phoneNumber.text);
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

  void pushVerificationPage() {
    userDetails.setIsLogin(isLogin: true);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            VerificationPage(verificationId: this.verificationId, userDetails: userDetails)
        ));
  }

  Future<void> verifyPhone(phoneNo) async {
    final auth.PhoneVerificationCompleted verified = (auth.AuthCredential authResult) {
    };

    final auth.PhoneVerificationFailed verificationFailed =
        (auth.FirebaseAuthException authException) {
      debugPrint('${authException.message}');
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext alertContext) {
          return AlertDialog(
            title: Text('Notice'),
            content: Text(
              'The Phone Number Entered is Invalid. Please Try Again.',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colours.black),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    };

    final auth.PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
      pushVerificationPage();
    };

    final auth.PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
      this.codeSent = true;
    };

    await auth.FirebaseAuth.instance.verifyPhoneNumber (
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout
    );
  }
}
