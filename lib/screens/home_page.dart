import 'dart:math';

import 'package:flutter/material.dart';
import 'package:recipe_app/models/categories.dart';
import '../services/serviceIntegrate.dart';
import 'RecipeScreen.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  // Fetch categories from the API
  Future<void> fetchCategories() async {
    final fetchedCategories = await ApiIntegration.getCategory();
    setState(() {
      categories = fetchedCategories;
      isLoading = false;
    });
  }

  void navigateToAnyRecipe() {
    if (categories.isNotEmpty) {
      // Generate a random index
      final randomIndex = Random().nextInt(categories.length);

      // Get the random category
      final randomCategory = categories[randomIndex];

      // Navigate to the RecipeScreen with the random category
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeScreen(categoryName: randomCategory.name),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipe App"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final item = categories[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to RecipeScreen on category tap
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        RecipeScreen(categoryName: item.name),
                              ),
                            );
                          },
                          child: Card(
                            child: ListTile(
                              leading: Image.network(
                                item.thumb,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                              title: Text(item.name),
                              subtitle: Text(
                                item.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAnyRecipe,
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.shuffle, size: 20),
              SizedBox(width: 2),
              Text(
                'Random',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
