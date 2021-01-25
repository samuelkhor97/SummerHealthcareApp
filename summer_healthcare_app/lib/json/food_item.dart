class FoodItem {
  int foodId;
  String foodName;
  String calories;
  String protein;
  String totalFat;
  String saturatedFat;
  String dietaryFibre;
  String carbohydrate;
  String cholesterol;
  String sodium;

  FoodItem(
      {this.foodId,
        this.foodName,
        this.calories,
        this.protein,
        this.totalFat,
        this.saturatedFat,
        this.dietaryFibre,
        this.carbohydrate,
        this.cholesterol,
        this.sodium});

  FoodItem.fromJson(Map<String, dynamic> json) {
    foodId = json['food_id'];
    foodName = json['food_name'];
    calories = json['calories'];
    protein = json['protein'];
    totalFat = json['total_fat'];
    saturatedFat = json['saturated_fat'];
    dietaryFibre = json['dietary_fibre'];
    carbohydrate = json['carbohydrate'];
    cholesterol = json['cholesterol'];
    sodium = json['sodium'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['food_id'] = this.foodId;
    data['food_name'] = this.foodName;
    data['calories'] = this.calories;
    data['protein'] = this.protein;
    data['total_fat'] = this.totalFat;
    data['saturated_fat'] = this.saturatedFat;
    data['dietary_fibre'] = this.dietaryFibre;
    data['carbohydrate'] = this.carbohydrate;
    data['cholesterol'] = this.cholesterol;
    data['sodium'] = this.sodium;
    return data;
  }
}
