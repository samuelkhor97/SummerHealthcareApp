import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/home/user/monitoring/graph_page.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';

class SugarLevelPage extends StatefulWidget {
  final String uid;
  final bool appBar;
  final bool editable;

  SugarLevelPage({@required this.uid, @required this.appBar, @required this.editable});

  @override
  _SugarLevelPageState createState() => _SugarLevelPageState();
}

class _SugarLevelPageState extends State<SugarLevelPage> {
  List<SugarList> sugarLevelList;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    if (sugarLevelList == null) {
      sugarLevelList = [
        SugarList(
          readings: 7,
          day: 'SAT',
          date: '5/12/20',
          editable: widget.editable,
        ),
        SugarList(
          readings: 8.9,
          day: 'SUN',
          date: '6/12/20',
          editable: widget.editable,
        ),
      ];
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colours.primaryColour,
        appBar: widget.appBar
            ? AppBar(
                backgroundColor: Colours.primaryColour,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text(
                  'Sugar Level',
                ),
                centerTitle: true,
                elevation: Dimensions.d_3,
              )
            : PreferredSize(
                child: Container(),
                preferredSize: Size.zero,
              ),
        body: ListView(
          children: <Widget>[
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: this.sugarLevelList.length,
              itemBuilder: (BuildContext context, int index) {
                return this.sugarLevelList[index];
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          // mini: true,
          tooltip: 'Monitoring Summary',
          child: Icon(
            Icons.stacked_bar_chart,
            size: Dimensions.d_35,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GraphPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
