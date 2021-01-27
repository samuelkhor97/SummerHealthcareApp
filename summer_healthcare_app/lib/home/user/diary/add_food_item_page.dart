import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/json/food_item.dart';
import 'package:summer_healthcare_app/services/api/food_diary_services.dart';
import 'package:summer_healthcare_app/services/firebase/auth_service.dart';

class AddFoodItemPage extends StatefulWidget {
  @override
  _AddFoodItemPageState createState() => _AddFoodItemPageState();
}

class _AddFoodItemPageState extends State<AddFoodItemPage> {
  TextEditingController _controller = TextEditingController();
  List<FoodItem> foodDiaries;
  List<FoodItem> foodDiariesFilterList;
  bool loadingFoodItems = true;

  @override
  void initState() {
    super.initState();
    getAllFoodData();
  }

  void getAllFoodData() async {
    String authToken = await AuthService.getToken();
    List<FoodItem> diaries =
        await FoodDiaryServices().getAllFoodItems(headerToken: authToken);
    setState(() {
      foodDiaries = diaries;
      loadingFoodItems = false;
    });
  }

  void filterFoodItems({String text}) {
    foodDiariesFilterList = [];
    for (int index = 0; index < foodDiaries.length; index++) {
      if (foodDiaries[index]
          .foodName
          .toLowerCase()
          .contains(text.toLowerCase())) {
        foodDiariesFilterList.add(foodDiaries[index]);
      }
    }
  }

  void showFoodItemConfirmation({FoodItem foodItem}) {
    showDialog<TextEditingController>(
        context: context,
        builder: (BuildContext alertContext) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Add This Food Item?'),
            actions: <Widget>[
              FlatButton(
                child: Text('YES'),
                onPressed: () async {
                  Navigator.of(alertContext).pop();
                  Navigator.pop(context, foodItem);
                },
              ),
              FlatButton(
                child: Text('NO'),
                onPressed: () async {
                  Navigator.of(alertContext).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (foodDiaries != null && foodDiariesFilterList == null) {
      filterFoodItems(text: '');
    }
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colours.white,
      appBar: AppBar(
        backgroundColor: Colours.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Food Search',
        ),
        centerTitle: true,
        elevation: 1.0,
      ),
      body: loadingFoodItems
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Container(
                  color: Colours.white,
                  height: Dimensions.d_95,
                  child: TextField(
                    controller: _controller,
                    onChanged: (String text) {
                      setState(() {
                        filterFoodItems(text: text);
                      });
                    },
                    decoration: InputDecoration(
                      fillColor: Colours.grey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(Dimensions.d_30),
                        ),
                      ),
                      labelText: 'Search For Food',
                      icon: Icon(
                        Icons.search,
                        color: Colours.black,
                        size: Dimensions.d_30,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.all(Dimensions.d_25),
                ),
                Divider(
                  height: Dimensions.d_0,
                  thickness: Dimensions.d_10,
                  color: Colours.lightGrey,
                ),
                Expanded(
                  child: ListView.separated(
                      padding: EdgeInsets.all(Dimensions.d_10),
                      itemCount: foodDiariesFilterList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.all(Dimensions.d_10),
                          child: ListTile(
                            title: Text(foodDiariesFilterList[index].foodName),
                            trailing:
                                Text(foodDiariesFilterList[index].calories),
                            onTap: () {
                              showFoodItemConfirmation(
                                  foodItem: foodDiariesFilterList[index]);
                            },
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Padding(
                            padding: EdgeInsets.all(Dimensions.d_5),
                            child: Divider(
                              height: Dimensions.d_2,
                              thickness: Dimensions.d_2,
                              color: Colours.lightGrey,
                            ),
                          )),
                ),
              ],
            ),
    ));
  }
}
