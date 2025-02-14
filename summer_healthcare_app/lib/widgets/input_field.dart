import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';

class InputField extends StatelessWidget {
  final isPassword;
  final labelText;
  final keyboardType;
  final isShortInput;
  final String hintText;
  final Color backgroundColour;
  final bool moreLines;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function onChanged;
  final readOnly;
  final autoFocus;

  InputField({this.isPassword = false, this.moreLines = false, this.labelText = '', this.hintText = '', this.keyboardType, this.isShortInput = false, this.backgroundColour, this.readOnly = false, @required this.controller, this.onChanged, this.focusNode, this.autoFocus = false});

  Widget build(BuildContext context) {
    return Padding(
        padding: isShortInput ? EdgeInsets.symmetric(vertical: Dimensions.d_30, horizontal: Dimensions.d_100) : EdgeInsets.symmetric(vertical: Dimensions.d_20),
        child: Material(
          color: backgroundColour == null ? Colours.white : backgroundColour,
          child: TextField(
              readOnly: readOnly,
              autofocus: autoFocus,
              controller: controller,
              focusNode: focusNode,
              obscureText: isPassword,
              keyboardType: keyboardType,
              onChanged: onChanged,
              maxLines: moreLines ? 4 : 1,
              maxLength: moreLines ? 150 : null,
              maxLengthEnforced: true,
              textAlign: isShortInput ? TextAlign.center : TextAlign.start,
              decoration: InputDecoration(
                contentPadding: Paddings.horizontal_5,
                hintText: hintText,
                hintStyle: TextStyle(color: Colours.grey),
                labelText: labelText,
                labelStyle: TextStyle(color: Colours.grey),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 3.0, color: Colours.secondaryColour)
                ),
              )),
        )
    );
  }
}
