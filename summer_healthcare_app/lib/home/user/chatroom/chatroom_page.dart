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

enum Type { text, image, video, voice }

class ChatRoom extends StatelessWidget {
  final String id;
  final Map<String, dynamic> groupDetails;

  ChatRoom({this.id, this.groupDetails});

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
            groupDetails['name'],
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

  bool isSendDisabled = true;

  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  final int _limitIncrement = 20;
  SharedPreferences preferences;

  File imageFile;
  String imageUrl;

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
        print("reach the bottom");
        _limit += _limitIncrement;
      });
    }
    if (listScrollController.offset <=
            listScrollController.position.minScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        print("reach the top");
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
    imageUrl = '';
  }

  Future getImage({BuildContext context}) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      showLoadingAnimation(context: context);
      await uploadFile();
      Navigator.pop(context);
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().toString();
    StorageReference reference = _firestorage.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      onSendMessage(content: imageUrl, type: Type.image);
    }, onError: (err) {
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  void onSendMessage({String content, Type type}) {
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = _firestore
          .collection('messages')
          .doc(groupId)
          .collection('messages')
          .doc();

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
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  Widget buildItem({int index, DocumentSnapshot document}) {
    String senderAvatar = sendersAvatars[document.data()['sentBy']];

    if (document.data()['sentBy'] == id) {
      // Right (my message)
      return Row(
        children: <Widget>[
          document.data()['type'] == describeEnum(Type.text)
              // Text
              ? Container(
                  child: Text(
                    document.data()['content'],
                    style: TextStyle(color: Colours.primaryColour),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 250.0,
                  decoration: BoxDecoration(
                      color: Colours.secondaryColour,
                      borderRadius: BordersRadius.rightChatBubble),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index: index) ? 20.0 : 10.0,
                      right: 10.0),
                )
              : document.data()['type'] == describeEnum(Type.image)
                  // Image
                  ? Container(
                      child: FlatButton(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colours.primaryColour),
                              ),
                              width: 200.0,
                              height: 200.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: Colours.lightGrey,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Image.asset(
                                'images/img_not_available.jpeg',
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: document.data()['content'],
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          focusNode.unfocus();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FullPhoto(url: document.data()['content']),
                              ));
                        },
                        padding: EdgeInsets.all(0),
                      ),
                      margin: EdgeInsets.only(
                          bottom:
                              isLastMessageRight(index: index) ? 20.0 : 10.0,
                          right: 10.0),
                    )
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
            Row(
              children: <Widget>[
                Container(width: 50.0),
                Container(
                  width: 125,
                  child: Text(
                    sendersNames[document.data()['sentBy']],
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                isLastMessageLeft(index: index)
                    ? Material(
                        child: senderAvatar == null
                            ? Icon(
                                Icons.account_circle,
                                size: 35.0,
                                color: Colours.grey,
                              )
                            : CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colours.primaryColour),
                                  ),
                                  width: 35.0,
                                  height: 35.0,
                                  padding: Paddings.all_10,
                                ),
                                imageUrl: senderAvatar,
                                width: 35.0,
                                height: 35.0,
                                fit: BoxFit.cover,
                              ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(width: 35.0),
                document.data()['type'] == 'text'
                    ? Container(
                        child: Text(
                          document.data()['content'],
                          style: TextStyle(color: Colors.black),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 250.0,
                        decoration: BoxDecoration(
                            color: Colours.midGrey,
                            borderRadius: BordersRadius.leftChatBubble),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : document.data()['type'] == 'image'
                        ? Container(
                            child: FlatButton(
                              child: Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colours.primaryColour),
                                    ),
                                    width: 200.0,
                                    height: 200.0,
                                    padding: EdgeInsets.all(70.0),
                                    decoration: BoxDecoration(
                                      color: Colours.lightGrey,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Material(
                                    child: Image.asset(
                                      'images/img_not_available.jpeg',
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  imageUrl: document.data()['content'],
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                focusNode.unfocus();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullPhoto(
                                          url: document.data()['content']),
                                    ));
                              },
                              padding: EdgeInsets.all(0),
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          )
                        // video and voice messages
                        : Container(),
              ],
            ),

            // Time
            isLastMessageLeft(index: index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM yyyy hh:mm a').format(
                          getLocalDateTime(document.data()['sentAt'].toDate())),
                      style: TextStyle(
                        color: Colours.grey,
                        fontSize: 12.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
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
                style: TextStyle(color: Colours.black, fontSize: 15.0),
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
                    AlwaysStoppedAnimation<Color>(Colours.primaryColour),
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
}
