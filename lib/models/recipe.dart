// Copyright 2025 Shantanu Sen Gupta
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

class Recipe {
  final String id;
  final String title;
  final String description;
  final String category;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> instructions;
  final int prepTime; // in minutes
  final int cookTime; // in minutes
  final int servings;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: List<String>.from(json['instructions']),
      prepTime: json['prepTime'],
      cookTime: json['cookTime'],
      servings: json['servings'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'instructions': instructions,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'servings': servings,
    };
  }

  static List<Recipe> getDemoRecipes() {
    return [
      Recipe(
        id: '1',
        title: 'Classic Margherita Pizza',
        description: 'A simple yet delicious pizza with fresh tomatoes, mozzarella, and basil.',
        category: 'Italian',
        imageUrl: 'assets/images/margherita.jpg',
        ingredients: [
          '1 pizza dough',
          '3 tablespoons tomato sauce',
          '170g fresh mozzarella, sliced',
          '2 tomatoes, sliced',
          '5 fresh basil leaves',
          '2 tablespoons olive oil',
          'Salt and pepper to taste'
        ],
        instructions: [
          'Preheat oven to 475°F (245°C).',
          'Roll out pizza dough on a floured surface.',
          'Spread tomato sauce evenly over the dough.',
          'Arrange mozzarella and tomato slices on top.',
          'Bake for 10-12 minutes until crust is golden.',
          'Remove from oven and top with fresh basil leaves.',
          'Drizzle with olive oil, season with salt and pepper.',
        ],
        prepTime: 15,
        cookTime: 12,
        servings: 4,
      ),
      Recipe(
        id: '2',
        title: 'Vegetable Stir Fry',
        description: 'A quick and healthy vegetable stir fry with a savory sauce.',
        category: 'Asian',
        imageUrl: 'assets/images/stirfry.jpg',
        ingredients: [
          '2 tablespoons vegetable oil',
          '1 onion, sliced',
          '2 bell peppers, sliced',
          '1 cup broccoli florets',
          '1 carrot, julienned',
          '2 cloves garlic, minced',
          '1 tablespoon ginger, minced',
          '3 tablespoons soy sauce',
          '1 tablespoon sesame oil',
          '1 teaspoon honey'
        ],
        instructions: [
          'Heat vegetable oil in a wok or large pan over high heat.',
          'Add onions and stir fry for 1 minute.',
          'Add bell peppers, broccoli, and carrots. Stir fry for 3-4 minutes.',
          'Add garlic and ginger, stir fry for 30 seconds until fragrant.',
          'Mix soy sauce, sesame oil, and honey in a small bowl.',
          'Pour sauce over vegetables and toss to coat.',
          'Cook for 1-2 more minutes and serve hot.',
        ],
        prepTime: 10,
        cookTime: 8,
        servings: 2,
      ),
      Recipe(
        id: '3',
        title: 'Classic Chocolate Chip Cookies',
        description: 'Soft and chewy chocolate chip cookies that are perfect for any occasion.',
        category: 'Dessert',
        imageUrl: 'assets/images/cookies.jpg',
        ingredients: [
          '1 cup butter, softened',
          '1 cup white sugar',
          '1 cup packed brown sugar',
          '2 eggs',
          '2 teaspoons vanilla extract',
          '3 cups all-purpose flour',
          '1 teaspoon baking soda',
          '2 teaspoons hot water',
          '1/2 teaspoon salt',
          '2 cups semisweet chocolate chips'
        ],
        instructions: [
          'Preheat oven to 350°F (175°C).',
          'Cream together butter and sugars until smooth.',
          'Beat in eggs one at a time, then stir in vanilla.',
          'Dissolve baking soda in hot water, add to batter along with salt.',
          'Stir in flour and chocolate chips.',
          'Drop by large spoonfuls onto ungreased pans.',
          'Bake for about 10 minutes or until edges are nicely browned.',
        ],
        prepTime: 15,
        cookTime: 10,
        servings: 24,
      ),
    ];
  }
} 