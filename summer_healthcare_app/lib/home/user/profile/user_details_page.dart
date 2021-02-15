import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/home/user/pharmacist/biochemistry_history_page.dart';
import 'package:summer_healthcare_app/json/biochemistry.dart';
import 'package:summer_healthcare_app/json/medical_history.dart';
import 'package:summer_healthcare_app/json/user.dart';
import 'package:summer_healthcare_app/services/api/user_services.dart';
import 'package:summer_healthcare_app/main.dart' show preferences;
import 'package:summer_healthcare_app/services/firebase/auth_service.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';

class UserDetailsPage extends StatefulWidget {
  final String patientUserId;
  final bool appBar;
  final bool pharmacistView;

  UserDetailsPage(
      {this.patientUserId, this.appBar = false, this.pharmacistView = false});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage>
    with AutomaticKeepAliveClientMixin<UserDetailsPage> {
  bool loadingUserDetails = true;

  String myUserId;
  String patientUserId;
  User userDetails;

  TextEditingController bodyFatController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    myUserId = preferences.getString('id');
    patientUserId = widget.patientUserId;
    getUserDetails();
  }

  @override
  void dispose() {
    super.dispose();
    bodyFatController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // check for empty list, no previous biochemistry record
    Biochemistry newBiochemistry;
    if (!loadingUserDetails) {
      if (userDetails.biochemistry.length == 0) {
        newBiochemistry =
            Biochemistry(date: DateFormat('dd-MM-yyyy').format(DateTime.now()));
      } else {
        newBiochemistry = Biochemistry.clone(userDetails.biochemistry.last);
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: widget.appBar
            ? AppBar(
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
                  widget.pharmacistView
                      ? 'Patient\'s Details'
                      : 'User\'s Details',
                  style: TextStyle(
                    fontSize: FontSizes.mainTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colours.primaryColour,
              )
            : PreferredSize(
                child: Container(),
                preferredSize: Size.zero,
              ),
        body: loadingUserDetails
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colours.secondaryColour),
                ),
              )
            : ListView(
                children: [
                  // TODO: make input fields like marital status to take in limited options just
                  // like in signuppage (hasnt been implemented as of now)
                  buildInputField(
                    readOnly: true,
                    labelText: 'Full Name',
                    valueText: userDetails.fullName,
                  ),
                  buildInputField(
                    readOnly: true,
                    labelText: 'Mobile Phone Number',
                    valueText: userDetails.phoneNum,
                  ),
                  buildInputField(
                    readOnly: true,
                    labelText: 'Weight (kg)',
                    valueText: userDetails.weight,
                  ),
                  buildInputField(
                    readOnly: widget.pharmacistView,
                    labelText: 'Height (cm)',
                    valueText: userDetails.height,
                    keyboardType: TextInputType.number,
                    onChanged: (String newValue) {
                      userDetails.height = newValue;
                    },
                  ),
                  buildInputField(
                    readOnly: true,
                    labelText: 'Age',
                    valueText: userDetails.age?.toString() ?? '',
                  ),
                  buildInputField(
                    readOnly: true,
                    labelText: 'Gender',
                    valueText: userDetails.gender,
                  ),
                  buildInputField(
                    readOnly: true,
                    labelText: 'Body Mass Index (BMI)',
                    valueText: (userDetails.height != null &&
                            userDetails.weight != null)
                        ? calcBMI(
                            height: double.tryParse(userDetails.height) ?? 1,
                            weight: double.tryParse(userDetails.weight) ?? 0,
                          )
                        : '',
                  ),
                  buildInputField(
                    readOnly: true,
                    labelText: 'Ethnicity',
                    valueText: userDetails.ethnicity,
                  ),
                  buildInputField(
                    readOnly: widget.pharmacistView,
                    labelText: 'Education status',
                    valueText: userDetails.educationStatus,
                    onChanged: (String newValue) {
                      userDetails.educationStatus = newValue;
                    },
                  ),
                  buildInputField(
                    readOnly: widget.pharmacistView,
                    labelText: 'Employment Status',
                    valueText: userDetails.employmentStatus,
                    onChanged: (String newValue) {
                      userDetails.employmentStatus = newValue;
                    },
                  ),
                  buildInputField(
                    readOnly: widget.pharmacistView,
                    labelText: 'Occupation',
                    valueText: userDetails.occupation,
                    onChanged: (String newValue) {
                      userDetails.occupation = newValue;
                    },
                  ),
                  buildInputField(
                    readOnly: widget.pharmacistView,
                    labelText: 'Marital Status',
                    valueText: userDetails.maritalStatus,
                    onChanged: (String newValue) {
                      userDetails.maritalStatus = newValue;
                    },
                  ),
                  buildInputField(
                    readOnly: true,
                    labelText: 'Smoker?',
                    valueText: userDetails.smoker?.toString() ?? '',
                  ),
                  buildInputField(
                    readOnly: widget.pharmacistView,
                    labelText: 'Number of Cigarettes per Day',
                    valueText: userDetails.cigsPerDay?.toString() ?? '',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (String newValue) {
                      userDetails.cigsPerDay = int.tryParse(newValue) ?? 0;
                    },
                  ),
                  buildInputField(
                    readOnly: true,
                    labelText: 'Using e-Cigarette?',
                    valueText: userDetails.eCig?.toString() ?? '',
                  ),
                  Padding(
                    child: Text(
                      'Filled by Pharmacist:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: FontSizes.title,
                      ),
                    ),
                    padding: Paddings.all_15,
                  ),
                  buildInputField(
                    readOnly: widget.pharmacistView ? false : true,
                    labelText: 'Body Fat Percentage (%)',
                    valueText: userDetails.bodyFatPercentage?.toString() ?? '',
                    onChanged: (String newValue) {
                      userDetails.bodyFatPercentage = newValue;
                    },
                    keyboardType: TextInputType.number,
                    paddings: Paddings.all_15,
                  ),
                  Padding(
                    child: Text(
                      'Medical History',
                      style: TextStyle(
                        fontSize: FontSizes.biggerText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    padding: Paddings.all_15,
                  ),
                  buildMedicalTable(medicalHistory: userDetails.medicalHistory),
                  Padding(
                    child: Text(
                      'Biochemistry',
                      style: TextStyle(
                        fontSize: FontSizes.biggerText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    padding: Paddings.all_15,
                  ),
                  buildBiochemistryTable(biochemistry: newBiochemistry),
                  UserButton(
                    text: 'View Biochemistry History',
                    color: Colours.secondaryColour,
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.d_65,
                      vertical: Dimensions.d_10,
                    ),
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BiochemistryHistory(
                            history: userDetails.biochemistry,
                          ),
                        ),
                      );
                    },
                  ),
                  UserButton(
                    text: 'Update',
                    color: Colours.secondaryColour,
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.d_65,
                      vertical: Dimensions.d_10,
                    ),
                    onClick: () {
                      updateData(
                        user: userDetails,
                        newBiochemistry: newBiochemistry,
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }

  Container buildMedicalTable({MedicalHistory medicalHistory}) {
    // reflection is not supported in dart, hence the redundant code,
    // when there is better alternative, please refactor code below
    List<Widget> rows = [
      Row(
        children: [
          Expanded(
            child: Text(
              'Code',
              textAlign: TextAlign.center,
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              child: Text('System'),
              padding: Paddings.horizontal_10,
            ),
            flex: 8,
          ),
          Expanded(
            child: Text('Yes', textAlign: TextAlign.center),
            flex: 2,
          ),
          Expanded(
            child: Text('No', textAlign: TextAlign.center),
            flex: 2,
          ),
        ],
      ),
      buildMedicalRow(
        label: 'Cardiovascular',
        system: 'cardiovascular',
        currentValue: medicalHistory.cardiovascular,
        onChanged: (bool newValue) {
          setState(() {
            medicalHistory.cardiovascular = newValue;
          });
        },
      ),
      buildMedicalRow(
        label: 'Respiratory',
        system: 'respiratory',
        currentValue: medicalHistory.respiratory,
        onChanged: (bool newValue) {
          setState(() {
            medicalHistory.respiratory = newValue;
          });
        },
      ),
      buildMedicalRow(
        label: 'Hepato-biliary',
        system: 'hepatoBiliary',
        currentValue: medicalHistory.hepatoBiliary,
        onChanged: (bool newValue) {
          setState(() {
            medicalHistory.hepatoBiliary = newValue;
          });
        },
      ),
      buildMedicalRow(
        label: 'Gastro-intestinal',
        system: 'gastroIntestinal',
        currentValue: medicalHistory.gastroIntestinal,
        onChanged: (bool newValue) {
          setState(() {
            medicalHistory.gastroIntestinal = newValue;
          });
        },
      ),
      buildMedicalRow(
        label: 'Genito-urinary',
        system: 'genitoUrinary',
        currentValue: medicalHistory.genitoUrinary,
        onChanged: (bool newValue) {
          setState(() {
            medicalHistory.genitoUrinary = newValue;
          });
        },
      ),
      buildMedicalRow(
        label: 'Endocrine',
        system: 'endocrine',
        currentValue: medicalHistory.endocrine,
        onChanged: (bool newValue) {
          setState(() {
            medicalHistory.endocrine = newValue;
          });
        },
      ),
      buildMedicalRow(
        label: 'Haematological',
        system: 'haematological',
        currentValue: medicalHistory.haematological,
        onChanged: (bool newValue) {
          setState(() {
            medicalHistory.haematological = newValue;
          });
        },
      ),
      buildMedicalRow(
        label: 'Musculo-skeletal',
        system: 'musculoSkeletal',
        currentValue: medicalHistory.musculoSkeletal,
        onChanged: (bool newValue) {
          setState(() {
            medicalHistory.musculoSkeletal = newValue;
          });
        },
      ),
      buildMedicalRow(
        label: 'Neoplasia',
        system: 'neoplasia',
        currentValue: medicalHistory.neoplasia,
        onChanged: (bool newValue) {
          setState(() {
            medicalHistory.neoplasia = newValue;
          });
        },
      ),
      buildMedicalRow(
        label: 'Neurological',
        system: 'neurological',
        currentValue: medicalHistory.neurological,
        onChanged: (bool newValue) {
          setState(() {
            medicalHistory.neurological = newValue;
          });
        },
      ),
      buildMedicalRow(
        label: 'Psychological',
        system: 'psychological',
        currentValue: medicalHistory.psychological,
        onChanged: (bool newValue) {
          setState(() {
            medicalHistory.psychological = newValue;
          });
        },
      ),
      buildMedicalRow(
        label: 'Immunological',
        system: 'immunological',
        currentValue: medicalHistory.immunological,
        onChanged: (bool newValue) {
          setState(() {
            medicalHistory.immunological = newValue;
          });
        },
      ),
      buildMedicalRow(
        label: 'Dermatological',
        system: 'dermatological',
        currentValue: medicalHistory.dermatological,
        onChanged: (bool newValue) {
          setState(() {
            medicalHistory.dermatological = newValue;
          });
        },
      ),
      buildMedicalRow(
        label: 'Allergies',
        system: 'allergies',
        currentValue: medicalHistory.allergies,
        onChanged: (bool newValue) {
          setState(() {
            medicalHistory.allergies = newValue;
          });
        },
      ),
      buildMedicalRow(
        label: 'Eyes, ear, nose, throat',
        system: 'eyesEarNoseThroat',
        currentValue: medicalHistory.eyesEarNoseThroat,
        onChanged: (bool newValue) {
          setState(() {
            medicalHistory.eyesEarNoseThroat = newValue;
          });
        },
      ),
      SizedBox(
        height: Dimensions.d_45,
        child: Row(children: [
          Expanded(
            child: Text(
              MedicalHistory.codes['other'],
              textAlign: TextAlign.center,
            ),
            flex: 2,
          ),
          Expanded(
            child: buildInputField(
                labelText: 'Other',
                valueText: medicalHistory.other,
                readOnly: widget.pharmacistView ? false : true,
                onChanged: (String newValue) {
                  medicalHistory.other = newValue;
                },
                paddings: Paddings.horizontal_10),
            flex: 12,
          ),
        ]),
      ),
      SizedBox(
        height: Dimensions.d_25,
      )
    ];

    return Container(
      margin: Paddings.all_15,
      padding: Paddings.horizontal_10,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colours.grey,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: rows,
      ),
    );
  }

  Row buildMedicalRow(
      {String label, String system, bool currentValue, Function onChanged}) {
    return Row(
      children: [
        Expanded(
          child:
              Text(MedicalHistory.codes[system], textAlign: TextAlign.center),
          flex: 2,
        ),
        Expanded(
          child: Container(
            child: Text(label),
            padding: Paddings.horizontal_10,
          ),
          flex: 8,
        ),
        Expanded(
          child: SizedBox(
            height: Dimensions.d_45,
            width: Dimensions.d_45,
            child: Radio<bool>(
              value: true,
              groupValue: currentValue,
              onChanged: widget.pharmacistView ? onChanged : null,
            ),
          ),
          flex: 2,
        ),
        Expanded(
          child: SizedBox(
            height: Dimensions.d_45,
            width: Dimensions.d_45,
            child: Radio<bool>(
              value: false,
              groupValue: currentValue,
              onChanged: widget.pharmacistView ? onChanged : null,
            ),
          ),
          flex: 2,
        ),
      ],
    );
  }

  Container buildBiochemistryTable({Biochemistry biochemistry}) {
    List<Widget> rows = [
      Row(
        children: [
          Expanded(
            child: Text('Laboratory Parameter'),
            flex: 5,
          ),
          Expanded(
            child: Container(
              child: Text('Value', textAlign: TextAlign.center),
            ),
            flex: 3,
          ),
          Expanded(
            child: Text('Unit', textAlign: TextAlign.center),
            flex: 2,
          ),
        ],
      ),
      SizedBox(
        height: Dimensions.d_10,
      ),
      buildBiochemistryRow(
        label: 'Fasting blood sugar',
        labParam: 'fastingBloodSugar',
        value: biochemistry.fastingBloodSugar,
        onChanged: (String newValue) {
          biochemistry.fastingBloodSugar = newValue;
        },
      ),
      buildBiochemistryRow(
        label: 'Random blood sugar',
        labParam: 'randomBloodSugar',
        value: biochemistry.randomBloodSugar,
        onChanged: (String newValue) {
          biochemistry.randomBloodSugar = newValue;
        },
      ),
      buildBiochemistryRow(
        label: '2-hr post prandial glucose',
        labParam: 'twoHrPostPrandialGlucose',
        value: biochemistry.twoHrPostPrandialGlucose,
        onChanged: (String newValue) {
          biochemistry.twoHrPostPrandialGlucose = newValue;
        },
      ),
      buildBiochemistryRow(
        label: 'Creatinine',
        labParam: 'creatinine',
        value: biochemistry.creatinine,
        onChanged: (String newValue) {
          biochemistry.creatinine = newValue;
        },
      ),
      buildBiochemistryRow(
        label: 'HDL',
        labParam: 'hdl',
        value: biochemistry.hdl,
        onChanged: (String newValue) {
          biochemistry.hdl = newValue;
        },
      ),
      buildBiochemistryRow(
        label: 'LDL',
        labParam: 'ldl',
        value: biochemistry.ldl,
        onChanged: (String newValue) {
          biochemistry.ldl = newValue;
        },
      ),
      buildBiochemistryRow(
        label: 'Triglyceride',
        labParam: 'triglyceride',
        value: biochemistry.triglyceride,
        onChanged: (String newValue) {
          biochemistry.triglyceride = newValue;
        },
      ),
      buildBiochemistryRow(
        label: 'HDL/LDL Ratio',
        labParam: 'hdlLdlRatio',
        value: biochemistry.hdlLdlRatio,
        onChanged: (String newValue) {
          biochemistry.hdlLdlRatio = newValue;
        },
      ),
      buildBiochemistryRow(
        label: 'HbA1c',
        labParam: 'hba1c',
        value: biochemistry.hba1c,
        onChanged: (String newValue) {
          biochemistry.hba1c = newValue;
        },
      ),
      buildBiochemistryRow(
        label: 'Total cholesterol',
        labParam: 'totalCholesterol',
        value: biochemistry.totalCholesterol,
        onChanged: (String newValue) {
          biochemistry.totalCholesterol = newValue;
        },
      ),
      SizedBox(
        height: Dimensions.d_25,
      )
    ];

    return Container(
      margin: Paddings.all_15,
      padding: Paddings.horizontal_10,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colours.grey,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: rows,
      ),
    );
  }

  Row buildBiochemistryRow(
      {String label, String labParam, String value, Function onChanged}) {
    return Row(
      children: [
        Expanded(
          child: Text(label),
          flex: 5,
        ),
        Expanded(
          child: buildInputField(
              keyboardType: TextInputType.number,
              valueText: value,
              readOnly: widget.pharmacistView ? false : true,
              onChanged: onChanged,
              paddings: Paddings.horizontal_5,
              textAlign: TextAlign.center),
          flex: 3,
        ),
        Expanded(
          child: Container(
            child: Text(
              Biochemistry.units[labParam],
              textAlign: TextAlign.center,
            ),
          ),
          flex: 2,
        ),
      ],
    );
  }

  void getUserDetails() async {
    String authToken = await AuthService.getToken();
    User details = await UserServices.getUserById(
        headerToken: authToken, userId: patientUserId);
    setState(() {
      userDetails = details;
      loadingUserDetails = false;
    });
  }

  void updateData({User user, Biochemistry newBiochemistry}) async {
    if (widget.pharmacistView) {
      bool allValueEmpty = true;
      Map tempJson = newBiochemistry.toJson();
      tempJson.remove('date');
      for (String value in tempJson.values) {
        if (value != null && value.isNotEmpty) {
          allValueEmpty = false;
        }
      }
      // only push the newBiochemistry into biochemistry list if not all of the
      // values empty (at least one is not empty while excluding date field)
      if (!allValueEmpty) {
        String lastBiochemistryDate =
            user.biochemistry.length == 0 ? null : user.biochemistry.last.date;
        // ensure only one set of biochemistry record exists for each day
        if (newBiochemistry.date == lastBiochemistryDate) {
          user.biochemistry.last = newBiochemistry;
        } else {
          user.biochemistry.add(newBiochemistry);
        }
      }
    }
    Map<String, dynamic> userJson = user.toJson();
    userJson.remove('uid');
    userJson.remove('pharmacy_id');

    if (!widget.pharmacistView) {
      // if it is viewed by normal patient user, do not allow update of fields below
      userJson.remove('body_fat_percentage');
      userJson.remove('medical_history');
      userJson.remove('medication');
      userJson.remove('biochemistry');
    }

    String authToken = await AuthService.getToken();
    UserServices.updateUserById(
      headerToken: authToken,
      userId: patientUserId,
      updateValues: userJson,
    )
        .then(
          (response) => Fluttertoast.showToast(msg: 'Update success'),
        )
        .catchError(
          (err) =>
              Fluttertoast.showToast(msg: 'Update failed: ${err.toString()}'),
        );
  }
}

Padding buildInputField(
    {String labelText,
    String valueText,
    bool readOnly,
    TextInputType keyboardType,
    Function onChanged,
    EdgeInsetsGeometry paddings,
    TextAlign textAlign,
    List<TextInputFormatter> inputFormatters}) {
  String initialValue =
      (valueText == null || valueText.isEmpty) ? null : valueText;

  return Padding(
    padding: paddings ?? Paddings.all_10,
    child: TextFormField(
      textAlign: textAlign ?? TextAlign.left,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      onChanged: onChanged,
      readOnly: readOnly,
      initialValue: initialValue,
      style: initialValue == 'null'
          ? TextStyle(color: Colours.grey, fontStyle: FontStyle.italic)
          : null,
      decoration: InputDecoration(
        contentPadding: Paddings.horizontal_5,
        labelText: labelText,
        labelStyle: TextStyle(color: Colours.grey),
        border: readOnly ? InputBorder.none : null,
      ),
    ),
  );
}

String calcBMI({double weight, double height}) {
  double bmiValue = weight / ((height / 100) * (height / 100));
  String bmiString = bmiValue.toStringAsFixed(1);

  return bmiString;
}
