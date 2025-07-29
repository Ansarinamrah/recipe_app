import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe.dart';

import '../services/serviceIntegrate.dart';
import 'detail_page.dart'; // Make sure to import your RecipeModel

class RecipeScreen extends StatefulWidget {
  final String categoryName;

  RecipeScreen({required this.categoryName});

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  List<RecipeModel> recipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipes(
      widget.categoryName,
    ); // Fetch recipes based on the category passed
  }

  Future<void> fetchRecipes(String category) async {
    final fetchedRecipes = await ApiIntegration.getRecipe(category);
    setState(() {
      recipes = fetchedRecipes;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryName} Recipes'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Image.network(
                        recipe.mealThumb,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(recipe.meal),
                      onTap: () {
                        // Navigate to the RecipeDetailScreen on click
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    RecipeDetailScreen(mealId: recipe.id),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
