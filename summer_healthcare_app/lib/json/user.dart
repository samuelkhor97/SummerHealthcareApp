class User {
  String uid;
  String pharmacyId;
  String fullName;
  String phoneNum;
  String height;
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
  Map<String, dynamic> medicalHistory;
  Map<String, dynamic> medication;
  Map<String, dynamic> biochemistry;

  User(
      {this.uid,
        this.pharmacyId,
        this.fullName,
        this.phoneNum,
        this.height,
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
    bodyFatPercentage = json['bodyFatPercentage'];
    medicalHistory = json['medicalHistory'];
    medication = json['medication'];
    biochemistry = json['biochemistry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['pharmacy_id'] = this.pharmacyId;
    data['full_name'] = this.fullName;
    data['phone_num'] = this.phoneNum;
    data['height'] = this.height;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['ethnicity'] = this.ethnicity;
    data['education_status'] = this.educationStatus;
    data['employment_status'] = this.employmentStatus;
    data['occupation'] = this.occupation;
    data['marital_status'] = this.maritalStatus;
    data['smoker'] = this.smoker;
    data['cigs_per_day'] = this.cigsPerDay;
    data['weight'] = this.weight;
    data['bodyFatPercentage'] = this.bodyFatPercentage;
    data['medicalHistory'] = this.medicalHistory;
    data['medication'] = this.medication;
    data['biochemistry'] = this.biochemistry;
    return data;
  }
}
