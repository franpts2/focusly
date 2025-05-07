import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:focusly/model/category_model.dart';
import 'dart:async';

class CategoryViewModel extends ChangeNotifier {
  final List<Category> _categories = [];
  DatabaseReference? _databaseReference;
  StreamSubscription<DatabaseEvent>? _categoriesSubscription;
  bool _isInitialized = false;

  List<Category> get categories => _categories;

  CategoryViewModel() {
    _initialize();
  }

  @override
  void dispose() {
    _categoriesSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _databaseReference = FirebaseDatabase.instance
          .ref()
          .child(user.uid)
          .child("categories");

      // Initial load
      await _loadCategories();

      // Set up real-time listener
      _setupCategoriesListener();

      _isInitialized = true;
    }
  }

  void _setupCategoriesListener() {
    _categoriesSubscription?.cancel();

    _categoriesSubscription = _databaseReference?.onValue.listen((event) {
      if (event.snapshot.value != null) {
        _categories.clear();
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);

        data.forEach((key, value) {
          try {
            if (value is Map) {
              final categoryData = Map<String, dynamic>.from(value);
              categoryData['id'] = key;
              _categories.add(Category.fromJson(categoryData));
            }
          } catch (e) {
            debugPrint('Error parsing category $key: $e');
          }
        });

        notifyListeners();
      }
    });
  }

  Future<void> refreshCategories() async {
    _isInitialized = false;
    _categoriesSubscription?.cancel();
    _databaseReference = null;
    _categories.clear();
    await _initialize();
  }

  Future<void> _loadCategories() async {
    try {
      if (_databaseReference == null) {
        throw Exception(
          'Cannot load categories: Database reference not initialized',
        );
      }

      final event = await _databaseReference!.once();
      final data = event.snapshot.value;

      if (data != null) {
        _categories.clear();
        final categoriesMap = Map<String, dynamic>.from(data as Map);

        categoriesMap.forEach((key, value) {
          try {
            if (value is Map) {
              final categoryData = Map<String, dynamic>.from(value);
              categoryData['id'] = key;
              _categories.add(Category.fromJson(categoryData));
            }
          } catch (e) {
            debugPrint('Error parsing category $key: $e');
          }
        });
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading categories: $e');
      throw Exception('Error loading categories: $e');
    }
  }

  Future<void> addCategory(Category category) async {
    if (!_isInitialized) {
      await _initialize();
    }

    if (!_isInitialized || _databaseReference == null) {
      throw Exception('Cannot add category: User not authenticated');
    }

    final newCategoryRef = _databaseReference!.push();
    final categoryId = newCategoryRef.key!;
    final categoryWithId = category.copyWith(id: categoryId);

    await newCategoryRef.set(categoryWithId.toJson());
    _categories.add(categoryWithId);
    notifyListeners();
  }

  Future<void> updateCategory(Category category) async {
    if (!_isInitialized) {
      await _initialize();
    }

    if (_databaseReference == null) {
      throw Exception(
        'Cannot update category: Database reference not initialized',
      );
    }

    if (category.id == null) {
      throw Exception('Cannot update category without an ID');
    }

    await _databaseReference!.child(category.id!).update(category.toJson());

    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index >= 0) {
      _categories[index] = category;
      notifyListeners();
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    if (!_isInitialized) {
      await _initialize();
    }

    if (_databaseReference == null) {
      throw Exception(
        'Cannot delete category: Database reference not initialized',
      );
    }

    await _databaseReference!.child(categoryId).remove();
    _categories.removeWhere((c) => c.id == categoryId);
    notifyListeners();
  }
}
