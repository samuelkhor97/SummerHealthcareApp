import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/json/food_diary_card.dart';
import 'package:summer_healthcare_app/services/api/food_diary_services.dart';
import 'package:summer_healthcare_app/services/firebase/auth_service.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';

class DiaryPage extends StatefulWidget {
  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  List<DiaryCard> cardList = [];
  DateTime currentDate;
  String authToken;
  List<FoodDiaryCard> foodDiaries;

  @override
  void initState() {
    super.initState();
    initializePage();
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  void initializePage() async {
    String token = await AuthService.getToken();
    List<FoodDiaryCard> diaries = await FoodDiaryServices().getAllCards(
      headerToken: token,
      date: _getFormattedDate(DateTime.now()));
    print('Auth Token: $token');
    setState(() {
      authToken = token;
      foodDiaries = diaries;
      currentDate = DateTime.now();
      _refreshCards();
    });
  }

  String _getFormattedDate(DateTime date) {
    if (date.month < 10) {
      return date.year.toString() + "-0" + date.month.toString() + "-" + date.day.toString();
    }
    return date.year.toString() + "-" + date.month.toString() + "-" + date.day.toString();
  }

  void _refreshCards() {
    cardList.clear();
    for (int i = 0; i < foodDiaries.length; i++) {
      cardList.add(DiaryCard(title: foodDiaries[i].cardName, foodDiaryCard: foodDiaries[i],));
    }
    print(cardList);
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
                foodDiaries = await FoodDiaryServices().getAllCards(
                    headerToken: authToken,
                    date: _getFormattedDate(selectedDate));
                setState(() {
                  _refreshCards();
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
                  await FoodDiaryServices().createCard(
                    headerToken: authToken,
                    date: _getFormattedDate(currentDate),
                    cardName: entryName.text
                  );
                  foodDiaries = await FoodDiaryServices().getAllCards(
                      headerToken: authToken,
                      date: _getFormattedDate(currentDate));
                  setState(() {
                    _refreshCards();
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return (authToken == null && foodDiaries == null) ? Center(child: CircularProgressIndicator(),) : Scaffold(
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
