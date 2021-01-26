class Weight {
  int weightId;
  String date;
  String weight;
  String uid;

  Weight({this.weightId, this.date, this.weight, this.uid});

  Weight.fromJson(Map<String, dynamic> json) {
    weightId = json['weight_id'];
    date = json['date'];
    weight = json['weight'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weight_id'] = this.weightId;
    data['date'] = this.date;
    data['weight'] = this.weight;
    data['uid'] = this.uid;
    return data;
  }
}
