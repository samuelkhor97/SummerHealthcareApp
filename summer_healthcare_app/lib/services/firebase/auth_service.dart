import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart' as store;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summer_healthcare_app/home/user/navigation.dart';
import 'package:summer_healthcare_app/landing/landing_page.dart';
import 'package:summer_healthcare_app/landing/user_details.dart';

class AuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final store.FirebaseFirestore _firestore = store.FirebaseFirestore.instance;

  //Sign out
  signOut({BuildContext context}) async {
    await _auth.signOut();
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.clear();
    // print('preference now isSLI after logout: ${preferences.containsKey('isSLI')}');
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LandingPage()),
    );
  }

  //Sign out and Delete existing account
//  deleteAndSignOut({BuildContext context}) async {
//    auth.User currentUser = _auth.currentUser;
//    if (currentUser != null) {
//      String authTokenString = await currentUser.getIdToken();
//
//      // delete user from database
//      SharedPreferences preferences = await SharedPreferences.getInstance();
//      if (preferences.getBool('isSLI') == false)
//        await UserServices().deleteUser(headerToken: authTokenString, phoneNumber: currentUser.phoneNumber);
//      else
//        await SLIServices().deleteSLI(headerToken: authTokenString, phoneNumber: currentUser.phoneNumber);
//    }
//    signOut(context: context);
//  }

  //SignIn
  signIn(BuildContext context, auth.AuthCredential authCreds) {
    _auth.signInWithCredential(authCreds).catchError((error) {
      print("Error caught signing in");
    }).then((user) {
      user.user.getIdToken().then((tokenResult) {
      });
      if (user != null) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserNavigation()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LandingPage()),
        );
      }
    });
  }

  Future<String> signInWithOTP(
      {BuildContext context,
        UserDetails userDetails,
        String smsCode,
        String verId}) async {
    String token;
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      auth.AuthCredential authCreds = auth.PhoneAuthProvider.credential(
          verificationId: verId, smsCode: smsCode);

      // getting auth result after signing in with credentials
      auth.UserCredential authResult = await _auth.signInWithCredential(
          authCreds);

      // getting the authentication token from current firebase user state
      String authTokenString =
      await authResult.user.getIdToken();
      token = authTokenString;

      auth.User firebaseUser = authResult.user;
      if (firebaseUser != null) {
        // Check if user already in firestore
        final store.QuerySnapshot result = await _firestore.collection('users').where('id', isEqualTo: firebaseUser.uid).get();
        final List<store.DocumentSnapshot> documents = result.docs;
        if (documents.length == 0) {
          // Update data to firestore if new user
          _firestore.collection('users').doc(firebaseUser.uid).set({
            'displayName': firebaseUser.displayName,
            'photoUrl': firebaseUser.photoURL,
            'role': 'normal', // will be modified accordingly after pharmacist signup implemented
            'id': firebaseUser.uid,
            'createdAt': store.FieldValue.serverTimestamp(),
            'groupId': null
          });

          await preferences.setString('id', firebaseUser.uid);
          await preferences.setString('displayName', firebaseUser.displayName);
          await preferences.setString('photoUrl', firebaseUser.photoURL);
          await preferences.setString('role', 'normal');
          await preferences.setString('groupId', null);
        } else {
          await preferences.setString('id', documents[0].data()['id']);
          await preferences.setString('displayName', documents[0].data()['displayName']);
          await preferences.setString('photoUrl', documents[0].data()['photoUrl']);
          await preferences.setString('role', documents[0].data()['role']);
          await preferences.setString('groupId', documents[0].data()['groupId']);
        }
        if (token != null) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserNavigation()),
          );
        }
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LandingPage()),
        );
      }

    } catch (e) {
      debugPrint("Error on Sign-in");
    }
    return token;
  }

  static Future<String> getToken() async {
    auth.User user = auth.FirebaseAuth.instance.currentUser;
    String token = '';
    if (user != null) {
      token = await user.getIdToken();
    }
    return token;
  }
}
