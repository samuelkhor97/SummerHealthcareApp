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
import 'package:shared_preferences/shared_preferences.dart';

import 'package:summer_healthcare_app/widgets/show_loading_animation.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/home/user/chatroom/full_photo.dart';
import 'package:summer_healthcare_app/home/user/chatroom/chatlist_page.dart'
    show GroupType;

enum Type { text, image, video, voice }
enum Position { left, right }

class ChatRoom extends StatelessWidget {
  final String id;
  final Map<String, dynamic> groupDetails;
  final String title;

  ChatRoom({this.id, this.groupDetails, this.title});

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
            title,
            style: TextStyle(
              color: Colours.secondaryColour,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: Paddings.horizontal_5,
              child: IconButton(
                icon: Icon(
                  Icons.info_outline_rounded,
                  color: Colours.secondaryColour,
                ),
                iconSize: Dimensions.d_30,
                onPressed: () {},
              ),
            ),
          ],
        ),
        body: ChatScreen(
          id: id,
          groupDetails: groupDetails,
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String id;
  final Map<String, dynamic> groupDetails;

  ChatScreen({this.id, this.groupDetails});

  @override
  State createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String groupId;
  String id;
  String groupType;

  bool isSendDisabled = true;

  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  final int _limitIncrement = 20;
  SharedPreferences preferences;

  final Map<String, String> sendersAvatars = {};
  final Map<String, String> sendersNames = {};

  final _firestore = FirebaseFirestore.instance;
  final _firestorage = FirebaseStorage.instance;

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

    id = this.widget.id;
    groupId = this.widget.groupDetails['id'];
    this.widget.groupDetails['members'].forEach((id, details) {
      sendersAvatars[id] = details['photoUrl'];
      sendersNames[id] = details['displayName'] ?? '';
    });
    groupType = this.widget.groupDetails['type'];
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
    listScrollController.dispose();
    focusNode.dispose();

    print(
        'Disposed text editor, scroll editor and focus node in chatroom page');
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

  Future getImage({BuildContext context}) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String fileName = 'images/$id/${DateTime.now().toString()}';

      File imageFile = File(pickedFile.path);
      showLoadingAnimation(context: context);
      await uploadFile(file: imageFile, fileName: fileName);
      Navigator.pop(context);
    }
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
      String lastSentBy = widget.groupDetails['members'][id]['displayName'];

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
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: () {
                  getImage(context: context);
                },
                color: Colours.secondaryColour,
              ),
            ),
            color: Colors.white,
          ),
          // Edit text
          Flexible(
            child: Container(
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
        stream: _firestore
            .collection('messages')
            .doc(groupId)
            .collection('messages')
            .orderBy('sentAt', descending: true)
            .limit(_limit)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colours.secondaryColour),
              ),
            );
          } else {
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
    String senderName = sendersNames[docData['sentBy']];
    String senderAvatar = sendersAvatars[docData['sentBy']];
    String messageType = docData['type'];
    String content = docData['content'];
    String senderRole = docData['role'];
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
                : buildSenderLabel(
                    sender: senderName,
                    role: senderRole,
                  ),
            Row(
              children: <Widget>[
                isLastMessageLeft(index: index) && !isPersonal
                    ? buildSenderAvatar(
                        senderAvatar: senderAvatar, senderName: senderName)
                    : Container(width: !isPersonal ? 35.0 : 0),
                messageType == describeEnum(Type.text)
                    ? buildMessageBubble(
                        text: content,
                        textColor: Colours.black,
                        bubbleColor: Colours.midGrey,
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
            isLastMessageLeft(index: index)
                ? buildTimeSent(datetime: sentAt.toDate())
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  Material buildSenderAvatar({String senderAvatar, String senderName}) {
    return Material(
      child: InkWell(
        onTap: () {
          focusNode.unfocus();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: onPressAvatarList(
                      avatarUserName: senderName, imageUrl: senderAvatar),
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
      margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
    );
  }

  Row buildSenderLabel({String sender, String role}) {
    return Row(
      children: <Widget>[
        Container(width: 50.0),
        Container(
          width: 125,
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
      margin = EdgeInsets.only(left: 10.0);
    } else {
      margin = EdgeInsets.only(
          bottom: isLastMessageRight(index: index) ? 20.0 : 10.0, right: 10.0);
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
        padding: EdgeInsets.all(0),
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
      margin = EdgeInsets.only(left: 10.0);
    } else {
      margin = EdgeInsets.only(
          bottom: isLastMessageRight(index: index) ? 20.0 : 10.0, right: 10.0);
    }
    return Container(
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      width: Dimensions.d_250,
      decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: position == Position.left
              ? BordersRadius.leftChatBubble
              : BordersRadius.rightChatBubble),
      margin: margin,
    );
  }

  Widget onPressAvatarList({String avatarUserName, String imageUrl}) {
    return Container(
      height: Dimensions.d_100,
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
                    builder: (context) =>
                        FullPhoto(title: avatarUserName, url: imageUrl),
                  ));
            },
          ),
          ListTile(
            title: Text('Message $avatarUserName'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoom(
                    id: id,
                    groupDetails: null,
                    title: avatarUserName,
                  ),
                ),
              );
            },
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

  bool isLastMessageLeft({int index}) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].data()['sentBy'] == id) ||
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

  Future<bool> onBackPress() {
    Navigator.pop(context);

    return Future.value(false);
  }
}
