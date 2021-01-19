import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';

class DiaryCard extends StatefulWidget {
  final String title;

  DiaryCard(
      {Key key,
        this.title,
      })
      : super(key: key);


  @override
  _DiaryCardState createState() => _DiaryCardState();
}

class _DiaryCardState extends State<DiaryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.white,
      child: Column(
        children: <Widget>[
          Row(
            children: [
              InkWell(
                child: Row(
                  children: <Widget>[
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: Colours.black,
                        fontWeight: FontWeight.bold,
                        fontSize: FontSizes.biggerText
                      ),
                    ),
                    SizedBox(width: Dimensions.d_10)
                    ,
                    Icon(
                      Icons.create,
                      color: Colours.black,
                    )

                  ],
                ),
                onTap: () {},
              )
            ],
          )
        ],
      ),
    );
  }
}
