import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:summer_healthcare_app/constants.dart';
import 'package:summer_healthcare_app/landing/user_details.dart';
import 'package:summer_healthcare_app/widgets/widgets.dart';
import 'package:summer_healthcare_app/landing/user_signup_page_2.dart';

class UserSignUpPage1 extends StatefulWidget {
  @override
  _UserSignUpPage1State createState() => _UserSignUpPage1State();
}

class _UserSignUpPage1State extends State<UserSignUpPage1> {
  String verificationId;
  bool codeSent = false;
  UserDetails userDetails;
  bool isButtonDisabled = true;
  DateTime currentDate;

  @override
  void initState() {
    super.initState();
    userDetails = UserDetails();
  }

  @override
  void dispose() {
    super.dispose();
    userDetails.disposeTexts();
    print('Disposed text editor');
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  bool allFieldsFilled() {
    bool fieldCheck = userDetails.phoneNumber.text.isNotEmpty &&
        userDetails.fullName.text.isNotEmpty &&
        userDetails.gender != null;

    return fieldCheck && userDetails.age.text.isNotEmpty;
  }

  void checkAllInformationFilled({bool checkBox}) {
    if (checkBox == true || allFieldsFilled() == true)
      isButtonDisabled = false;
    else
      isButtonDisabled = true;
  }

  Future<DateTime> _pickDate({bool isStart = true}) async {
    DateTime selectedDate =
    await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1910),
        lastDate: DateTime.now()
    );
    return selectedDate;
  }

  Widget _datePickerField() {
    return StatefulBuilder(builder: (context, setBuilderState) {
      return Ink(
        decoration:BoxDecoration(
            color: Colours.white,
            borderRadius: BorderRadius.all(Radius.circular(Dimensions.d_10))
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.d_10)),
          title: Text(
            currentDate == null ?
            'Select Date' :
            DateFormat('dd-MM-yyyy').format(currentDate),
            style: TextStyle(
              color: currentDate == null ? Colours.grey : Colours.black
            ),
          ),
          trailing: Icon(Icons.keyboard_arrow_down),
          onTap: () async {
            DateTime selectedDate = await _pickDate();
            if (selectedDate != null) {
              setState(() {
                currentDate = selectedDate;
                userDetails.setAge(dateOfBirth: currentDate);
                checkAllInformationFilled(checkBox: userDetails.termsAndConditions);
              });
            }
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colours.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Registration',
            ),
            centerTitle: true,
            elevation: 0.0,
          ),
          backgroundColor: Colours.white,
          body: ListView(
            children: <Widget>[
              Padding(
                padding: Paddings.signUpPage,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    InputField(
                      controller: userDetails.fullName,
                      labelText: 'Full Name',
                      onChanged: (String text) {
                        setState(() {
                          checkAllInformationFilled(checkBox: userDetails.termsAndConditions);
                        });
                      },
                    ),
                    InputField(
                      hintText: '+60123456789',
                      controller: userDetails.phoneNumber,
                      labelText: 'Mobile Phone Number',
                      keyboardType: TextInputType.phone,
                      onChanged: (String text) {
                        setState(() {
                          checkAllInformationFilled(checkBox: userDetails.termsAndConditions);
                        });
                      },
                    ),
                    InputField(
                      hintText: '69',
                      controller: userDetails.weight,
                      labelText: 'Weight (kg)',
                      keyboardType: TextInputType.number,
                      onChanged: (String text) {
                        setState(() {
                          checkAllInformationFilled(checkBox: userDetails.termsAndConditions);
                        });
                      },
                    ),
                    InputField(
                      hintText: '169',
                      controller: userDetails.height,
                      labelText: 'Height (cm)',
                      keyboardType: TextInputType.number,
                      onChanged: (String text) {
                        setState(() {
                          checkAllInformationFilled(checkBox: userDetails.termsAndConditions);
                        });
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Dimensions.d_15),
                      child: Text(
                        'Date Of Birth',
                        style: TextStyle(
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    _datePickerField(),
                    SizedBox(height: Dimensions.d_15),
                    Padding(
                      padding: Paddings.vertical_5,
                      child: Text(
                        'Gender',
                        style: TextStyle(
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                          flex: 22,
                          child: RadioListTile(
                              title: Text(
                                'Male',
                              ),
                              value: 'Male',
                              groupValue: userDetails.gender,
                              onChanged: (String value) {
                                setState(() {
                                  userDetails.gender = value;
                                  checkAllInformationFilled(checkBox: userDetails.termsAndConditions);
                                });
                              }),
                        ),
                        Flexible(
                          flex: 26,
                          child: RadioListTile(
                            // dense: true,
                              title: Text(
                                'Female',
                              ),
                              value: 'Female',
                              groupValue: userDetails.gender,
                              onChanged: (String value) {
                                setState(() {
                                  userDetails.gender = value;
                                  checkAllInformationFilled(checkBox: userDetails.termsAndConditions);
                                });
                              }),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Dimensions.d_45,
                    ),
                    UserButton(
                      text: 'Continue',
                      color: Colours.secondaryColour,
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.d_45),
                      onClick: isButtonDisabled ? null : () {
                        userDetails.calcBMI(weight: int.parse(userDetails.weight.text), height: int.parse(userDetails.height.text));
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                            UserSignUpPage2(passUserDetails: userDetails)
                        ));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }

//  void pushVerificationPage() {
//    Navigator.pop(context);
//    Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) =>
//                VerificationPage(verificationId: this.verificationId, userDetails: this.userDetails)));
//  }
//
//  Future<void> verifyPhone(phoneNo) async {
//    final auth.PhoneVerificationCompleted verified = (auth.AuthCredential authResult) async {
//    };
//
//    final auth.PhoneVerificationFailed verificationFailed =
//        (auth.FirebaseAuthException authException) {
//      debugPrint('${authException.message}');
//      popUpDialog(
//          context: context,
//          isSLI: widget.isSLI,
//          touchToDismiss: false,
//          header: 'Pengesahan',
//          content: Text(
//            'Nombor Telefon Anda Tidak Sah. Sila Isi Nombor Yang Betul.',
//            textAlign: TextAlign.left,
//            style: TextStyle(
//                color: Colours.darkGrey,
//                fontSize: FontSizes.normal),
//          ),
//          onClick: () {
//            setState(() {
//              showLoadingAnimation = false;
//            });
//            Navigator.pop(context);
//          }
//      );
//    };
//
//    final auth.PhoneCodeSent smsSent = (String verId, [int forceResend]) {
//      this.verificationId = verId;
//      setState(() {
//        this.codeSent = true;
//      });
//      popUpDialog(
//          context: context,
//          isSLI: widget.isSLI,
//          touchToDismiss: false,
//          header: 'Pengesahan',
//          content: Text(
//            'Daftar berjaya! Sila klik Teruskan untuk menyerus ke halaman pengesahan.',
//            textAlign: TextAlign.left,
//            style: TextStyle(
//                color: Colours.darkGrey,
//                fontSize: FontSizes.normal),
//          ),
//          buttonText: 'Teruskan',
//          onClick: () {
//            pushVerificationPage();
//          }
//      );
//    };
//
//    final auth.PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
//      this.verificationId = verId;
//      this.codeSent = true;
//    };
//
//    await auth.FirebaseAuth.instance.verifyPhoneNumber(
//        phoneNumber: phoneNo,
//        timeout: const Duration(seconds: 5),
//        verificationCompleted: verified,
//        verificationFailed: verificationFailed,
//        codeSent: smsSent,
//        codeAutoRetrievalTimeout: autoTimeout);
//  }
}
