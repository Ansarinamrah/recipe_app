import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:url_launcher/url_launcher.dart';

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

  // Function to open the URL
  Future<void> _launchURL(String url) async {
    final Uri webUrl = Uri.parse(url); // Convert string URL to Uri

    // YouTube app custom URL scheme
    final Uri youtubeUrl = Uri.parse(
      'vnd.youtube://www.youtube.com/watch?v=${Uri.parse(url).queryParameters['v']}',
    );

    // First, try to launch the YouTube app
    if (await canLaunchUrl(youtubeUrl)) {
      await launchUrl(
        youtubeUrl,
        mode: LaunchMode.externalApplication,
      ); // Try to open YouTube app
    } else {
      // If YouTube app is not available, open in the browser
      if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl); // Launch in browser
      } else {
        print('Could not launch $url');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Could not open $url")));
      }
    }
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        _launchURL(
                          "https://www.youtube.com/watch?v=LGY3V7EGpT0",
                        );
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
