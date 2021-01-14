import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/home/user/monitoring/monitoring_page.dart';
import 'package:summer_healthcare_app/home/user/chatroom/chatlist_page.dart';
import 'package:summer_healthcare_app/home/user/diary/diary_page.dart';
import 'package:summer_healthcare_app/home/user/profile/profile_page.dart';
import 'package:summer_healthcare_app/home/user/readings/readings_page.dart';
import 'package:summer_healthcare_app/home/user/pharmacist/patientlist_page.dart';
import 'package:summer_healthcare_app/home/user/chatroom/chatroom_page.dart'
    show Role;
import 'package:summer_healthcare_app/main.dart' show preferences;
import 'package:summer_healthcare_app/services/firebase/auth_service.dart';

class UserNavigation extends StatefulWidget {
  @override
  _UserNavigationState createState() => _UserNavigationState();
}

class _UserNavigationState extends State<UserNavigation> {
  int _currentPageIndex = 0;
  List<Widget> _pages;
  final List<String> _titles = [
    'Monitoring',
    'Food Diary',
    'Readings',
    'Profile',
  ];
  String authToken;
  String id;
  String role;
  bool isPharmacist;

  final pageController = PageController();

  @override
  void initState() {
    super.initState();
    initializeUser();
    readLocal();
    isPharmacist = (role == describeEnum(Role.pharmacist));
    if (isPharmacist) {
      _titles.insert(0, 'Patients');
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    print('Disposed page controller in navigation page');
  }

  void readLocal() {
    id = preferences.getString('id');
    role = preferences.getString('role');
  }

  void initializeUser() async {
    String token = await AuthService.getToken();
    print('Auth Token: $token');
    // User user;
    // if (widget.isSLI == false) {
    //   user = await UserServices().getUser(headerToken: token);
    // } else {
    //   user = await SLIServices().getSLI(headerToken: token);
    //   status = await OnDemandServices().getOnDemandStatus(isSLI: true, headerToken: token);
    //   if (status.status != 'ongoing') {
    //     allRequests =
    //     await OnDemandServices().getAllRequests(headerToken: token);
    //     print('Got all on-demand requests ...');
    //   }
    //   print('Request: $onDemandRequests and length of ${onDemandRequests.length}');
    // }
    setState(() {
      authToken = token;
      // userDetails = user;
      // onDemandRequests = allRequests;
      // showLoadingAnimation = false;
      // onDemandStatus = status;
    });
  }

  void onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
//    if (_pages == null && userDetails != null && authToken != null) {
//      var fcm = FCM();
//      widget.isSLI ? fcm.init("sli") : fcm.init("user");
//    }
    if (_pages == null) {
      _pages = [
        MonitoringPage(),
        DiaryPage(),
        ReadingsPage(),
        ProfilePage()
      ];
      if (isPharmacist) {
        _pages.insert(0, PatientListPage());
      }
    }

    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
          icon: Icon(Icons.monitor, size: Dimensions.d_30),
          label: 'Monitoring'),
      BottomNavigationBarItem(
          icon: Icon(Icons.local_cafe_outlined, size: Dimensions.d_30),
          label: 'Diary'),
      BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_outlined, size: Dimensions.d_30),
          label: 'Readings'),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle, size: Dimensions.d_30),
        label: 'Profile',
      )
    ];

    if (isPharmacist) {
      items.insert(
        0,
        BottomNavigationBarItem(
            icon: Icon(Icons.stacked_bar_chart, size: Dimensions.d_30),
            label: 'Patients'),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colours.white,
        appBar: AppBar(
          leading: SizedBox.shrink(),
          title: Text(
            _titles[_currentPageIndex],
            style: TextStyle(
              fontSize: FontSizes.mainTitle,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colours.primaryColour,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.d_10),
              child: IconButton(
                icon: Icon(Icons.message, color: Colours.secondaryColour),
                iconSize: Dimensions.d_30,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatList(),
                      settings: RouteSettings(name: "ChatList"),
                    ),
                  );
                },
              ),
            )
          ],
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          children: _pages,
          controller: pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: (int index) {
              pageController.jumpToPage(index);
            },
            currentIndex: _currentPageIndex,
            backgroundColor: Colours.primaryColour,
            selectedItemColor: Colours.secondaryColour,
            unselectedItemColor: Colours.grey,
            items: items),
      ),
    );
  }
}
