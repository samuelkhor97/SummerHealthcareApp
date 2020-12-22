import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/services/firebase/auth_service.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  void logoutPopUpAlert() {
    showDialog<void>(
      context: context,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: Text('Notice'),
          content: Text(
            'Are You Sure You Want to Log Out?',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colours.black),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('YES'),
              onPressed: () async {
                showLoadingAnimation(context: context);
                await AuthService().signOut(context: context);
              },
            ),
            FlatButton(
              child: Text('NO'),
              onPressed: () async {
                Navigator.of(alertContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: UserButton(
          text: 'Log Out',
          color: Colours.secondaryColour,
          padding: EdgeInsets.symmetric(horizontal: Dimensions.d_65),
          onClick: () async {
            logoutPopUpAlert();
          }
        ),
      ),
    );
  }
}
