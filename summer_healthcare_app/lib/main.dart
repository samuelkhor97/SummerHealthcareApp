import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/home/user/navigation.dart';
import 'package:summer_healthcare_app/landing/landing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences preferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initPrefs();
  runApp(App());
}

class App extends StatelessWidget {
  bool isSignedIn() {
    auth.User firebaseUser = auth.FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colours.primaryColour,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: isSignedIn() ? UserNavigation() : LandingPage(),
    );
  }
}

Future<void> initPrefs() async {
   preferences = await SharedPreferences.getInstance();
}
