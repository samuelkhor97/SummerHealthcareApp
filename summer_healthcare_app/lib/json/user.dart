import 'package:summer_healthcare_app/json/biochemistry.dart';
import 'package:summer_healthcare_app/json/medical_history.dart';
import 'package:summer_healthcare_app/json/medication.dart';

class User {
  String uid;
  String pharmacyId;
  String fullName;
  String phoneNum;
  String height;
  String dob;
  int age;
  String gender;
  String ethnicity;
  String educationStatus;
  String employmentStatus;
  String occupation;
  String maritalStatus;
  bool smoker;
  int cigsPerDay;
  bool eCig;
  String weight;
  String bodyFatPercentage;
  MedicalHistory medicalHistory;
  List<Medication> medication;
  List<Biochemistry> biochemistry;

  User(
      {this.uid,
      this.pharmacyId,
      this.fullName,
      this.phoneNum,
      this.height,
      this.dob,
      this.age,
      this.gender,
      this.ethnicity,
      this.educationStatus,
      this.employmentStatus,
      this.occupation,
      this.maritalStatus,
      this.smoker,
      this.cigsPerDay,
      this.eCig,
      this.weight,
      this.bodyFatPercentage,
      this.medicalHistory,
      this.medication,
      this.biochemistry});

  User.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    pharmacyId = json['pharmacy_id'];
    fullName = json['full_name'];
    phoneNum = json['phone_num'];
    height = json['height'];
    dob = json['dob'];
    age = json['age'];
    gender = json['gender'];
    ethnicity = json['ethnicity'];
    educationStatus = json['education_status'];
    employmentStatus = json['employment_status'];
    occupation = json['occupation'];
    maritalStatus = json['marital_status'];
    smoker = json['smoker'];
    cigsPerDay = json['cigs_per_day'];
    eCig = json['e_cig'];
    weight = json['weight'];
    bodyFatPercentage = json['body_fat_percentage'];
    medicalHistory = MedicalHistory.fromJson(json['medical_history']);
    medication = List<Medication>.from(
      json['medication'].map(
        (med) => Medication.fromJson(med),
      ),
    );
    biochemistry = List<Biochemistry>.from(
      json['biochemistry'].map(
        (bio) => Biochemistry.fromJson(bio),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['pharmacy_id'] = this.pharmacyId;
    data['full_name'] = this.fullName;
    data['phone_num'] = this.phoneNum;
    data['height'] = this.height;
    data['dob'] = this.dob;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['ethnicity'] = this.ethnicity;
    data['education_status'] = this.educationStatus;
    data['employment_status'] = this.employmentStatus;
    data['occupation'] = this.occupation;
    data['marital_status'] = this.maritalStatus;
    data['smoker'] = this.smoker;
    data['cigs_per_day'] = this.cigsPerDay;
    data['e_cig'] = this.eCig;
    data['weight'] = this.weight;
    data['body_fat_percentage'] = this.bodyFatPercentage;
    data['medical_history'] = this.medicalHistory.toJson();
    data['medication'] = List<Map<String, dynamic>>.from(
      this.medication.map((med) => med.toJson()),
    );
    data['biochemistry'] = List<Map<String, dynamic>>.from(
      this.biochemistry.map((bio) => bio.toJson()),
    );
    return data;
  }
}
