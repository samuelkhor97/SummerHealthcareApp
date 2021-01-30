class MedicalHistory {
  bool cardiovascular;
  bool respiratory;
  bool hepatoBiliary;
  bool gastroIntestinal;
  bool genitoUrinary;
  bool endocrine;
  bool haematological;
  bool musculoSkeletal;
  bool neoplasia;
  bool neurological;
  bool psychological;
  bool immunological;
  bool dermatological;
  bool allergies;
  bool eyesEarNoseThroat;
  String other;

  static Map<String, String> codes = {
    'cardiovascular': '1',
    'respiratory': '2',
    'hepatoBiliary': '3',
    'gastroIntestinal': '4',
    'genitoUrinary': '5',
    'endocrine': '6',
    'haematological': '7',
    'musculoSkeletal': '8',
    'neoplasia': '9',
    'neurological': '10',
    'psychological': '11',
    'immunological': '12',
    'dermatological': '13',
    'allergies': '14',
    'eyesEarNoseThroat': '15',
    'other': '00',
  };

  MedicalHistory({
    this.cardiovascular,
    this.respiratory,
    this.hepatoBiliary,
    this.gastroIntestinal,
    this.genitoUrinary,
    this.endocrine,
    this.haematological,
    this.musculoSkeletal,
    this.neoplasia,
    this.neurological,
    this.psychological,
    this.immunological,
    this.dermatological,
    this.allergies,
    this.eyesEarNoseThroat,
    this.other,
  });

  MedicalHistory.fromJson(Map<String, dynamic> json) {
    cardiovascular = json['cardiovascular'];
    respiratory = json['respiratory'];
    hepatoBiliary = json['hepatoBiliary'];
    gastroIntestinal = json['gastroIntestinal'];
    genitoUrinary = json['genitoUrinary'];
    endocrine = json['endocrine'];
    haematological = json['haematological'];
    musculoSkeletal = json['musculoSkeletal'];
    neoplasia = json['neoplasia'];
    neurological = json['neurological'];
    psychological = json['psychological'];
    immunological = json['immunological'];
    dermatological = json['dermatological'];
    allergies = json['allergies'];
    eyesEarNoseThroat = json['eyesEarNoseThroat'];
    other = json['other'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardiovascular'] = this.cardiovascular;
    data['respiratory'] = this.respiratory;
    data['hepatoBiliary'] = this.hepatoBiliary;
    data['gastroIntestinal'] = this.gastroIntestinal;
    data['genitoUrinary'] = this.genitoUrinary;
    data['endocrine'] = this.endocrine;
    data['haematological'] = this.haematological;
    data['musculoSkeletal'] = this.musculoSkeletal;
    data['neoplasia'] = this.neoplasia;
    data['neurological'] = this.neurological;
    data['psychological'] = this.psychological;
    data['immunological'] = this.immunological;
    data['dermatological'] = this.dermatological;
    data['allergies'] = this.allergies;
    data['eyesEarNoseThroat'] = this.eyesEarNoseThroat;
    data['other'] = this.other;
    return data;
  }
}
