import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/home/user/chatroom/full_photo.dart'
    show FullPhoto;
import 'package:summer_healthcare_app/home/user/chatroom/chatlist_page.dart'
    show GroupType, buildAvatar;
import 'package:summer_healthcare_app/home/user/chatroom/chatroom_page.dart'
    show ChatRoom, Role, getPersonalGroupDetails;
import 'package:summer_healthcare_app/widgets/widgets.dart';

class GroupInfo extends StatefulWidget {
  final String id;
  final String groupId;
  final Function setGroupNameCallback;
  final Function getGroupDetailsCallback;

  GroupInfo(
      {this.id,
      this.groupId,
      this.setGroupNameCallback,
      this.getGroupDetailsCallback});

  @override
  _GroupInfoState createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  final _firestore = FirebaseFirestore.instance;
  final _firestorage = FirebaseStorage.instance;

  String id;
  String myRole;
  String groupId;
  String groupName;
  String photoUrl;

  Stream userStream;

  Map<String, dynamic> groupDetails;

  Function setGroupNameCallback;
  Function getGroupDetailsCallback;

  TextEditingController groupNameController;

  @override
  void initState() {
    super.initState();

    id = widget.id;
    groupId = widget.groupId;
    groupDetails = widget.getGroupDetailsCallback(groupId: groupId);

    myRole = groupDetails['members'][id]['role'];
    groupId = groupDetails['id'];
    groupName = groupDetails['name'];
    photoUrl = groupDetails['photoUrl'];
    setGroupNameCallback = widget.setGroupNameCallback;
    getGroupDetailsCallback = widget.getGroupDetailsCallback;

    groupNameController = TextEditingController(text: groupName);

    userStream = _firestore
        .collection('users')
        .where('groups', arrayContains: groupId)
        .snapshots();
  }

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colours.secondaryColour,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text(
            groupName,
            style: TextStyle(
              color: Colours.secondaryColour,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: photoUrl == null || photoUrl == ''
                        ? Container(
                            color: Colours.midGrey,
                            child: Icon(
                              Icons.group_rounded,
                              size: Dimensions.d_200,
                              color: Colours.primaryColour,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(),
                              ),
                            ),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Center(
                                child: Container(
                                  child: CircularProgressIndicator(
                                    strokeWidth: Dimensions.d_2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colours.secondaryColour),
                                  ),
                                  width: Dimensions.d_50,
                                  height: Dimensions.d_50,
                                ),
                              ),
                              imageUrl: photoUrl,
                              fit: BoxFit.fill,
                            ),
                          ),
                  ),
                  myRole == describeEnum(Role.pharmacist)
                      ? Positioned(
                          bottom: Dimensions.d_5,
                          right: Dimensions.d_5,
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colours.secondaryColour,
                            ),
                            onPressed: _onPressEdit,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            SizedBox(
              height: Dimensions.d_15,
            ),
            Expanded(
              flex: 2,
              child: buildMembersList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMembersList() {
    return StreamBuilder(
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
          return Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: Paddings.horizontal_10,
                child: Text(
                  '${userSnapshot.data.docs.length} participant(s)',
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
                    String groupType = describeEnum(GroupType.personal);
                    String userId = userDetails['id'];
                    String userName = userDetails['fullName'] ?? '';
                    String avatarUrl = userDetails['photoUrl'];
                    String userRole = userDetails['role'];

                    return Column(
                      children: [
                        ListTile(
                          contentPadding: Paddings.horizontal_10,
                          leading: buildAvatar(
                            groupType: groupType,
                            avatarUrl: avatarUrl,
                          ),
                          title: Text(
                            userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: userRole == describeEnum(Role.normal)
                              ? null
                              : Container(
                                  child: Text(
                                    userRole,
                                    style: TextStyle(
                                      color: Colours.secondaryColour,
                                    ),
                                  ),
                                  padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colours.secondaryColour,
                                        width: Dimensions.d_2),
                                    borderRadius: BordersRadius.userRole,
                                  ),
                                ),
                          onTap: () {
                            if (userId != id) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: _onPressMemberList(
                                          memberId: userId,
                                          memberUserName: userName,
                                          memberRole: userRole,
                                          imageUrl: avatarUrl),
                                    );
                                  });
                            }
                          },
                        ),
                        Container(
                          width: Dimensions.d_380,
                          child: Divider(
                            thickness: 0.7,
                            height: Dimensions.d_1,
                            indent: Dimensions.d_1,
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount: userSnapshot.data.docs.length,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _onPressMemberList(
      {String memberId,
      String memberUserName,
      String memberRole,
      String imageUrl}) {
    // personal message is allowed only if either one is paharmacist
    bool isMessageAllowed = (memberRole == describeEnum(Role.pharmacist)) ||
        (myRole == describeEnum(Role.pharmacist));

    return Container(
      height: Dimensions.d_100,
      width: Dimensions.d_55,
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text('View Profile Picture'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullPhoto(
                      title: memberUserName,
                      url: imageUrl,
                    ),
                  ));
            },
          ),
          InkWell(
            onTap: () {
              if (!isMessageAllowed) {
                Fluttertoast.showToast(
                    msg: 'You can only have private message with pharmacist.');
              }
            },
            child: ListTile(
              title: Text('Message $memberUserName'),
              enabled: isMessageAllowed,
              onTap: () async {
                showLoadingAnimation(context: context);
                Map<String, dynamic> personalGroupDetails =
                    await getPersonalGroupDetails(id: id, peerId: memberId);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatRoom(
                      id: id,
                      groupId: personalGroupDetails['id'],
                      getGroupDetailsCallback: getGroupDetailsCallback,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _onPressEdit() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: Dimensions.d_100,
            width: Dimensions.d_55,
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text('Upload New Group Photo'),
                  onTap: () {
                    getImage(context: context);
                  },
                ),
                ListTile(
                  title: Text('Edit Group Name'),
                  onTap: () async {
                    _editGroupNamePopUp();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future getImage({BuildContext context}) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String fileName =
          'images/groups/$groupId/groupPhotos/${DateTime.now().toString()}';

      File imageFile = File(pickedFile.path);
      showLoadingAnimation(context: context);
      String fileUrl = await uploadFile(file: imageFile, fileName: fileName);
      updateGroupDetails(
        groupId: groupId,
        modifiedDetails: {'photoUrl': fileUrl},
      );
      setState(() {
        photoUrl = fileUrl;
      });
      Navigator.pop(context);
    }
  }

  Future<String> uploadFile({File file, String fileName}) async {
    String fileUrl = '';
    StorageReference reference = _firestorage.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(file);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    await storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      fileUrl = downloadUrl;
      Fluttertoast.showToast(msg: 'File uploaded.');
    }, onError: (err) {
      Fluttertoast.showToast(msg: 'File upload failed.');
    });
    return fileUrl;
  }

  void _editGroupNamePopUp() {
    showDialog(
      context: context,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: Text('Edit Group Name'),
          content: InputField(
            controller: groupNameController,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Confirm'),
              onPressed: () async {
                showLoadingAnimation(context: context);
                updateGroupDetails(
                  groupId: groupId,
                  modifiedDetails: {'name': groupNameController.text},
                );
                setState(() {
                  groupName = groupNameController.text;
                });
                setGroupNameCallback(newGroupName: groupNameController.text);
                // pop loading animation
                Navigator.pop(context);
                Navigator.of(alertContext).pop();
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

  void updateGroupDetails(
      {String groupId, Map<String, dynamic> modifiedDetails}) {
    modifiedDetails['modifiedAt'] = DateTime.now();
    _firestore
        .collection('groups')
        .doc(groupId)
        .update(modifiedDetails)
        .then((data) {
      Fluttertoast.showToast(msg: 'Update success');
    }).catchError((err) {
      Fluttertoast.showToast(msg: 'Update failed');
    });
  }
}
