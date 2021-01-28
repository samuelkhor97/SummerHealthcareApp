import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/home/user/pharmacist/patient_monitoring_page.dart';
import 'package:summer_healthcare_app/home/user/profile/user_details_page.dart';
import 'package:summer_healthcare_app/home/user/chatroom/chatroom_page.dart'
    show Role;
import 'package:summer_healthcare_app/main.dart' show preferences;

class Patient extends StatefulWidget {
  final String patientId;
  final String patientName;

  Patient({this.patientId, this.patientName});

  @override
  _PatientState createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  final Map<int, Widget> segmentedChildren = {
    0: Container(
      child: Text("Details"),
      padding: Paddings.all_10,
    ),
    1: Container(
      child: Text("Monitoring"),
      padding: Paddings.all_10,
    ),
  };

  List<Widget> _pages;
  String role;
  bool isPharmacist;

  final pageController = PageController();

  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    role = preferences.getString('role');
    isPharmacist = (role == describeEnum(Role.pharmacist));
    _pages = [
      UserDetailsPage(patientUserId: widget.patientId, pharmacistView: isPharmacist),
      PatientMonitoring(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                color: Colours.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: Text(
              widget.patientName,
              style: TextStyle(
                color: Colours.black,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          body: Column(
            children: [
              CupertinoSegmentedControl(
                children: segmentedChildren,
                groupValue: _currentPageIndex,
                onValueChanged: (newPageIndex) {
                  setState(() {
                    _currentPageIndex = newPageIndex;
                  });
                  pageController.jumpToPage(_currentPageIndex);
                },
                padding: Paddings.all_10,
              ),
              Expanded(
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  children: _pages,
                  controller: pageController,
                ),
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
}
