import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:summer_healthcare_app/main.dart' show preferences;
import 'package:summer_healthcare_app/home/user/chatroom/chatlist_page.dart'
    show buildAvatar, GroupType;
import 'package:summer_healthcare_app/home/user/chatroom/chatroom_page.dart'
    show Role;
import 'package:summer_healthcare_app/home/user/pharmacist/patient_page.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';

class PatientListPage extends StatefulWidget {
  @override
  _PatientListPageState createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  final _firestore = FirebaseFirestore.instance;

  String id;
  String pharmacyGroupId;

  Stream userStream;

  TextEditingController patientMobileNumController = TextEditingController();

  @override
  void initState() {
    super.initState();
    id = preferences.getString('id');
    pharmacyGroupId = preferences.getString('pharmacyGroupId');
    userStream = _firestore
        .collection('users')
        .where('pharmacyGroupId', isEqualTo: pharmacyGroupId)
        .where(
          'role',
          isEqualTo: describeEnum(Role.normal),
        ) // exclude pharmacist from being listed
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder(
          stream: userStream,
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colours.secondaryColour),
                ),
              );
            } else {
              return (userSnapshot.data.documents.length != 0)
                  ? Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: Paddings.all_10,
                          child: Text(
                            '${userSnapshot.data.docs.length} patient(s)',
                            style: TextStyle(
                                color: Colours.secondaryColour,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (_, index) {
                              Map<String, dynamic> userDetails =
                                  userSnapshot.data.docs[index].data();
                              String userId = userDetails['id'];
                              String userName =
                                  userDetails['displayName'] ?? '';
                              String avatarUrl = userDetails['photoUrl'];
                              String pharmacyGroupId =
                                  userDetails['pharmacyGroupId'];

                              return Column(
                                children: [
                                  ListTile(
                                    contentPadding: Paddings.horizontal_10,
                                    leading: buildAvatar(
                                      groupType:
                                          describeEnum(GroupType.personal),
                                      avatarUrl: avatarUrl,
                                    ),
                                    title: Text(
                                      userName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Patient(
                                            patientId: userId,
                                            patientName: userName,
                                          ),
                                        ),
                                      );
                                    },
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.cancel_outlined,
                                      ),
                                      iconSize: Dimensions.d_30,
                                      onPressed: () {
                                        removePatientPopup(
                                            patientId: userId,
                                            pharmacyGroupId: pharmacyGroupId);
                                      },
                                    ),
                                  ),
                                  Divider(
                                    thickness: Dimensions.d_1,
                                  ),
                                ],
                              );
                            },
                            itemCount: userSnapshot.data.docs.length,
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        'No patient added into current pharmacy yet.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colours.grey,
                          fontSize: FontSizes.normalText,
                        ),
                      ),
                    );
            }
          },
        ),
        Positioned(
          bottom: Dimensions.d_10,
          right: Dimensions.d_10,
          child: FloatingActionButton(
            tooltip: 'Add New Patient',
            child: Icon(
              Icons.add,
              size: Dimensions.d_35,
            ),
            onPressed: addPatientPopup,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    patientMobileNumController.dispose();
  }

  void removePatientPopup({String patientId, String pharmacyGroupId}) {
    showDialog(
      context: context,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: Text('Notice'),
          content: Text(
            'Remove patient from pharmacy?',
            textAlign: TextAlign.left,
            style: TextStyle(color: Colours.black),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('YES'),
              onPressed: () async {
                showLoadingAnimation(context: context);
                await removePatient(
                    patientId: patientId, pharmacyGroupId: pharmacyGroupId);
                Navigator.pop(context);
                Navigator.of(alertContext).pop();
              },
            ),
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () async {
                Navigator.of(alertContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> removePatient({String patientId, String pharmacyGroupId}) async {
    var userReference = _firestore.collection('users').doc(patientId);
    var groupReference = _firestore.collection('groups').doc(pharmacyGroupId);

    await _firestore.runTransaction((transaction) async {
      transaction.update(
        userReference,
        {
          'pharmacyGroupId': '',
          'groups': FieldValue.arrayRemove([pharmacyGroupId])
        },
      );
      transaction.update(
        groupReference,
        {
          'modifiedAt': DateTime.now(),
          'members': FieldValue.arrayRemove([patientId])
        },
      );
    });
  }

  void addPatientPopup() {
    showDialog(
      context: context,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: Text('Enter Patient\'s Mobile No.'),
          content: InputField(
            controller: patientMobileNumController,
            hintText: '+60123456789',
            keyboardType: TextInputType.phone,
            autoFocus: true,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Add'),
              onPressed: () async {
                showLoadingAnimation(context: context);
                await _addPatient(
                  mobileNumber: patientMobileNumController.text ?? '',
                  pharmacyGroupId: pharmacyGroupId,
                  alertContext: alertContext,
                );
                // pop loading animation
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(alertContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addPatient(
      {String mobileNumber,
      String pharmacyGroupId,
      BuildContext alertContext}) async {
    var userSnapshot = await _firestore
        .collection('users')
        .where('mobileNumber', isEqualTo: mobileNumber)
        .get();
    if (userSnapshot.docs.length == 0) {
      Fluttertoast.showToast(msg: 'No such user.');
      return;
    }
    Map<String, dynamic> userDetails = userSnapshot.docs[0].data();
    String patientUserId = userDetails['id'];
    String patientPharmacyGroupId = userDetails['pharmacyGroupId'];

    if (patientPharmacyGroupId != null && patientPharmacyGroupId != '') {
      Fluttertoast.showToast(msg: 'Patient is already in a pharmacy group.');
      return;
    }
    var userReference = _firestore.collection('users').doc(patientUserId);
    var groupReference = _firestore.collection('groups').doc(pharmacyGroupId);

    await _firestore.runTransaction((transaction) async {
      transaction.update(
        userReference,
        {
          'pharmacyGroupId': pharmacyGroupId,
          'groups': FieldValue.arrayUnion([pharmacyGroupId])
        },
      );
      transaction.update(
        groupReference,
        {
          'modifiedAt': DateTime.now(),
          'members': FieldValue.arrayUnion([patientUserId])
        },
      );
    });
    patientMobileNumController.clear();
    Fluttertoast.showToast(msg: 'Patient added successfully.');
    Navigator.of(alertContext).pop();
  }
}
