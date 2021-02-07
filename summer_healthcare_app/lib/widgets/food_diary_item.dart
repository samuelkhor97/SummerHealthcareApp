import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FoodDiaryItem extends StatefulWidget {
  final String name;
  final String calories;
  final String picture;

  FoodDiaryItem({this.name, this.calories, this.picture});

  @override
  _FoodDiaryItemState createState() => _FoodDiaryItemState();
}

class _FoodDiaryItemState extends State<FoodDiaryItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.fastfood_outlined),
        onPressed: () {
          getImage(context: context, imageSource: ImageSource.camera);
        },
        color: Colours.secondaryColour,
      ),
      title: Text(
        widget.name,
      ),
      trailing: Text(
        widget.calories + ' kcal',
      ),
    );
  }


  Future getImage({BuildContext context, ImageSource imageSource}) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: imageSource);

    if (pickedFile != null) {
      // String fileName =
      //     'images/groups/$groupId/users/$id/${DateTime.now().toString()}';

      File imageFile = File(pickedFile.path);
      // showLoadingAnimation(context: context);
      File compressedFile = await compressFile(file: imageFile);
      // await uploadFile(file: compressedFile ?? imageFile, fileName: fileName);
      // Navigator.pop(context);
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
}
