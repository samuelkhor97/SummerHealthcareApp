import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:summer_healthcare_app/widgets/show_loading_animation.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/home/user/chatroom/full_photo.dart';
import 'package:summer_healthcare_app/home/user/chatroom/groupinfo_page.dart';
import 'package:summer_healthcare_app/home/user/chatroom/chatlist_page.dart'
    show GroupType;

enum Type { text, image, video, voice }
enum Position { left, right }
enum Role { normal, pharmacist }

final _firestore = FirebaseFirestore.instance;
final _firestorage = FirebaseStorage.instance;

class ChatRoom extends StatefulWidget {
  final String id;
  final String groupId;
  final Function getGroupDetailsCallback;

  ChatRoom({this.id, this.groupId, this.getGroupDetailsCallback});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  String groupName = '';
  Map<String, dynamic> groupDetails;

  @override
  void initState() {
    super.initState();
    groupDetails = widget.getGroupDetailsCallback(groupId: widget.groupId);
    if (groupDetails['type'] == describeEnum(GroupType.personal)) {
      // for personal group, it is one-to-one group so set title
      // equals to another conversation participant
      groupDetails['members'].forEach((memberId, details) {
        groupName = (memberId.toString() != widget.id)
            ? details['displayName']
            : groupName;
      });
    } else {
      groupName = groupDetails['name'];
    }
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
              Navigator.popUntil(
                  context, (route) => route.settings.name == "ChatList");
            },
          ),
          centerTitle: true,
          title: Text(
            groupName,
            style: TextStyle(
              color: Colours.secondaryColour,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            groupDetails['type'] == describeEnum(GroupType.personal)
                ? Container()
                : Padding(
                    padding: Paddings.horizontal_5,
                    child: IconButton(
                      icon: Icon(
                        Icons.info_outline_rounded,
                        color: Colours.secondaryColour,
                      ),
                      iconSize: Dimensions.d_30,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupInfo(
                                id: widget.id,
                                groupId: widget.groupId,
                                setGroupNameCallback: setGroupNameCallback,
                                getGroupDetailsCallback:
                                    widget.getGroupDetailsCallback,
                              ),
                            ));
                      },
                    ),
                  ),
          ],
        ),
        body: ChatScreen(
          id: widget.id,
          groupId: widget.groupId,
          getGroupDetailsCallback: widget.getGroupDetailsCallback,
        ),
      ),
    );
  }

  void setGroupNameCallback({String newGroupName}) {
    setState(() {
      groupName = newGroupName;
    });
  }
}

class ChatScreen extends StatefulWidget {
  final String id;
  final String groupId;
  final Function getGroupDetailsCallback;

  ChatScreen({this.id, this.groupId, this.getGroupDetailsCallback});

  @override
  State createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Map<String, dynamic> groupDetails;
  String groupId;
  String id;
  String groupType;
  Stream messageStream;
  bool isSendDisabled = true;

  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  final int _limitIncrement = 20;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        // scolled to the topmost
        _limit += _limitIncrement;
        messageStream = _firestore
            .collection('messages')
            .doc(groupId)
            .collection('messages')
            .orderBy('sentAt', descending: true)
            .limit(_limit)
            .snapshots();
      });
    }
  }

  _textEditingListener() {
    setState(() {
      isSendDisabled = textEditingController.text.isEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(_scrollListener);
    textEditingController.addListener(_textEditingListener);

    id = widget.id;
    groupId = widget.groupId;
    groupDetails = widget.getGroupDetailsCallback(groupId: groupId);
    groupType = groupDetails['type'];

    messageStream = _firestore
        .collection('messages')
        .doc(groupId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .limit(_limit)
        .snapshots();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
    listScrollController.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),
              // Input content
              buildInput(context: context),
            ],
          ),
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  Future getImage({BuildContext context, ImageSource imageSource}) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: imageSource);

    if (pickedFile != null) {
      String fileName =
          'images/groups/$groupId/users/$id/${DateTime.now().toString()}';

      File imageFile = File(pickedFile.path);
      showLoadingAnimation(context: context);
      File compressedFile = await compressFile(file: imageFile);
      await uploadFile(file: compressedFile ?? imageFile, fileName: fileName);
      Navigator.pop(context);
    }
  }

  Future<File> compressFile({File file}) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf('.');
    final splitted = filePath.substring(0, lastIndex);
    final outPath = "${splitted}_compressed${filePath.substring(lastIndex)}";
    File result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 25,
    );

    return result;
  }

  Future uploadFile({File file, String fileName}) async {
    StorageReference reference = _firestorage.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(file);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      String imageUrl = downloadUrl;
      onSendMessage(content: imageUrl, type: Type.image);
    }, onError: (err) {
      Fluttertoast.showToast(msg: 'File upload failed.');
    });
  }

  void onSendMessage({String content, Type type}) {
    if (content.trim() != '') {
      textEditingController.clear();

      String lastMessage =
          (type == Type.text) ? content : "[${describeEnum(type)}]";
      String lastSentBy = groupDetails['members'][id]['displayName'];

      var documentReference = _firestore
          .collection('messages')
          .doc(groupId)
          .collection('messages')
          .doc();
      var groupReference = _firestore.collection('groups').doc(groupId);

      _firestore.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'id': documentReference.id,
            'sentBy': id,
            'sentAt': DateTime.now(),
            'content': content,
            'type': describeEnum(type)
          },
        );
        transaction.update(groupReference, {
          'lastChatAt': DateTime.now(),
          'lastMessage': lastMessage,
          'lastSentBy': lastSentBy
        });
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  Widget buildInput({BuildContext context}) {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Flexible(
            flex: 1,
            child: Container(
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () {
                  getImage(context: context, imageSource: ImageSource.camera);
                },
                color: Colours.secondaryColour,
              ),
              color: Colors.white,
            ),
          ),
          // Button send image from gallery
          Flexible(
            flex: 1,
            child: Container(
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: () {
                  getImage(context: context, imageSource: ImageSource.gallery);
                },
                color: Colours.secondaryColour,
              ),
              color: Colors.white,
            ),
          ),
          // Edit text
          Flexible(
            flex: 8,
            child: Container(
              padding: Paddings.horizontal_10,
              child: TextField(
                onSubmitted: (value) {
                  onSendMessage(
                      content: textEditingController.text, type: Type.text);
                },
                style: TextStyle(
                  color: Colours.black,
                  fontSize: FontSizes.normalText,
                ),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(
                    color: Colours.grey,
                  ),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: isSendDisabled
                    ? null
                    : () => onSendMessage(
                        content: textEditingController.text, type: Type.text),
                color: Colours.secondaryColour,
              ),
            ),
            color: Colours.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colours.lightGrey, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: StreamBuilder(
        stream: messageStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colours.secondaryColour),
              ),
            );
          } else {
            groupDetails = widget.getGroupDetailsCallback(groupId: groupId);
            listMessage.clear();
            listMessage.addAll(snapshot.data.documents);
            return ListView.builder(
              padding: Paddings.all_10,
              itemBuilder: (context, index) => buildItem(
                  index: index, document: snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              reverse: true,
              controller: listScrollController,
            );
          }
        },
      ),
    );
  }

  Widget buildItem({int index, DocumentSnapshot document}) {
    Map<String, dynamic> docData = document.data();

    String senderId = docData['sentBy'];
    String senderName = groupDetails['members'][senderId]['displayName'] ?? '';
    String senderAvatar = groupDetails['members'][senderId]['photoUrl'];
    String messageType = docData['type'];
    String content = docData['content'];
    String senderRole = groupDetails['members'][senderId]['role'];
    Timestamp sentAt = docData['sentAt'];
    bool isPersonal = groupType == describeEnum(GroupType.personal);

    if (docData['sentBy'] == id) {
      // Right (my message)
      return Row(
        children: <Widget>[
          messageType == describeEnum(Type.text)
              // Text
              ? buildMessageBubble(
                  text: content,
                  textColor: Colours.white,
                  bubbleColor: Colours.secondaryColour,
                  position: Position.right,
                  index: index)
              : messageType == describeEnum(Type.image)
                  // Image
                  ? buildImageBubble(
                      imageUrl: content,
                      position: Position.right,
                      index: index,
                      textFocusNode: focusNode)
                  // video and voice messages
                  : Container(),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            isPersonal
                ? Container()
                : isTopMessageLeft(index: index, senderId: senderId)
                    ? buildSenderLabel(
                        sender: senderName,
                        role: senderRole,
                      )
                    : Container(),
            Row(
              children: <Widget>[
                isLastMessageLeft(index: index, senderId: senderId)
                    ? buildSenderAvatar(
                        senderId: senderId,
                        senderAvatar: senderAvatar,
                        senderName: senderName)
                    : Container(width: Dimensions.d_35),
                messageType == describeEnum(Type.text)
                    ? buildMessageBubble(
                        text: content,
                        textColor: Colours.black,
                        bubbleColor: Colours.lighterGrey,
                        position: Position.left,
                        index: index)
                    : messageType == describeEnum(Type.image)
                        ? buildImageBubble(
                            imageUrl: content,
                            position: Position.left,
                            index: index,
                            textFocusNode: focusNode)
                        // video and voice messages
                        : Container(),
              ],
            ),

            // Time
            isLastMessageLeft(index: index, senderId: senderId)
                ? buildTimeSent(datetime: sentAt.toDate())
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: Dimensions.d_10),
      );
    }
  }

  Material buildSenderAvatar(
      {String senderId, String senderAvatar, String senderName}) {
    return Material(
      child: InkWell(
        onTap: () {
          focusNode.unfocus();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: onPressAvatarList(
                      avatarUserId: senderId,
                      avatarUserName: senderName,
                      imageUrl: senderAvatar),
                );
              });
        },
        child: senderAvatar == null || senderAvatar == ''
            ? Icon(
                Icons.account_circle,
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
                  padding: Paddings.all_10,
                ),
                imageUrl: senderAvatar,
                width: Dimensions.d_35,
                height: Dimensions.d_35,
                fit: BoxFit.cover,
              ),
      ),
      borderRadius: BordersRadius.chatAvatar,
      clipBehavior: Clip.hardEdge,
    );
  }

  Container buildTimeSent({DateTime datetime}) {
    return Container(
      child: Text(
        DateFormat('dd MMM yyyy hh:mm a').format(getLocalDateTime(datetime)),
        style: TextStyle(
          color: Colours.grey,
          fontSize: FontSizes.smallText,
          fontStyle: FontStyle.italic,
        ),
      ),
      margin: EdgeInsets.only(
          left: Dimensions.d_50, top: Dimensions.d_5, bottom: Dimensions.d_5),
    );
  }

  Row buildSenderLabel({String sender, String role}) {
    return Row(
      children: <Widget>[
        Container(width: Dimensions.d_50),
        Container(
          width: Dimensions.d_120,
          child: Text(
            sender,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Container buildImageBubble(
      {String imageUrl,
      Position position,
      int index,
      FocusNode textFocusNode}) {
    EdgeInsetsGeometry margin;

    if (position == Position.left) {
      margin = EdgeInsets.only(left: Dimensions.d_10);
    } else {
      margin = EdgeInsets.only(
          bottom: isLastMessageRight(index: index)
              ? Dimensions.d_20
              : Dimensions.d_10,
          right: Dimensions.d_10);
    }
    return Container(
      child: FlatButton(
        child: Material(
          child: CachedNetworkImage(
            placeholder: (context, url) => Container(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colours.secondaryColour),
              ),
              width: Dimensions.d_200,
              height: Dimensions.d_200,
              padding: EdgeInsets.all(70.0),
              decoration: BoxDecoration(
                color: Colours.lightGrey,
                borderRadius: BordersRadius.chatImage,
              ),
            ),
            errorWidget: (context, url, error) => Material(
              child: Image.asset(
                'images/img_not_available.jpeg',
                width: Dimensions.d_200,
                height: Dimensions.d_200,
                fit: BoxFit.cover,
              ),
              borderRadius: BordersRadius.chatImage,
              clipBehavior: Clip.hardEdge,
            ),
            imageUrl: imageUrl,
            width: Dimensions.d_200,
            height: Dimensions.d_200,
            fit: BoxFit.cover,
          ),
          borderRadius: BordersRadius.chatImage,
          clipBehavior: Clip.hardEdge,
        ),
        onPressed: () {
          textFocusNode.unfocus();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullPhoto(url: imageUrl),
              ));
        },
        padding: EdgeInsets.all(Dimensions.d_0),
      ),
      margin: margin,
    );
  }

  Container buildMessageBubble(
      {String text,
      Color textColor,
      Color bubbleColor,
      Position position,
      int index}) {
    EdgeInsetsGeometry margin;

    if (position == Position.left) {
      margin = EdgeInsets.only(left: Dimensions.d_10);
    } else {
      margin = EdgeInsets.only(
          bottom: isLastMessageRight(index: index)
              ? Dimensions.d_20
              : Dimensions.d_10,
          right: Dimensions.d_10);
    }
    return Container(
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      padding: EdgeInsets.fromLTRB(
          Dimensions.d_15, Dimensions.d_10, Dimensions.d_15, Dimensions.d_10),
      width: Dimensions.d_250,
      decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: position == Position.left
              ? BordersRadius.leftChatBubble
              : BordersRadius.rightChatBubble),
      margin: margin,
    );
  }

  Widget onPressAvatarList(
      {String avatarUserId, String avatarUserName, String imageUrl}) {
    String avatarRole = groupDetails['members'][avatarUserId]['role'];
    String myRole = groupDetails['members'][id]['role'];
    // personal message is allowed only if either one is paharmacist
    bool isMessageAllowed = (avatarRole == describeEnum(Role.pharmacist)) ||
        (myRole == describeEnum(Role.pharmacist));
    bool isPersonal = groupType == describeEnum(GroupType.personal);

    return Container(
      height: isPersonal ? Dimensions.d_50 : Dimensions.d_100,
      width: Dimensions.d_55,
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text('View Profile Picture'),
            onTap: () {
              focusNode.unfocus();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullPhoto(
                      title: avatarUserName,
                      url: imageUrl,
                    ),
                  ));
            },
          ),
          isPersonal
              ? Container()
              : InkWell(
                  onTap: () {
                    if (!isMessageAllowed) {
                      Fluttertoast.showToast(
                          msg:
                              'You can only have private message with pharmacist.');
                    }
                  },
                  child: ListTile(
                    title: Text('Message $avatarUserName'),
                    enabled: isMessageAllowed,
                    onTap: () async {
                      showLoadingAnimation(context: context);
                      Map<String, dynamic> personalGroupDetails =
                          await getPersonalGroupDetails(
                              id: id, peerId: avatarUserId);
                      // pop loading animation
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatRoom(
                            id: id,
                            groupId: personalGroupDetails['id'],
                            getGroupDetailsCallback:
                                widget.getGroupDetailsCallback,
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

  DateTime getLocalDateTime(DateTime datetime) {
    //get current system local time
    DateTime localDatetime = DateTime.now();

    //get time diff
    Duration localTimezoneOffset = localDatetime.timeZoneOffset;
    Duration serverTimezoneOffset = datetime.timeZoneOffset;

    DateTime newLocalTime;
    //adjust the time diff
    if (serverTimezoneOffset >= localTimezoneOffset) {
      newLocalTime =
          datetime.subtract(serverTimezoneOffset - localTimezoneOffset);
    } else {
      newLocalTime = datetime.add(localTimezoneOffset - serverTimezoneOffset);
    }

    return newLocalTime;
  }

  bool isLastMessageLeft({int index, String senderId}) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].data()['sentBy'] != senderId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight({int index}) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].data()['sentBy'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isTopMessageLeft({int index, String senderId}) {
    if (index == listMessage.length - 1 ||
        (listMessage != null &&
            listMessage[index + 1].data()['sentBy'] != senderId)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    Navigator.popUntil(context, (route) => route.settings.name == "ChatList");

    return Future.value(false);
  }
}

Future<Map<String, dynamic>> getPersonalGroupDetails(
    {String id, String peerId}) async {
  Map<String, dynamic> personalGroupDetails;

  String personalGroupId =
      (id.hashCode < peerId.hashCode) ? '$id-$peerId' : '$peerId-$id';

  var groupReference = _firestore.collection('groups').doc(personalGroupId);
  var groupSnapshot = await groupReference.get();

  if (!groupSnapshot.exists) {
    var myUserRefrence = _firestore.collection('users').doc(id);
    var peerUserRefrence = _firestore.collection('users').doc(peerId);

    String newGroupType = describeEnum(GroupType.personal);
    List<String> members = List.from([id, peerId]);

    personalGroupDetails = {
      'id': groupReference.id,
      'createdAt': DateTime.now(),
      'modifiedAt': DateTime.now(),
      'type': newGroupType,
      'members': members,
      'lastChatAt': null,
      'lastMessage': null,
      'lastSentBy': null,
      'photoUrl': null
    };

    await _firestore.runTransaction((transaction) async {
      transaction.set(
        groupReference,
        personalGroupDetails,
        SetOptions(merge: true),
      );
      transaction.update(myUserRefrence, {
        'groups': FieldValue.arrayUnion([personalGroupId]),
      });
      transaction.update(peerUserRefrence, {
        'groups': FieldValue.arrayUnion([personalGroupId]),
      });
    });
  } else {
    personalGroupDetails = groupSnapshot.data();
  }

  personalGroupDetails['members'] = {};
  var userSnapshot = await _firestore
      .collection('users')
      .where('groups', arrayContains: personalGroupId)
      .get();
  userSnapshot.docs.forEach((doc) {
    personalGroupDetails['members'][doc['id']] = doc.data();
  });

  return personalGroupDetails;
}
