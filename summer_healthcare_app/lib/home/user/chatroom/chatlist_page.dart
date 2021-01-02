import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/home/user/chatroom/chatroom_page.dart';

enum GroupType { personal, pharmacy, public }

class ChatList extends StatelessWidget {
  final String id;

  ChatList({this.id});

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
            'Chat',
            style: TextStyle(
              color: Colours.secondaryColour,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ChatListScreen(id: id),
      ),
    );
  }
}

class ChatListScreen extends StatefulWidget {
  final String id;

  ChatListScreen({this.id});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final _firestore = FirebaseFirestore.instance;

  String id;
  Future<Map<String, Map<String, dynamic>>> groupsDetailsFuture;

  @override
  void initState() {
    super.initState();
    groupsDetailsFuture = getGroupsDetailsAsync();

    id = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore
          .collection('groups')
          .where('members', arrayContains: id)
          .orderBy('lastChatAt', descending: true)
          .snapshots(),
      builder: (context, groupSnapshot) {
        if (!groupSnapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Colours.secondaryColour),
            ),
          );
        } else {
          return (groupSnapshot.data.documents.length != 0)
              ? StreamBuilder(
                  stream: _firestore
                      .collection('users')
                      .where('groups',
                          arrayContainsAny: groupSnapshot.data.documents
                              .map((group) => group.data()['id'])
                              .toList())
                      .snapshots(),
                  builder: (context, userSnapshot) {
                    if (!userSnapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colours.secondaryColour),
                        ),
                      );
                    } else {
                      Map<String, Map<String, dynamic>> groupsDetails =
                          getGroupsDetails(
                              groupSnapshot: groupSnapshot,
                              userSnapshot: userSnapshot);

                      return ListView.builder(
                        padding: Paddings.all_10,
                        itemBuilder: (_, index) {
                          DocumentSnapshot document =
                              groupSnapshot.data.documents[index];
                          Map<String, dynamic> groupDetails =
                              groupsDetails[document.data()['id']];
                          return buildChatTile(groupDetails: groupDetails);
                        },
                        itemCount: groupSnapshot.data.documents.length,
                      );
                    }
                  })
              : Text(
                  'You have not been added into any group. Please ask your pharmacist for assistance.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colours.grey,
                    fontSize: FontSizes.normalText,
                  ),
                );
        }
      },
    );
  }

  Future<Map<String, Map<String, dynamic>>> getGroupsDetailsAsync() async {
    Map<String, Map<String, dynamic>> groupsDetails = {};
    try {
      QuerySnapshot groupSnapshot = await _firestore
          .collection('groups')
          .where('members', arrayContains: id)
          .get();

      List<QueryDocumentSnapshot> groupSnapshots = groupSnapshot.docs;

      List<String> groupIds = groupSnapshots
          .map((group) => group.data()['id'])
          .toList()
          .cast<String>();

      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('groups', arrayContainsAny: groupIds)
          .get();

      groupSnapshots.forEach((doc) {
        // key=groupId, value=group details
        groupsDetails[doc['id']] = doc.data();
        groupsDetails[doc['id']]['members'] = {};
      });
      userSnapshot.docs.forEach((doc) {
        doc.data()['groups'].forEach((groupId) =>
            groupsDetails[groupId]['members'][doc['id']] = doc.data());
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error retrieving group details.');
      groupsDetails = {};
    }
    return groupsDetails;
  }

  Map<String, Map<String, dynamic>> getGroupsDetails(
      {AsyncSnapshot<QuerySnapshot> groupSnapshot,
      AsyncSnapshot<QuerySnapshot> userSnapshot}) {
    Map<String, Map<String, dynamic>> groupsDetails = {};
    try {
      List<QueryDocumentSnapshot> groupSnapshots = groupSnapshot.data.docs;

      groupSnapshots.forEach((doc) {
        // key=groupId, value=group details
        groupsDetails[doc['id']] = doc.data();
        groupsDetails[doc['id']]['members'] = {};
      });
      userSnapshot.data.docs.forEach((doc) {
        doc.data()['groups'].forEach((groupId) =>
            groupsDetails[groupId]['members'][doc['id']] = doc.data());
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error retrieving group details.');
      groupsDetails = {};
    }
    return groupsDetails;
  }

  Widget buildChatTile({Map<String, dynamic> groupDetails}) {
    Map members = groupDetails['members'];
    String groupType = groupDetails['type'];
    String groupId = groupDetails['id'];
    String groupName = groupDetails['name'];
    String lastMessage = groupDetails['lastMessage'];
    String lastSentBy = groupDetails['lastSentBy'];
    

    String title = '';
    if (groupType == describeEnum(GroupType.personal)) {
      // for personal group, it is one-to-one group so set title
      // equals to another conversation participant
      members.forEach((memberId, details) {
        title = (memberId.toString() != id) ? memberId.toString() : title;
      });
      lastSentBy = '';
    } else {
      title = groupName;
      String selfName = members[id]['displayName'];
      lastSentBy = (lastSentBy == selfName) ? '' : '$lastSentBy: ';
    }

    return Column(
      children: [
        ListTile(
          leading: buildAvatar(groupId: groupId, groupType: groupType),
          title: Text(title),
          subtitle: Text(
            lastSentBy + lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatRoom(
                  id: id,
                  groupDetails: groupDetails,
                  title: title,
                ),
              ),
            );
          },
        ),
        Divider(
          height: Dimensions.d_1,
          indent: Dimensions.d_1,
        ),
      ],
    );
  }

  Container buildAvatar({String groupId, String groupType}) {
    String avatarUrl = '';

    return Container(
      width: Dimensions.d_35,
      height: Dimensions.d_35,
      child: FutureBuilder(
          future: groupsDetailsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.length != 0) {
              if (groupType == describeEnum(GroupType.personal)) {
                // for personal group, it is one-to-one group so set avatarUrl
                // equals to another conversation participant's avatarUrl
                snapshot.data[groupId]['members'].forEach((member) {
                  avatarUrl =
                      (member['id'] != id) ? member['photoUrl'] : avatarUrl;
                });
              } else {
                avatarUrl = snapshot.data[groupId]['photoUrl'];
              }
            }

            return Material(
              child: avatarUrl == null || avatarUrl == ''
                  ? Icon(
                      groupType == describeEnum(GroupType.pharmacy)
                          ? Icons.group_rounded
                          : Icons.account_circle,
                      size: Dimensions.d_35,
                      color: Colours.grey,
                    )
                  : CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(
                          strokeWidth: Dimensions.d_1,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colours.secondaryColour),
                        ),
                        width: Dimensions.d_35,
                        height: Dimensions.d_35,
                        padding: Paddings.all_10,
                      ),
                      imageUrl: avatarUrl,
                      width: Dimensions.d_35,
                      height: Dimensions.d_35,
                      fit: BoxFit.cover,
                    ),
              borderRadius: BordersRadius.chatAvatar,
              clipBehavior: Clip.hardEdge,
            );
          }),
    );
  }
}
