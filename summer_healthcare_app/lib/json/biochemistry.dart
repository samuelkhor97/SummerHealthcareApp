class Biochemistry {
  String fastingBloodSugar;
  String randomBloodSugar;
  String twoHrPostPrandialGlucose;
  String creatinine;
  String hdl;
  String ldl;
  String triglyceride;
  String hdlLdlRatio;
  String hba1c;
  String totalCholesterol;

  static Map<String, String> units = {
    'fastingBloodSugar': 'mmol/L',
    'randomBloodSugar': 'mmol/L',
    'twoHrPostPrandialGlucose': 'mmol/L',
    'creatinine': 'mg/dL',
    'hdl': 'mg/dL',
    'ldl': 'mg/dL',
    'triglyceride': 'mg/dL',
    'hdlLdlRatio': '',
    'hba1c': '%',
    'totalCholesterol': 'mg/dL',
  };

  Biochemistry({
    this.fastingBloodSugar,
    this.randomBloodSugar,
    this.twoHrPostPrandialGlucose,
    this.creatinine,
    this.hdl,
    this.ldl,
    this.triglyceride,
    this.hdlLdlRatio,
    this.hba1c,
    this.totalCholesterol,
  });

  Biochemistry.fromJson(Map<String, dynamic> json) {
    fastingBloodSugar = json['fastingBloodSugar'];
    randomBloodSugar = json['randomBloodSugar'];
    twoHrPostPrandialGlucose = json['twoHrPostPrandialGlucose'];
    creatinine = json['creatinine'];
    hdl = json['hdl'];
    ldl = json['ldl'];
    triglyceride = json['triglyceride'];
    hdlLdlRatio = json['hdlLdlRatio'];
    hba1c = json['hba1c'];
    totalCholesterol = json['totalCholesterol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fastingBloodSugar'] = this.fastingBloodSugar;
    data['randomBloodSugar'] = this.randomBloodSugar;
    data['twoHrPostPrandialGlucose'] = this.twoHrPostPrandialGlucose;
    data['creatinine'] = this.creatinine;
    data['hdl'] = this.hdl;
    data['ldl'] = this.ldl;
    data['triglyceride'] = this.triglyceride;
    data['hdlLdlRatio'] = this.hdlLdlRatio;
    data['hba1c'] = this.hba1c;
    data['totalCholesterol'] = this.totalCholesterol;
    return data;
  }
}
