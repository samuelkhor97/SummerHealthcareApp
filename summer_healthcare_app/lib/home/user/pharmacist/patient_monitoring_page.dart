import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';

import 'package:summer_healthcare_app/home/user/monitoring/mi_band_page.dart';
import 'package:summer_healthcare_app/home/user/monitoring/sugar_level_page.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';

class PatientMonitoring extends StatefulWidget {
  @override
  _PatientMonitoringState createState() => _PatientMonitoringState();
}

class _PatientMonitoringState extends State<PatientMonitoring> {
  int _currentPageIndex = 0;

  final List<Widget> _pages = [
    SugarLevelPage(),
    Container(),
    MiBandPage(),
  ];

  final List<String> _titles = [
    'Sugar Level',
    'Weight',
    'Activities',
  ];

  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
