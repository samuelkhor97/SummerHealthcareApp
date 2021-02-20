import 'package:flutter/material.dart';
import 'dart:math';

import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/json/biochemistry.dart';

class BiochemistryHistory extends StatelessWidget {
  final List<Biochemistry> history;

  BiochemistryHistory({@required this.history});

  final int firstColumnFlex = 2;
  final int valueColumnFlex = 2;
  final int lastColumnFlex = 1;

  @override
  Widget build(BuildContext context) {
    // only show at most 3 latest biochemistry
    final int maxNumberOfItem = min(3, this.history.length);
    final List<Biochemistry> lastNItems =
        this.history.sublist(this.history.length - maxNumberOfItem);
    Container body = Container(
      margin: Paddings.all_15,
      padding: Paddings.horizontal_10,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colours.grey,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          buildHeaderRow(biochemistryHistory: lastNItems),
          ...buildBodyRows(biochemistryHistory: lastNItems),
        ],
      ),
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colours.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Biochemistry History',
            style: TextStyle(
              fontSize: FontSizes.mainTitle,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colours.primaryColour,
        ),
        body: body,
      ),
    );
  }

  Expanded buildHeaderRow({List<Biochemistry> biochemistryHistory}) {
    List<Widget> dates = List<Expanded>.from(biochemistryHistory.map(
      (bio) {
        return Expanded(
          child: Text(bio.date, textAlign: TextAlign.center),
          flex: valueColumnFlex,
        );
      },
    ));
    dates.insert(0,
        Expanded(child: Text('Laboratory Parameter'), flex: firstColumnFlex));
    dates.add(Expanded(
      child: Container(),
      flex: lastColumnFlex,
    ));

    return Expanded(child: Row(children: dates));
  }

  List<Expanded> buildBodyRows({List<Biochemistry> biochemistryHistory}) {
    List<Expanded> bodyRows = [
      buildRow(
        label: 'Fasting blood sugar',
        labParam: 'fastingBloodSugar',
        values: List<String>.from(biochemistryHistory.map(
          (bio) => bio.fastingBloodSugar,
        )),
      ),
      buildRow(
        label: 'Random blood sugar',
        labParam: 'randomBloodSugar',
        values: List<String>.from(biochemistryHistory.map(
          (bio) => bio.randomBloodSugar,
        )),
      ),
      buildRow(
        label: '2-hr post prandial glucose',
        labParam: 'twoHrPostPrandialGlucose',
        values: List<String>.from(biochemistryHistory.map(
          (bio) => bio.twoHrPostPrandialGlucose,
        )),
      ),
      buildRow(
        label: 'Creatinine',
        labParam: 'creatinine',
        values: List<String>.from(biochemistryHistory.map(
          (bio) => bio.creatinine,
        )),
      ),
      buildRow(
        label: 'HDL',
        labParam: 'hdl',
        values: List<String>.from(biochemistryHistory.map(
          (bio) => bio.hdl,
        )),
      ),
      buildRow(
        label: 'LDL',
        labParam: 'ldl',
        values: List<String>.from(biochemistryHistory.map(
          (bio) => bio.ldl,
        )),
      ),
      buildRow(
        label: 'Triglyceride',
        labParam: 'triglyceride',
        values: List<String>.from(biochemistryHistory.map(
          (bio) => bio.triglyceride,
        )),
      ),
      buildRow(
        label: 'HDL/LDL Ratio',
        labParam: 'hdlLdlRatio',
        values: List<String>.from(biochemistryHistory.map(
          (bio) => bio.hdlLdlRatio,
        )),
      ),
      buildRow(
        label: 'HbA1c',
        labParam: 'hba1c',
        values: List<String>.from(biochemistryHistory.map(
          (bio) => bio.hba1c,
        )),
      ),
      buildRow(
        label: 'Total cholesterol',
        labParam: 'totalCholesterol',
        values: List<String>.from(biochemistryHistory.map(
          (bio) => bio.totalCholesterol,
        )),
      ),
    ];
    return bodyRows;
  }

  Expanded buildRow({String label, String labParam, List<String> values}) {
    return Expanded(
      child: Column(
        children: [
          Expanded(child: Divider(thickness: 0.7,), flex: 1,),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(label, style: TextStyle(fontSize: FontSizes.smallText),),
                  flex: firstColumnFlex,
                ),
                ...List<Expanded>.from(values.map(
                  (value) => Expanded(
                    child: Text(
                      value ?? '',
                      textAlign: TextAlign.center,
                    ),
                    flex: valueColumnFlex,
                  ),
                )),
                Expanded(
                  child: Text(
                    Biochemistry.units[labParam],
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 11),
                  ),
                  flex: lastColumnFlex,
                ),
              ],
            ),
            flex: 5
          ),
        ],
      ),
    );
  }
}
