import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe.dart';

import '../services/serviceIntegrate.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String mealId;

  const RecipeDetailScreen({super.key, required this.mealId});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late RecipeModel recipe;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipeDetails();
  }

  Future<void> fetchRecipeDetails() async {
    try {
      final fetchedRecipe = await ApiIntegration.getRecipeDetails(
        widget.mealId,
      );
      setState(() {
        recipe = fetchedRecipe;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle errors here, maybe show a message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
        backgroundColor: Colors.deepPurple,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children: [
                    Image.network(recipe.mealThumb),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        recipe.meal,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Category: ${recipe.category}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Area: ${recipe.area}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Instructions: \n\n${recipe.instructions}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text('Ingredients:'),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recipe.ingredients.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            '${recipe.ingredients[index]}: ${recipe.measures[index]}',
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Watch the recipe on YouTube:',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Launch YouTube URL
                        // You can use a package like url_launcher to open the URL
                        // launch(recipe.youtube);
                      },
                      child: Text(
                        recipe.youtube,
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
