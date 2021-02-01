class Medication {
  String medication;
  String reasonForUse;
  String doseAndUnits;
  String frequency;
  String startDate;
  String stopDate;
  bool stillOngoing;

  Medication({
    this.medication,
    this.reasonForUse,
    this.doseAndUnits,
    this.frequency,
    this.startDate,
    this.stopDate,
    this.stillOngoing,
  });

  Medication.fromJson(Map<String, dynamic> json) {
    medication = json['medication'];
    reasonForUse = json['reasonForUse'];
    doseAndUnits = json['doseAndUnits'];
    frequency = json['frequency'];
    startDate = json['startDate'];
    stopDate = json['stopDate'];
    stillOngoing = json['stillOngoing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medication'] = this.medication;
    data['reasonForUse'] = this.reasonForUse;
    data['doseAndUnits'] = this.doseAndUnits;
    data['frequency'] = this.frequency;
    data['startDate'] = this.startDate;
    data['stopDate'] = this.stopDate;
    data['stillOngoing'] = this.stillOngoing;
    return data;
  }
}
