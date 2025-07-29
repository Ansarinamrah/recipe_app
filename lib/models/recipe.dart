class RecipeModel {
  final String id;
  final String meal;
  final String category;
  final String area;
  final String instructions;
  final String mealThumb;
  final String youtube;
  final List<String> ingredients;
  final List<String> measures;

  RecipeModel({
    required this.id,
    required this.meal,
    required this.category,
    required this.area,
    required this.instructions,
    required this.mealThumb,
    required this.youtube,
    required this.ingredients,
    required this.measures,
  });

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    List<String> ingredients = [];
    List<String> measures = [];
    for (int i = 1; i <= 20; i++) {
      if (map['strIngredient$i'] != '') {
        ingredients.add(map['strIngredient$i'] ?? '');
        measures.add(map['strMeasure$i'] ?? '');
      }
    }

    return RecipeModel(
      id: map['idMeal'] ?? '',
      meal: map['strMeal'] ?? '',
      category: map['strCategory'] ?? '',
      area: map['strArea'] ?? '',
      instructions: map['strInstructions'] ?? '',
      mealThumb: map['strMealThumb'] ?? '',
      youtube: map['strYoutube'] ?? '',
      ingredients: ingredients,
      measures: measures,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idMeal': id,
      'strMeal': meal,
      'strCategory': category,
      'strArea': area,
      'strInstructions': instructions,
      'strMealThumb': mealThumb,
      'strYoutube': youtube,
    };
  }
}
