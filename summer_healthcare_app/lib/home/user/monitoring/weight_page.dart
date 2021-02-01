import 'package:flutter/material.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';
import 'package:summer_healthcare_app/services/firebase/auth_service.dart';
import 'package:summer_healthcare_app/services/api/weight_services.dart';
import 'package:summer_healthcare_app/json/weight.dart';
import 'package:intl/intl.dart';
import 'package:summer_healthcare_app/home/user/monitoring/weight_graph_page.dart';

class WeightPage extends StatefulWidget {
  final bool appBar;
  final String uid;

  WeightPage({@required this.appBar, @required this.uid});

  @override
  _WeightPageState createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> with AutomaticKeepAliveClientMixin<WeightPage> {
  List<WeightList> weightList = [];
  List<Weight> allWeights;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    initializePage();
  }

  void initializePage() async {
    weightList = [];
    String token = await AuthService.getToken();
    allWeights =
        await WeightServices.getAllWeight(headerToken: token, uid: widget.uid);

    // sort the weights by date (in ascending order, i.e. first index is the start weight, last index is the current weight)
    allWeights.sort(
        (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

    final DateFormat formatter = DateFormat('dd/MM/yyyy');

    for (int i = 0; i < allWeights.length; i++) {
      TextEditingController weightController =
          TextEditingController(text: allWeights[i].weight);

      // comparison with the previous weight entry (check for index out of bounds)
      int ind;
      if (i > 0) {
        ind = i - 1;
      } else {
        ind = i;
      }

      // put the dates in a consistent format
      DateTime weightDate = DateTime.parse(allWeights[i].date);
      String formatDate = formatter.format(weightDate);

      // create the weightlist widget
      WeightList curWeight = WeightList(
        uid: widget.uid,
        currentDate: formatDate,
        weight: weightController,
        lastWeight: allWeights[ind].weight,
        callback:
            initializePage, // pass this function as callback in order to refresh current/start weight if edited
      );

      // push the widget into array and update
      weightList.add(curWeight);
    }
    setState(() {});
  }

  void showAddWeightPopUp() {
    TextEditingController weight = TextEditingController();
    String currentDate = DateTime.now().day.toString() +
        '/' +
        DateTime.now().month.toString() +
        '/' +
        DateTime.now().year.toString();
    String addWeightDate = DateTime.now().year.toString() +
        '/' +
        DateTime.now().month.toString() +
        '/' +
        DateTime.now().day.toString();
    showDialog<void>(
      context: context,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: Text('Weight Check In'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InputField(
                    hintText: '69',
                    controller: weight,
                    labelText: 'Weight (kg)',
                    keyboardType: TextInputType.number,
                  ),
                  Text(
                    'Date: $currentDate',
                    style: TextStyle(color: Colours.grey),
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('ADD WEIGHT'),
              onPressed: () async {
                Navigator.of(alertContext).pop();
                weightList.add(WeightList(
                  uid: widget.uid,
                  currentDate: currentDate,
                  weight: weight,
                  lastWeight: allWeights[allWeights.length - 1].weight,
                ));
                setState(() {});
                String token = await AuthService.getToken();
                await WeightServices.addWeight(
                    headerToken: token,
                    uid: widget.uid,
                    weight: weight.text,
                    date: addWeightDate);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colours.primaryColour,
        appBar: widget.appBar
            ? AppBar(
                backgroundColor: Colours.primaryColour,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          showAddWeightPopUp();
                        },
                        child: Icon(
                          Icons.add,
                          size: 26.0,
                          color: Colors.blue,
                        ),
                      ))
                ],
                title: Text(
                  'Weight',
                ),
                centerTitle: true,
                elevation: Dimensions.d_3,
              )
            : PreferredSize(
                child: Container(),
                preferredSize: Size.zero,
              ),
        body: (allWeights == null)
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(Dimensions.d_15),
                    child: Container(
                      color: Colours.white,
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.d_15),
                        child: Column(
                          children: <Widget>[
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        allWeights[0].weight,
                                        style: TextStyle(
                                            fontSize: FontSizes.biggerText),
                                      ),
                                      SizedBox(
                                        height: Dimensions.d_5,
                                      ),
                                      Text('Start Weight',
                                          style: TextStyle(
                                              fontSize: FontSizes.normalText))
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        allWeights[allWeights.length - 1]
                                            .weight,
                                        style: TextStyle(
                                            fontSize: FontSizes.biggerText),
                                      ),
                                      SizedBox(
                                        height: Dimensions.d_5,
                                      ),
                                      Text('Current Weight',
                                          style: TextStyle(
                                              fontSize: FontSizes.normalText))
                                    ],
                                  )
                                ]),
                            SizedBox(height: Dimensions.d_10),
                            Divider(
                              color: Colours.grey,
                              thickness: Dimensions.d_2,
                            ),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              reverse: true,
                              shrinkWrap: true,
                              itemCount: this.weightList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return index == 0
                                    ? this.weightList[index]
                                    : Column(
                                        children: [
                                          this.weightList[index],
                                          Divider(
                                            color: Colours.lighterGrey,
                                            thickness: Dimensions.d_1,
                                          )
                                        ],
                                      );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add Weight',
          child: Icon(
            Icons.stacked_bar_chart,
            size: Dimensions.d_35,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WeightGraphPage(
                  uid: widget.uid,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
