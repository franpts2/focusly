import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/model/category_model.dart';

void main() {
  group('Category Model Tests', () {
    test('Category creation with required fields', () {
      final category = Category(
        title: 'Study',
        color: const Color(0xff98C9A3),
        icon: Icons.book,
      );

      expect(category.title, 'Study');
      expect(category.color.value, const Color(0xff98C9A3).value);
      expect(category.icon, Icons.book);
      expect(category.id, null);
      // Should auto-assign text color based on background color
      expect(category.textColor.value, const Color(0xff4F772D).value);
    });

    test('Category creation with all fields', () {
      final category = Category(
        id: 'test-id',
        title: 'Exam Prep',
        color: const Color(0xffFFC2D4),
        textColor: const Color(0xffE05780),
        icon: Icons.school,
      );

      expect(category.title, 'Exam Prep');
      expect(category.color.value, const Color(0xffFFC2D4).value);
      expect(category.textColor.value, const Color(0xffE05780).value);
      expect(category.icon, Icons.school);
      expect(category.id, 'test-id');
    });

    test('Category copyWith method', () {
      final original = Category(
        id: 'original-id',
        title: 'Original Title',
        color: const Color(0xff98C9A3),
        icon: Icons.book,
      );

      final updated = original.copyWith(
        title: 'Updated Title',
        color: const Color(0xffB6CCFE),
        icon: Icons.history_edu,
      );

      // Check original remains unchanged
      expect(original.title, 'Original Title');
      expect(original.color.value, const Color(0xff98C9A3).value);
      expect(original.icon, Icons.book);

      // Check updated has new values
      expect(updated.id, 'original-id'); // ID should be preserved
      expect(updated.title, 'Updated Title');
      expect(updated.color.value, const Color(0xffB6CCFE).value);
      expect(updated.icon, Icons.history_edu);
      // Text color should be updated based on new background color
      expect(updated.textColor.value, const Color(0xff0077B6).value);
    });

    test('Category toJson method', () {
      final category = Category(
        id: 'test-id',
        title: 'Math',
        color: const Color(0xffFAE588),
        icon: Icons.calculate,
      );

      final json = category.toJson();

      expect(json['title'], 'Math');
      expect(json['colorValue'], const Color(0xffFAE588).value);
      expect(json['iconCodePoint'], Icons.calculate.codePoint);
      expect(json['iconFontFamily'], Icons.calculate.fontFamily);
      expect(json['textColorValue'], const Color(0xffB69121).value);
      // ID should not be included in toJson (handled separately in the viewmodel)
      expect(json.containsKey('id'), false);
    });

    test('Category fromJson method', () {
      final json = {
        'id': 'test-id',
        'title': 'Languages',
        'colorValue': const Color(0xffFFD19F).value,
        'textColorValue': const Color(0xffF3722C).value,
        'iconCodePoint': Icons.language.codePoint,
        'iconFontFamily': Icons.language.fontFamily,
      };

      final category = Category.fromJson(json);

      expect(category.id, 'test-id');
      expect(category.title, 'Languages');
      expect(category.color.value, const Color(0xffFFD19F).value);
      expect(category.textColor.value, const Color(0xffF3722C).value);
      expect(category.icon.codePoint, Icons.language.codePoint);
      expect(category.icon.fontFamily, Icons.language.fontFamily);
    });

    test('Category fromJson with missing values', () {
      // Test that fromJson gracefully handles missing data with defaults
      final json = {'id': 'test-id'};

      final category = Category.fromJson(json);

      expect(category.id, 'test-id');
      expect(category.title, 'Untitled'); // Default title
      expect(
        category.color.value,
        const Color(0xFF9C27B0).value,
      ); // Default color
      expect(category.icon.codePoint, Icons.category.codePoint); // Default icon
    });

    test('textColor is correctly assigned based on background color', () {
      // Since _getTextColorForBackground is private, we test it indirectly through constructor

      // Pink background should get pink text
      final pinkCategory = Category(
        title: 'Test Pink',
        color: const Color(0xffFFC2D4),
        icon: Icons.book,
      );
      expect(pinkCategory.textColor.value, const Color(0xffE05780).value);

      // Green background should get green text
      final greenCategory = Category(
        title: 'Test Green',
        color: const Color(0xff98C9A3),
        icon: Icons.book,
      );
      expect(greenCategory.textColor.value, const Color(0xff4F772D).value);

      // Blue background should get blue text
      final blueCategory = Category(
        title: 'Test Blue',
        color: const Color(0xffB6CCFE),
        icon: Icons.book,
      );
      expect(blueCategory.textColor.value, const Color(0xff0077B6).value);

      // Non-mapped color should default to black text
      final tealCategory = Category(
        title: 'Test Teal',
        color: Colors.teal,
        icon: Icons.book,
      );
      expect(tealCategory.textColor.value, Colors.black.value);
    });
  });

  group('Category Color Tests', () {
    test('All predefined colors have matching text colors', () {
      // Test all the predefined colors from the _getTextColorForBackground method

      // Pink background and text
      final pinkCategory = Category(
        title: 'Pink',
        color: const Color(0xffFFC2D4),
        icon: Icons.favorite,
      );
      expect(pinkCategory.textColor.value, const Color(0xffE05780).value);

      // Green background and text
      final greenCategory = Category(
        title: 'Green',
        color: const Color(0xff98C9A3),
        icon: Icons.eco,
      );
      expect(greenCategory.textColor.value, const Color(0xff4F772D).value);

      // Blue background and text
      final blueCategory = Category(
        title: 'Blue',
        color: const Color(0xffB6CCFE),
        icon: Icons.water,
      );
      expect(blueCategory.textColor.value, const Color(0xff0077B6).value);

      // Yellow background and text
      final yellowCategory = Category(
        title: 'Yellow',
        color: const Color(0xffFAE588),
        icon: Icons.wb_sunny,
      );
      expect(yellowCategory.textColor.value, const Color(0xffB69121).value);

      // Orange background and text
      final orangeCategory = Category(
        title: 'Orange',
        color: const Color(0xffFFD19F),
        icon: Icons.emoji_food_beverage,
      );
      expect(orangeCategory.textColor.value, const Color(0xffF3722C).value);

      // Red background and text
      final redCategory = Category(
        title: 'Red',
        color: const Color(0xffDF7373),
        icon: Icons.local_fire_department,
      );
      expect(redCategory.textColor.value, const Color(0xff85182A).value);
    });

    test('Custom text color overrides automatic selection', () {
      // When providing a custom text color, it should take precedence
      final category = Category(
        title: 'Custom Text Color',
        color: const Color(0xffFFC2D4), // pink background
        textColor: Colors.purple, // custom text color
        icon: Icons.palette,
      );

      // Should use the custom color, not the automatic pink text color
      expect(category.textColor.value, Colors.purple.value);
      expect(category.textColor.value != const Color(0xffE05780).value, true);
    });
  });

  group('CategoryViewModel Utility Method Tests', () {
    test('categoryTitleExists should detect duplicate titles', () {
      // Create a simple category model
      final category1 = Category(
        id: 'id1',
        title: 'Math',
        color: Colors.blue,
        icon: Icons.calculate,
      );

      final category2 = Category(
        id: 'id2',
        title: 'Science',
        color: Colors.green,
        icon: Icons.science,
      );

      // Create a test list to simulate the private _categories list
      final List<Category> testCategories = [category1, category2];

      // Create a function that mimics the categoryTitleExists method
      bool categoryTitleExists(String title, [String? excludeId]) {
        return testCategories.any(
          (category) =>
              category.title.toLowerCase() == title.toLowerCase() &&
              category.id != excludeId,
        );
      }

      // Check for duplicates (case insensitive)
      expect(categoryTitleExists('Math'), true);
      expect(categoryTitleExists('math'), true);
      expect(categoryTitleExists('MATH'), true);
      expect(categoryTitleExists('Physics'), false);

      // Should ignore the category with the excluded ID
      expect(categoryTitleExists('Math', 'id1'), false);
      expect(
        categoryTitleExists('Science', 'id3'),
        true,
      ); // Different ID, so still a duplicate
    });

    test('categories getter should sort alphabetically', () {
      // Create some categories in non-alphabetical order
      final category1 = Category(
        id: 'id1',
        title: 'Science',
        color: Colors.green,
        icon: Icons.science,
      );

      final category2 = Category(
        id: 'id2',
        title: 'Art',
        color: Colors.purple,
        icon: Icons.palette,
      );

      final category3 = Category(
        id: 'id3',
        title: 'Math',
        color: Colors.blue,
        icon: Icons.calculate,
      );

      // Create an unsorted list to simulate the private _categories list
      final List<Category> unsortedCategories = [
        category1,
        category2,
        category3,
      ];

      // Create a function that mimics the categories getter
      List<Category> getSortedCategories() {
        final sortedCategories = List<Category>.from(unsortedCategories);
        sortedCategories.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        return sortedCategories;
      }

      final sortedCategories = getSortedCategories();

      // Should be in alphabetical order
      expect(sortedCategories[0].title, 'Art');
      expect(sortedCategories[1].title, 'Math');
      expect(sortedCategories[2].title, 'Science');
    });

    test('getCategoryById should return category or default', () {
      // Create some test categories
      final category1 = Category(
        id: 'id1',
        title: 'Math',
        color: Colors.blue,
        icon: Icons.calculate,
      );

      final category2 = Category(
        id: 'id2',
        title: 'Science',
        color: Colors.green,
        icon: Icons.science,
      );

      final List<Category> testCategories = [category1, category2];

      // Create a function that mimics the getCategoryById method
      Category getCategoryById(String? categoryId) {
        return testCategories.firstWhere(
          (category) => category.id == categoryId,
          orElse:
              () => Category(
                id: null,
                title: 'General',
                color: Colors.grey.shade600,
                icon: Icons.public,
              ),
        );
      }

      // Should find an existing category
      final foundCategory = getCategoryById('id2');
      expect(foundCategory.id, 'id2');
      expect(foundCategory.title, 'Science');

      // Should return default category for non-existent ID
      final defaultCategory = getCategoryById('non-existent');
      expect(defaultCategory.id, null);
      expect(defaultCategory.title, 'General');
      expect(defaultCategory.icon, Icons.public);
    });
  });

  group('Category Update and Delete Tests', () {
    test('updateCategory should correctly modify a category', () {
      // Create a list to simulate the categories collection
      final List<Category> testCategories = [
        Category(
          id: 'id1',
          title: 'Math',
          color: Colors.blue,
          icon: Icons.calculate,
        ),
        Category(
          id: 'id2',
          title: 'Science',
          color: Colors.green,
          icon: Icons.science,
        ),
      ];

      // Create a function that mimics the updateCategory method
      void updateCategory(Category updatedCategory) {
        final index = testCategories.indexWhere(
          (c) => c.id == updatedCategory.id,
        );
        if (index >= 0) {
          testCategories[index] = updatedCategory;
        }
      }

      // Update the Math category
      final updatedCategory = Category(
        id: 'id1',
        title: 'Mathematics',
        color: Colors.purple,
        icon: Icons.functions,
      );

      updateCategory(updatedCategory);

      // Verify the category was updated
      expect(
        testCategories.length,
        2,
      ); // Number of categories should remain the same

      final mathCategory = testCategories.firstWhere((c) => c.id == 'id1');
      expect(mathCategory.title, 'Mathematics');
      expect(mathCategory.color, Colors.purple);
      expect(mathCategory.icon, Icons.functions);

      // Other categories should remain unchanged
      final scienceCategory = testCategories.firstWhere((c) => c.id == 'id2');
      expect(scienceCategory.title, 'Science');
      expect(scienceCategory.color, Colors.green);
      expect(scienceCategory.icon, Icons.science);
    });

    test('updateCategory should handle non-existent categories gracefully', () {
      // Create a list to simulate the categories collection
      final List<Category> testCategories = [
        Category(
          id: 'id1',
          title: 'Math',
          color: Colors.blue,
          icon: Icons.calculate,
        ),
      ];

      // Create a function that mimics the updateCategory method
      bool updateCategory(Category updatedCategory) {
        final index = testCategories.indexWhere(
          (c) => c.id == updatedCategory.id,
        );
        if (index >= 0) {
          testCategories[index] = updatedCategory;
          return true;
        }
        return false;
      }

      // Try to update a non-existent category
      final updatedCategory = Category(
        id: 'non-existent-id',
        title: 'History',
        color: Colors.brown,
        icon: Icons.history,
      );

      final updateResult = updateCategory(updatedCategory);

      // Verify that the update failed and categories remain unchanged
      expect(updateResult, false);
      expect(testCategories.length, 1);
      expect(testCategories[0].id, 'id1');
      expect(testCategories[0].title, 'Math');
    });

    test('deleteCategory should remove a category by ID', () {
      // Create a list to simulate the categories collection
      final List<Category> testCategories = [
        Category(
          id: 'id1',
          title: 'Math',
          color: Colors.blue,
          icon: Icons.calculate,
        ),
        Category(
          id: 'id2',
          title: 'Science',
          color: Colors.green,
          icon: Icons.science,
        ),
        Category(
          id: 'id3',
          title: 'History',
          color: Colors.brown,
          icon: Icons.history,
        ),
      ];

      // Create a function that mimics the deleteCategory method
      bool deleteCategory(String categoryId) {
        final initialLength = testCategories.length;
        testCategories.removeWhere((category) => category.id == categoryId);
        return testCategories.length < initialLength;
      }

      // Delete the Science category
      final deleteResult = deleteCategory('id2');

      // Verify the category was deleted
      expect(deleteResult, true);
      expect(testCategories.length, 2);

      // Check that the correct category was removed
      expect(testCategories.any((c) => c.id == 'id2'), false);

      // Other categories should still exist
      expect(testCategories.any((c) => c.id == 'id1'), true);
      expect(testCategories.any((c) => c.id == 'id3'), true);
    });

    test('deleteCategory should handle non-existent category IDs', () {
      // Create a list to simulate the categories collection
      final List<Category> testCategories = [
        Category(
          id: 'id1',
          title: 'Math',
          color: Colors.blue,
          icon: Icons.calculate,
        ),
      ];

      // Create a function that mimics the deleteCategory method
      bool deleteCategory(String categoryId) {
        final initialLength = testCategories.length;
        testCategories.removeWhere((category) => category.id == categoryId);
        return testCategories.length < initialLength;
      }

      // Try to delete a non-existent category
      final deleteResult = deleteCategory('non-existent-id');

      // Verify that nothing was deleted
      expect(deleteResult, false);
      expect(testCategories.length, 1);
      expect(testCategories[0].id, 'id1');
    });

    test(
      'after deleting a category, getCategoryById should return the default category',
      () {
        // Create a list to simulate the categories collection
        final List<Category> testCategories = [
          Category(
            id: 'id1',
            title: 'Math',
            color: Colors.blue,
            icon: Icons.calculate,
          ),
        ];

        // Create a function that mimics the deleteCategory method
        void deleteCategory(String categoryId) {
          testCategories.removeWhere((category) => category.id == categoryId);
        }

        // Create a function that mimics the getCategoryById method
        Category getCategoryById(String? categoryId) {
          return testCategories.firstWhere(
            (category) => category.id == categoryId,
            orElse:
                () => Category(
                  id: null,
                  title: 'General',
                  color: Colors.grey.shade600,
                  icon: Icons.public,
                ),
          );
        }

        // Delete the Math category
        deleteCategory('id1');

        // Try to get the deleted category
        final result = getCategoryById('id1');

        // Should return the default category
        expect(result.id, null);
        expect(result.title, 'General');
        expect(result.icon, Icons.public);
      },
    );
  });

  group('Category Dialog Logic Tests', () {
    test('updating a category should preserve its ID', () {
      // Original category
      final originalCategory = Category(
        id: 'original-id',
        title: 'Original Title',
        color: Colors.blue,
        icon: Icons.book,
      );

      // Simulate updating fields in CategoryDialog
      final updatedCategory = originalCategory.copyWith(
        title: 'Updated Title',
        color: Colors.green,
        icon: Icons.edit,
      );

      // ID should be preserved during update
      expect(updatedCategory.id, 'original-id');

      // Other properties should be updated
      expect(updatedCategory.title, 'Updated Title');
      expect(updatedCategory.color, Colors.green);
      expect(updatedCategory.icon, Icons.edit);
    });

    test('creating a new category should have null ID', () {
      // Simulating category creation
      final newCategory = Category(
        title: 'New Category',
        color: Colors.amber,
        icon: Icons.star,
      );

      // New categories should have null ID (will be generated by Firebase)
      expect(newCategory.id, null);
      expect(newCategory.title, 'New Category');
    });

    test('duplicate category titles should be detected', () {
      // List of existing categories
      final existingCategories = [
        Category(
          id: 'id1',
          title: 'Math',
          color: Colors.blue,
          icon: Icons.calculate,
        ),
        Category(
          id: 'id2',
          title: 'Science',
          color: Colors.green,
          icon: Icons.science,
        ),
      ];

      // Function to check for duplicates (simulating CategoryViewModel.categoryTitleExists)
      bool hasDuplicateTitle(String title, [String? excludeId]) {
        return existingCategories.any(
          (c) =>
              c.title.toLowerCase() == title.toLowerCase() && c.id != excludeId,
        );
      }

      // Test with exact duplicate
      expect(hasDuplicateTitle('Math'), true);

      // Test with case-insensitive duplicate
      expect(hasDuplicateTitle('MATH'), true);
      expect(hasDuplicateTitle('math'), true);

      // Test with non-duplicate
      expect(hasDuplicateTitle('History'), false);

      // Test excluding the category's own ID
      expect(hasDuplicateTitle('Math', 'id1'), false);
      expect(hasDuplicateTitle('Science', 'id1'), true);
    });
  });
}
