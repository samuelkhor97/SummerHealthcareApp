import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';

import 'package:summer_healthcare_app/home/user/monitoring/mi_band_page.dart';
import 'package:summer_healthcare_app/home/user/monitoring/sugar_level_page.dart';
import 'package:summer_healthcare_app/home/user/monitoring/weight_page.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';

class PatientMonitoring extends StatefulWidget {
  final String uid;

  PatientMonitoring({@required this.uid});

  @override
  _PatientMonitoringState createState() => _PatientMonitoringState();
}

class _PatientMonitoringState extends State<PatientMonitoring> with AutomaticKeepAliveClientMixin<PatientMonitoring> {
  int _currentPageIndex = 0;

  List<Widget> _pages;

  final List<String> _titles = [
    'Sugar Level',
    'Weight',
    'Activities',
  ];

  final pageController = PageController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _pages = [
      SugarLevelPage(uid: widget.uid, appBar: false, editable: false),
      WeightPage(appBar: false, uid: widget.uid, editable: false),
      MiBandPage(appBar: false, uid: widget.uid),
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _titles[_currentPageIndex],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: FontSizes.biggerText,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: PageView(
            scrollDirection: Axis.horizontal,
            children: _pages,
            controller: pageController,
            onPageChanged: onPageChanged,
          ),
        ),
        Container(
          margin: EdgeInsets.all(Dimensions.d_2),
          child: DotIndicators(
            count: _pages.length,
            selectedIndex: _currentPageIndex,
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }
}
