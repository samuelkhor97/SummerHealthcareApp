import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';

class DiaryPage extends StatefulWidget {
  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  List<DiaryCard> cardList;
  DateTime currentDate;

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  Future<DateTime> _pickDate(DateTime initDate) async {
    DateTime selectedDate = await showDatePicker(
        context: context,
        initialDate: initDate,
        firstDate: DateTime(1910),
        lastDate: DateTime.now());
    return selectedDate;
  }

  Widget _datePickerField() {
    return StatefulBuilder(builder: (context, setBuilderState) {
      return Padding(
        padding: EdgeInsets.fromLTRB(Dimensions.d_20, Dimensions.d_10, Dimensions.d_20, 0),
        child: Ink(
          decoration: BoxDecoration(
              color: Colours.white,
              borderRadius: BorderRadius.all(Radius.circular(Dimensions.d_10)),
              border: Border.all(color: Colours.grey),
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.d_10)),
            title: Text(
             DateFormat('EEEE').format(currentDate) + ', ' +  DateFormat('dd-MM-yyyy').format(currentDate),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colours.black,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Icon(Icons.calendar_today_sharp),
            onTap: () async {
              DateTime selectedDate = await _pickDate(currentDate);
              if (selectedDate != null) {
                setState(() {
                  currentDate = selectedDate;
                });
              }
            },
          ),
        ),
      );
    });
  }

  void showDiaryEntryPopUp() {
    TextEditingController entryName = TextEditingController();

    showDialog<TextEditingController>(
        context: context,
        builder: (BuildContext alertContext) {
          return AlertDialog(
            title: Text('Add Diary Entry'),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InputField(
                        controller: entryName,
                        hintText: 'Breakfast',
                        keyboardType: TextInputType.text,
                      ),
                    ],
                  );
                }),
            actions: <Widget>[
              FlatButton(
                child: Text('Add'),
                onPressed: () async {
                  Navigator.of(alertContext).pop();
                  setState(() {
                    cardList.add(DiaryCard(
                      title: entryName,
                    ));
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    if (cardList == null) {
      cardList = [
        DiaryCard(
          title: TextEditingController(text: 'Breakfast'),
        )
      ];
    }

    return Scaffold(
      backgroundColor: Colours.primaryColour,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add diary entry',
        child: Icon(
          Icons.add,
          size: Dimensions.d_35,
        ),
        onPressed: () {
          showDiaryEntryPopUp();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: ListView(
        children: <Widget>[
          _datePickerField(),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: this.cardList.length,
            itemBuilder: (BuildContext context, int index) {
              return this.cardList[index];
            },
          )
        ],
      ),
    );
  }
}
