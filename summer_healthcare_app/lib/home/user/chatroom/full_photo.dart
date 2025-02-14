import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:summer_healthcare_app/constants.dart';

class FullPhoto extends StatelessWidget {
  final String url;
  final String title;

  FullPhoto({this.title = 'Full Photo', @required this.url});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text(
            title,
            style: TextStyle(
              color: Colours.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: FullPhotoScreen(url: url),
      ),
    );
  }
}

class FullPhotoScreen extends StatefulWidget {
  final String url;

  FullPhotoScreen({@required this.url});

  @override
  State createState() => _FullPhotoScreenState(url: url);
}

class _FullPhotoScreenState extends State<FullPhotoScreen> {
  final String url;

  _FullPhotoScreenState({@required this.url});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    if (url == null || url == '') {
      imageProvider = Image.asset(
        'images/img_not_available.jpeg',
        fit: BoxFit.cover,
      ).image;
    } else {
      imageProvider = CachedNetworkImageProvider(url);
    }

    return Container(
      child: PhotoView(
        imageProvider: imageProvider,
      ),
    );
  }
}
