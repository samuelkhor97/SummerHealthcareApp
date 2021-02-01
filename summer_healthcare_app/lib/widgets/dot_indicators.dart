import 'package:flutter/material.dart';

import 'package:summer_healthcare_app/constants.dart';

class DotIndicators extends StatefulWidget {
  final int count;
  final int selectedIndex;

  DotIndicators({@required this.count, this.selectedIndex = 0})
      : assert(count > 0);

  @override
  _DotIndicatorsState createState() => _DotIndicatorsState();
}

class _DotIndicatorsState extends State<DotIndicators> {
  List<Widget> dotList = [];
  int previousSelectedIndex;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.count; i++) {
      dotList.add(
        i == widget.selectedIndex
            ? DotIndicator(isActive: true)
            : DotIndicator(isActive: false),
      );
    }
    previousSelectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    if (previousSelectedIndex != widget.selectedIndex) {
      dotList[previousSelectedIndex] = DotIndicator(isActive: false);
      dotList[widget.selectedIndex] = DotIndicator(isActive: true);
    }

    previousSelectedIndex = widget.selectedIndex;

    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: dotList,
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  final bool isActive;

  DotIndicator({@required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.d_10,
      width: Dimensions.d_10,
      padding: Paddings.all_1,
      margin: EdgeInsets.symmetric(horizontal: Dimensions.d_2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colours.black),
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? Colours.black : Colours.white,
        ),
      ),
    );
  }
}
