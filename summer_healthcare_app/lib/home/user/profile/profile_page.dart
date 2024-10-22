import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/home/user/profile/user_details_page.dart';
import 'package:summer_healthcare_app/services/api/user_services.dart';
import 'package:summer_healthcare_app/services/firebase/auth_service.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';
import 'package:summer_healthcare_app/main.dart' show preferences;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String id;
  String fullName;
  String photoUrl;

  bool updatePressed = false;

  final TextEditingController fullNameController = TextEditingController();

  final FocusNode fullNameFocusNode = FocusNode();

  final _firestore = FirebaseFirestore.instance;
  final _firestorage = FirebaseStorage.instance;

  void logoutPopUpAlert() {
    showDialog<void>(
      context: context,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: Text('Notice'),
          content: Text(
            'Are You Sure You Want to Log Out?',
            textAlign: TextAlign.left,
            style: TextStyle(color: Colours.black),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('YES'),
              onPressed: () async {
                showLoadingAnimation(context: context);
                await AuthService().signOut(context: context);
              },
            ),
            FlatButton(
              child: Text('NO'),
              onPressed: () async {
                Navigator.of(alertContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      buildAvatar(),
      buildInputFields(title: 'Display Name', hintText: 'Jack'),
      Container(
        padding: Paddings.all_10,
        child: UserButton(
          text: 'View User Details',
          color: Colours.secondaryColour,
          padding: EdgeInsets.symmetric(horizontal: Dimensions.d_65),
          onClick: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserDetailsPage(
                  patientUserId: id,
                  appBar: true,
                  pharmacistView: false,
                ),
              ),
            );
          },
        ),
      ),
      Container(
        padding: Paddings.all_10,
        child: UserButton(
          text: 'Update',
          color: Colours.secondaryColour,
          padding: EdgeInsets.symmetric(horizontal: Dimensions.d_65),
          onClick: () {
            updateData(context: context);
          },
        ),
      ),
      Container(
        padding: Paddings.all_10,
        child: UserButton(
            text: 'Log Out',
            color: Colours.secondaryColour,
            padding: EdgeInsets.symmetric(horizontal: Dimensions.d_65),
            onClick: () async {
              logoutPopUpAlert();
            }),
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
    fullNameFocusNode.dispose();
    print('Disposed text editor and focus node in profile page');
  }

  void readLocal() {
    // Force refresh avatar image and text field
    setState(() {
      id = preferences.getString('id') ?? '';
      fullName = preferences.getString('fullName') ?? '';
      photoUrl = preferences.getString('photoUrl') ?? '';
      fullNameController.text = fullName;
    });
  }

  Container buildAvatar() {
    return Container(
      child: Center(
        child: Stack(
          children: <Widget>[
            photoUrl == null || photoUrl == ''
                ? Icon(
                    Icons.account_circle,
                    size: Dimensions.d_95,
                    color: Colours.grey,
                  )
                : Material(
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colours.secondaryColour),
                        ),
                        width: Dimensions.d_95,
                        height: Dimensions.d_95,
                        padding: Paddings.all_10,
                      ),
                      errorWidget: (context, url, error) => Material(
                        child: Image.asset(
                          'images/img_not_available.jpeg',
                          width: Dimensions.d_95,
                          height: Dimensions.d_95,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BordersRadius.chatImage,
                        clipBehavior: Clip.hardEdge,
                      ),
                      imageUrl: photoUrl,
                      width: Dimensions.d_95,
                      height: Dimensions.d_95,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BordersRadius.profileAvatar,
                    clipBehavior: Clip.hardEdge,
                  ),
            IconButton(
              icon: Icon(
                Icons.camera_alt,
                color: Colours.secondaryColour.withOpacity(0.5),
              ),
              onPressed: getImage,
              padding: EdgeInsets.all(30.0),
              splashColor: Colors.transparent,
              highlightColor: Colours.grey,
              iconSize: Dimensions.d_30,
            ),
          ],
        ),
      ),
      width: double.infinity,
      margin: EdgeInsets.all(20.0),
    );
  }

  Container buildInputFields({String title, String hintText}) {
    return Container(
      margin: Paddings.all_10,
      child: Container(
        child: InputField(
          labelText: title,
          hintText: hintText,
          controller: fullNameController,
          focusNode: fullNameFocusNode,
        ),
      ),
    );
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String fileName = 'images/users/$id/avatars/${DateTime.now().toString()}';

      File imageFile = File(pickedFile.path);
      showLoadingAnimation(context: context);
      await updateAvatar(file: imageFile, fileName: fileName);
      Navigator.pop(context);
    }
  }

  Future updateAvatar({File file, String fileName}) async {
    StorageReference reference = _firestorage.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(file);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) async {
      await _firestore
          .collection('users')
          .doc(id)
          .update({'photoUrl': downloadUrl});
      await preferences.setString('photoUrl', downloadUrl);

      setState(() {
        photoUrl = downloadUrl;
      });
    }, onError: (err) {
      Fluttertoast.showToast(msg: 'Avatar update failed.');
    });
  }

  void updateData({BuildContext context}) {
    fullNameFocusNode.unfocus();
    showLoadingAnimation(context: context);

    _firestore
        .collection('users')
        .doc(id)
        .update({'fullName': fullNameController.text}).then((data) async {
      fullName = fullNameController.text;

      String authToken = await AuthService.getToken();
      await UserServices.updateUserById(
          headerToken: authToken,
          userId: id,
          updateValues: {'full_name': fullName});
      await preferences.setString('fullName', fullName);

      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Update success');
    }).catchError((err) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: err.toString());
    });
  }
}
