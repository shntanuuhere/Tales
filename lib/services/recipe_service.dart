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


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/recipe.dart';

class RecipeService extends ChangeNotifier {
  List<Recipe> _recipes = [];
  List<Recipe> _favorites = [];
  String _selectedCategory = 'All';
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;
  List<Recipe> get recipes => _recipes;
  List<Recipe> get favorites => _favorites;
  String get selectedCategory => _selectedCategory;

  RecipeService() {
    _init();
  }

  Future<void> _init() async {
    await _loadRecipes();
    await _loadFavorites();
  }

  Future<void> _loadRecipes() async {
    try {
      _isLoading = true;
      _hasError = false;
      notifyListeners();

      // In a real app, you would fetch from an API
      // For demo purposes, we'll use a delayed response with sample data
      await Future.delayed(const Duration(milliseconds: 800));
      
      _recipes = Recipe.getDemoRecipes();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = 'Failed to load recipes: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = prefs.getStringList('favorite_recipes') ?? [];
      
      _favorites = _recipes.where((recipe) => favoriteIds.contains(recipe.id)).toList();
    } catch (e) {
      debugPrint('Error loading favorites: ${e.toString()}');
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = _favorites.map((recipe) => recipe.id).toList();
      
      await prefs.setStringList('favorite_recipes', favoriteIds);
    } catch (e) {
      debugPrint('Error saving favorites: ${e.toString()}');
    }
  }

  List<String> getCategories() {
    final categories = ['All'];
    final uniqueCategories = _recipes.map((recipe) => recipe.category).toSet().toList();
    categories.addAll(uniqueCategories);
    return categories;
  }

  Future<void> selectCategory(String category) async {
    _selectedCategory = category;
    notifyListeners();
  }

  List<Recipe> getFilteredRecipes() {
    if (_selectedCategory == 'All') {
      return _recipes;
    }
    
    return _recipes.where((recipe) => recipe.category == _selectedCategory).toList();
  }

  Future<Recipe?> getRecipeById(String id) async {
    try {
      return _recipes.firstWhere((recipe) => recipe.id == id);
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Recipe not found';
      notifyListeners();
      return null;
    }
  }

  Future<bool> toggleFavorite(Recipe recipe) async {
    try {
      final isCurrentlyFavorite = _favorites.any((r) => r.id == recipe.id);
      
      if (isCurrentlyFavorite) {
        _favorites.removeWhere((r) => r.id == recipe.id);
      } else {
        _favorites.add(recipe);
      }
      
      await _saveFavorites();
      notifyListeners();
      return !isCurrentlyFavorite;
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Failed to update favorite status: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  bool isFavorite(String recipeId) {
    return _favorites.any((recipe) => recipe.id == recipeId);
  }

  Future<Recipe?> saveRecipe(Recipe recipe) async {
    try {
      _isLoading = true;
      _hasError = false;
      notifyListeners();

      // Determine if this is a new recipe or an update
      final existingIndex = _recipes.indexWhere((r) => r.id == recipe.id);
      
      if (existingIndex >= 0) {
        // Update existing recipe
        _recipes[existingIndex] = recipe;
      } else {
        // Add new recipe
        _recipes.add(recipe);
      }
      
      // Save to local storage in a real app
      // For demo purposes, we're just updating the in-memory list
      
      _isLoading = false;
      notifyListeners();
      return recipe;
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = 'Failed to save recipe: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }

  Future<bool> deleteRecipe(String recipeId) async {
    try {
      _isLoading = true;
      _hasError = false;
      notifyListeners();

      // Remove from recipes list
      _recipes.removeWhere((recipe) => recipe.id == recipeId);
      
      // Also remove from favorites if present
      if (_favorites.any((recipe) => recipe.id == recipeId)) {
        _favorites.removeWhere((recipe) => recipe.id == recipeId);
        await _saveFavorites();
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = 'Failed to delete recipe: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<String?> saveRecipeImage(String imagePath) async {
    try {
      // In a real app, you would upload to cloud storage or save locally
      // For demo purposes, we're just returning the path
      return imagePath;
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Failed to save image: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }
} 