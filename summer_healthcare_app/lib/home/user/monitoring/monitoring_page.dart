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
  List<MonitoringButton> monitorButtons;
  String uid = preferences.getString('id');

  @override
  Widget build(BuildContext context) {
    if (monitorButtons == null) {
      monitorButtons = [
        MonitoringButton(
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
            color: Colours.secondaryColour,
            textColour: Colours.white,
            icon: Icons.emoji_nature_outlined,),
        MonitoringButton(
            text: 'Weight',
            onClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeightPage(
                    appBar: true,
                    uid: uid,
                    editable: true,
                  ),
                ),
              );
            },
            color: Colours.tertiaryColour,
            textColour: Colours.white,
            icon: Icons.fitness_center_outlined,),
        MonitoringButton(
            text: 'Mi-Band',
            onClick: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MiBandPage(appBar: true)));
            },
            color: Colours.quaternaryColour,
            textColour: Colours.white,
            icon: Icons.watch_outlined,)
      ];
    }
    return Scaffold(
      backgroundColor: Colours.primaryColour,
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: Dimensions.d_1,
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
