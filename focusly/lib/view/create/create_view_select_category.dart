import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:focusly/viewmodel/category_viewmodel.dart';

class CategorySelectionDialog extends StatelessWidget {
  final String? selectedCategoryId;
  final Function(String) onCategorySelected;

  const CategorySelectionDialog({
    super.key,
    this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryViewModel>().categories;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select a Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6, // 60% of screen height
                maxWidth: double.infinity,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = category.id == selectedCategoryId;

                  return ListTile(
                    leading: Icon(category.icon, color: category.textColor),
                    title: Text(category.title),
                    tileColor: isSelected ? Colors.grey[200] : null,
                    onTap: () {
                      onCategorySelected(category.id!);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}