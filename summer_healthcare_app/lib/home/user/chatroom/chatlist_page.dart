import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/home/user/chatroom/chatroom_page.dart';
import 'package:summer_healthcare_app/main.dart';

enum GroupType { personal, pharmacy, public }

class ChatList extends StatelessWidget {
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
        body: ChatListScreen(),
      ),
    );
  }
}

class ChatListScreen extends StatefulWidget {

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final _firestore = FirebaseFirestore.instance;

  String id;
  Map<String, Map<String, dynamic>> groupsDetails;

  @override
  void initState() {
    super.initState();

    id = preferences.getString('id');
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
                      groupsDetails = getGroupsDetails(
                        groupSnapshot: groupSnapshot,
                        userSnapshot: userSnapshot,
                      );

                      return ListView.builder(
                        padding: Paddings.all_10,
                        itemBuilder: (_, index) {
                          DocumentSnapshot document =
                              groupSnapshot.data.documents[index];
                          Map<String, dynamic> groupDetails =
                              groupsDetails[document.data()['id']];

                          if ((groupDetails['lastMessage'] == null ||
                                  groupDetails['lastMessage'] == '') &&
                              groupDetails['type'] ==
                                  describeEnum(GroupType.personal)) {
                            return null;
                          } else {
                            return buildChatTile(groupDetails: groupDetails);
                          }
                        },
                        itemCount: groupSnapshot.data.documents.length,
                      );
                    }
                  })
              : Center(
                child: Text(
                    'You have not been added into any group. \nPlease ask your pharmacist for assistance.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colours.grey,
                      fontSize: FontSizes.normalText,
                    ),
                  ),
              );
        }
      },
    );
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
        doc.data()['groups'].forEach((groupId) {
          // other users might have other groups which current user does not have
          // groupsDetails map only contains groups that the current user have
          if (groupsDetails[groupId] != null)
            groupsDetails[groupId]['members'][doc['id']] = doc.data();
        });
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error retrieving group details.');
      groupsDetails = {};
    }
    return groupsDetails;
  }

  Map<String, dynamic> getGroupDetailsCallback({String groupId}) {
    return UnmodifiableMapView(groupsDetails[groupId]);
  }

  Widget buildChatTile({Map<String, dynamic> groupDetails}) {
    Map members = groupDetails['members'];
    String groupId = groupDetails['id'];
    String groupType = groupDetails['type'];
    String groupName = groupDetails['name'];
    String lastMessage = groupDetails['lastMessage'] ?? '';
    String lastSentBy = groupDetails['lastSentBy'];
    String avatarUrl = '';

    String title = '';
    String selfName = members[id]['displayName'];
    if (groupType == describeEnum(GroupType.personal)) {
      // for personal group, it is one-to-one group so set title
      // equals to another conversation participant
      members.forEach((memberId, details) {
        title = (memberId.toString() != id) ? details['displayName'] : title;
      });
      lastSentBy = (lastSentBy == selfName) ? 'You: ' : '';
    } else {
      title = groupName;
      lastSentBy = (lastSentBy == selfName) ? 'You: ' : '$lastSentBy: ';
    }

    if (groupType == describeEnum(GroupType.personal)) {
      // for personal group, it is one-to-one group so set avatarUrl
      // equals to another conversation participant's avatarUrl
      groupDetails['members'].forEach((memberId, details) {
        avatarUrl = (memberId != id) ? details['photoUrl'] : avatarUrl;
      });
    } else {
      avatarUrl = groupDetails['photoUrl'];
    }

    return Column(
      children: [
        ListTile(
          leading: buildAvatar(groupType: groupType, avatarUrl: avatarUrl),
          title: Text(title),
          subtitle: Text(
            '$lastSentBy$lastMessage',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatRoom(
                  id: id,
                  groupId: groupId,
                  getGroupDetailsCallback: getGroupDetailsCallback,
                ),
              ),
            );
          },
        ),
        Divider(
          thickness: Dimensions.d_1,
        ),
      ],
    );
  }
}

Material buildAvatar({String groupType, String avatarUrl}) {
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
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colours.secondaryColour),
              ),
              width: Dimensions.d_35,
              height: Dimensions.d_35,
            ),
            imageUrl: avatarUrl,
            width: Dimensions.d_35,
            height: Dimensions.d_35,
            fit: BoxFit.cover,
          ),
    borderRadius: BordersRadius.chatAvatar,
    clipBehavior: Clip.hardEdge,
  );
}
