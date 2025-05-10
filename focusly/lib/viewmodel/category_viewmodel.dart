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
  bool _isDisposed = false;
  // flag to temporarily ignore firebase updates when we're making local changes
  bool _ignoreNextUpdate = false;

  
  List<Category> get categories {
    final sortedCategories = List<Category>.from(_categories);
    sortedCategories.sort(
      (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
    );
    return sortedCategories;
  }

  CategoryViewModel() {
    _initialize();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _categoriesSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initialize() async {
    if (_isInitialized || _isDisposed) return;

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

      if (!_isDisposed) {
        _isInitialized = true;
      }
    }
  }

  void _setupCategoriesListener() {
    _categoriesSubscription?.cancel();

    _categoriesSubscription = _databaseReference?.onValue.listen((event) {
      if (_isDisposed) return; // Skip if disposed

      if (_ignoreNextUpdate) {
        // Skip this update but process future ones
        _ignoreNextUpdate = false;
        return;
      }

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

        if (!_isDisposed) {
          notifyListeners();
        }
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
    if (_isDisposed) return;

    try {
      if (_databaseReference == null) {
        throw Exception(
          'Cannot load categories: Database reference not initialized',
        );
      }

      final event = await _databaseReference!.once();
      if (_isDisposed) return; // Check if disposed after async operation

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
        if (!_isDisposed) {
          notifyListeners();
        }
      }
    } catch (e) {
      if (!_isDisposed) {
        debugPrint('Error loading categories: $e');
        throw Exception('Error loading categories: $e');
      }
    }
  }

  Future<void> addCategory(Category category) async {
    if (_isDisposed) return;

    if (!_isInitialized) {
      await _initialize();
    }

    if (_isDisposed || !_isInitialized || _databaseReference == null) {
      throw Exception(
        'Cannot add category: User not authenticated or viewmodel disposed',
      );
    }

    final newCategoryRef = _databaseReference!.push();
    final categoryId = newCategoryRef.key!;
    final categoryWithId = category.copyWith(id: categoryId);

    _ignoreNextUpdate = true;
    await newCategoryRef.set(categoryWithId.toJson());
    if (!_isDisposed) {
      _categories.add(categoryWithId);
      notifyListeners();
    }
  }

  Future<void> updateCategory(Category category) async {
    if (_isDisposed) return;

    if (!_isInitialized) {
      await _initialize();
    }

    if (_isDisposed || _databaseReference == null) {
      throw Exception(
        'Cannot update category: Database reference not initialized or viewmodel disposed',
      );
    }

    if (category.id == null) {
      throw Exception('Cannot update category without an ID');
    }

    _ignoreNextUpdate = true;
    await _databaseReference!.child(category.id!).update(category.toJson());

    if (!_isDisposed) {
      final index = _categories.indexWhere((c) => c.id == category.id);
      if (index >= 0) {
        _categories[index] = category;
        notifyListeners();
      }
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    if (_isDisposed) return;

    if (!_isInitialized) {
      await _initialize();
    }

    if (_isDisposed || _databaseReference == null) {
      throw Exception(
        'Cannot delete category: Database reference not initialized or viewmodel disposed',
      );
    }

    _ignoreNextUpdate = true;
    await _databaseReference!.child(categoryId).remove();
    if (!_isDisposed) {
      _categories.removeWhere((c) => c.id == categoryId);
      notifyListeners();
    }
  }

  // Check if a category with the same title already exists
  bool categoryTitleExists(String title, [String? excludeId]) {
    return _categories.any(
      (category) =>
          category.title.toLowerCase() == title.toLowerCase() &&
          category.id != excludeId,
    );
  }

  // Method to clean up database listeners when user signs out
  Future<void> cleanupForSignOut() async {
    debugPrint('CategoryViewModel: Cleaning up for sign out');
    _categoriesSubscription?.cancel();
    _categoriesSubscription = null;
    _databaseReference = null;
    _isInitialized = false;
    //_categories.clear();
    notifyListeners();
    debugPrint('CategoryViewModel: Cleanup completed');
  }
}
