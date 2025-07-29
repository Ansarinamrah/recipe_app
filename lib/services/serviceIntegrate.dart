import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/categories.dart';
import '../models/recipe.dart';

class ApiIntegration {
  static const String baseUrl = "https://www.themealdb.com/api/json/v1/1/";

  static Future<List<CategoryModel>> getCategory() async {
    final url = Uri.parse('${baseUrl}categories.php');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List categories = data['categories'];
        return categories.map((e) => CategoryModel.fromMap(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }

  static Future<List<RecipeModel>> getRecipe(String category) async {
    final url = Uri.parse('${baseUrl}filter.php?c=$category');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List meals = data['meals'];
        return meals.map((e) => RecipeModel.fromMap(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching recipes: $e");
      return [];
    }
  }

  static Future<RecipeModel> getRecipeDetails(String mealId) async {
    final url = Uri.parse('${baseUrl}lookup.php?i=$mealId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final mealData = data['meals'][0];
        return RecipeModel.fromMap(mealData);
      } else {
        throw Exception("Failed to load recipe details");
      }
    } catch (e) {
      throw Exception("Error fetching recipe: $e");
    }
  }
}
