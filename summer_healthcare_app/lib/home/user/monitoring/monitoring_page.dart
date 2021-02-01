import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/home/user/monitoring/sugar_level_page.dart';
import 'package:summer_healthcare_app/home/user/monitoring/mi_band_page.dart';
import 'package:summer_healthcare_app/home/user/monitoring/weight_page.dart';
import 'package:summer_healthcare_app/main.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';

class MonitoringPage extends StatefulWidget {
  @override
  _MonitoringPageState createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  List<UserOutlinedButton> monitorButtons;
  String uid = preferences.getString('id');

  @override
  Widget build(BuildContext context) {
    if (monitorButtons == null) {
      monitorButtons = [
        UserOutlinedButton(
            text: 'Sugar Level',
            onClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SugarLevelPage(
                    uid: uid,
                    appBar: true,
                    editable: true,
                  ),
                ),
              );
            },
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.d_30, vertical: Dimensions.d_20),
            color: Colours.primaryColour,
            textColour: Colours.secondaryColour,
            outlineColor: Colours.secondaryColour,
            height: Dimensions.d_100,
            foregroundColor: Colours.secondaryColour,
            buttonRadius: BorderRadius.circular(Dimensions.d_10)),
        UserOutlinedButton(
            text: 'Weight',
            onClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeightPage(
                    appBar: true,
                    uid: uid,
                  ),
                ),
              );
            },
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.d_30, vertical: Dimensions.d_20),
            color: Colours.primaryColour,
            textColour: Colours.secondaryColour,
            outlineColor: Colours.secondaryColour,
            height: Dimensions.d_100,
            foregroundColor: Colours.secondaryColour,
            buttonRadius: BorderRadius.circular(Dimensions.d_10)),
        UserOutlinedButton(
            text: 'Mi-Band',
            onClick: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MiBandPage()));
            },
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.d_30, vertical: Dimensions.d_20),
            color: Colours.primaryColour,
            textColour: Colours.secondaryColour,
            outlineColor: Colours.secondaryColour,
            height: Dimensions.d_100,
            foregroundColor: Colours.secondaryColour,
            buttonRadius: BorderRadius.circular(Dimensions.d_10))
      ];
    }
    return Scaffold(
      backgroundColor: Colours.primaryColour,
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: Dimensions.d_10,
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: this.monitorButtons.length,
            itemBuilder: (BuildContext context, int index) {
              return this.monitorButtons[index];
            },
          )
        ],
      ),
    );
  }
}
