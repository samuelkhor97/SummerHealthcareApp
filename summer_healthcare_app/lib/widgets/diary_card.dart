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
    return Padding(
      padding: EdgeInsets.only(left: Dimensions.d_15, top: Dimensions.d_15, right: Dimensions.d_15),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(Dimensions.d_10),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          size: Dimensions.d_20,
                        )
                      ],
                    ),
                    onTap: () {},
                  ),
                  InkWell(
                    child: Text(
                      'Add Item',
                      style: TextStyle(
                        color: Colours.secondaryColour,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline
                      ),
                    ),
                    onTap: () {
                      print('add item');
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
