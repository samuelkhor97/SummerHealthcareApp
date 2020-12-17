import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/landing/user_signup_page_1.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';
import 'package:summer_healthcare_app/landing/login_page.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colours.white,
        body: ListView(
          children: <Widget>[
            Padding(
              padding: Paddings.startupMain,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: Paddings.vertical_15,
                    height: Dimensions.d_200,
                    child: Hero(
                      tag: 'appLogo',
                      child: Image(
                        image: AssetImage('images/medical_logo_new.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.d_15,
                  ),
                  UserButton(
                    text: 'Login',
                    textColour: Colours.black,
                    height: Dimensions.d_65,
                    color: Colours.lightGrey,
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                  SizedBox(
                    height: Dimensions.d_5,
                  ),
                  Padding(
                    padding: EdgeInsets.all(Dimensions.d_10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Divider(
                            color: Colours.grey,
                            thickness: Dimensions.d_1,
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Text(
                            'New User? Sign Up Now!',
                            style: TextStyle(
                              color: Colours.black,
                              fontWeight: FontWeight.w500
                            ),
                            textAlign: TextAlign.center ,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colours.grey,
                            thickness: Dimensions.d_1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.d_5,
                  ),
                  UserButton(
                    text: 'Sign Up As User',
                    height: Dimensions.buttonHeight,
                    color: Colours.secondaryColour,
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.d_5),
                    onClick: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              UserSignUpPage1()
                          ));
                    },
                  ),
                  UserButton(
                    text: 'Sign Up As Pharmacist',
                    height: Dimensions.buttonHeight,
                    color: Colours.tertiaryColour,
                    onClick: () {
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
