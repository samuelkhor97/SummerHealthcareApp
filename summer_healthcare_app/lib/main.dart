import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/home/user/navigation.dart';
import 'package:summer_healthcare_app/json/user.dart';
import 'package:summer_healthcare_app/landing/landing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summer_healthcare_app/services/api/user_services.dart';

SharedPreferences preferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initPrefs();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool signedIn;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    auth.User firebaseUser = auth.FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      String token = await firebaseUser.getIdToken();
      User user;
      // user = await SLIServices().getSLI(headerToken: token);
      if (user == null) {
        user = await UserServices().getUser(headerToken: token);
      }
      if (user != null) {
        if (!preferences.containsKey('isPharmacist')) {
          bool isSLI = user.eCig == null ? true : false;
          preferences.setBool('isPharmacist', isSLI);
        }
        signedIn = true;
      }
      else {
        signedIn = false;
        await auth.FirebaseAuth.instance.signOut();
      }
    }
    else {
      signedIn = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colours.primaryColour,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: signedIn == null ? Container() : signedIn ? UserNavigation() : LandingPage(),
    );
  }
}

Future<void> initPrefs() async {
   preferences = await SharedPreferences.getInstance();
}
