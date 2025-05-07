import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:focusly/model/category_model.dart';
import 'package:focusly/services/authentication_service.dart';
import 'package:focusly/viewmodel/category_viewmodel.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthenticationService>(context);
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text("Profile"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile picture section
              Center(
                child: FutureBuilder<String?>(
                  future: authService.getUserAvatar(),
                  builder: (context, snapshot) {
                    return Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.primaryColor, width: 3),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child:
                            snapshot.data != null && snapshot.data!.isNotEmpty
                                // Show Google profile picture if available
                                ? Image.network(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildDefaultAvatar(theme);
                                  },
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return _buildDefaultAvatar(theme);
                                  },
                                )
                                // Default avatar for email/password users
                                : _buildDefaultAvatar(theme),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // User name section
              FutureBuilder<String?>(
                future: authService.getUserName(),
                builder: (context, snapshot) {
                  String displayName =
                      snapshot.data ??
                      (user?.displayName ??
                          (user?.email?.split('@').first ?? 'User'));

                  return Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  );
                },
              ),

              Text(
                user?.email ?? '',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),

              const SizedBox(height: 40),

              // Categories section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Categories",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showAddCategoryDialog(context),
                    icon: Icon(Icons.add_circle, color: theme.primaryColor),
                    tooltip: 'Add Category',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Categories grid
              categoryViewModel.categories.isEmpty
                  ? const Center(
                    child: Text(
                      "No categories yet. Create one by tapping the + button!",
                    ),
                  )
                  : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.5,
                        ),
                    itemCount: categoryViewModel.categories.length,
                    itemBuilder: (context, index) {
                      final category = categoryViewModel.categories[index];
                      return _buildCategoryCard(context, category);
                    },
                  ),

              const SizedBox(height: 40),

              // Sign out button
              ElevatedButton(
                onPressed: () {
                  authService.signOut(context: context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text("Sign Out"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build default avatar
  Widget _buildDefaultAvatar(ThemeData theme) {
    return Container(
      color: theme.primaryColor.withOpacity(0.2),
      child: Icon(Icons.person, size: 60, color: theme.primaryColor),
    );
  }

  // Helper method to build category card
  Widget _buildCategoryCard(BuildContext context, Category category) {
    return Card(
      color: category.color,
      child: InkWell(
        onTap: () {
          // This will be implemented in future functionality to show items by category
        },
        onLongPress: () => _showEditDeleteCategoryDialog(context, category),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(category.icon, size: 32, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                category.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show dialog to add a new category
  void _showAddCategoryDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => CategoryDialog());
  }

  // Show dialog to edit or delete a category
  void _showEditDeleteCategoryDialog(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (context) => CategoryDialog(category: category),
    );
  }
}

class CategoryDialog extends StatefulWidget {
  final Category? category;

  const CategoryDialog({super.key, this.category});

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  late TextEditingController _titleController;
  late Color _selectedColor;
  late IconData _selectedIcon;

  // Predefined color options - smaller set to reduce rendering load
  final List<Color> _colorOptions = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.teal,
  ];

  // Predefined icon options - using static Material icons to avoid Material Symbols rendering issues
  final List<IconData> _iconOptions = [
    Icons.school,
    Icons.science,
    Icons.history_edu,
    Icons.calculate,
    Icons.psychology,
    Icons.sports_soccer,
    Icons.music_note,
    Icons.palette,
    Icons.language,
    Icons.computer,
    Icons.book,
    Icons.biotech,
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.category?.title ?? '',
    );
    _selectedColor = widget.category?.color ?? _colorOptions[0];
    _selectedIcon = widget.category?.icon ?? _iconOptions[0];
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.category != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dialog title
            Text(
              isEditing ? 'Edit Category' : 'Create Category',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Title field
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Category Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Color selection
            const Text(
              'Select Color:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Color options in a wrap
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _colorOptions.map((color) {
                    final isSelected = _selectedColor == color;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                isSelected ? Colors.white : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow:
                              isSelected
                                  ? [
                                    BoxShadow(
                                      color: Colors.black26,
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                    ),
                                  ]
                                  : null,
                        ),
                        child:
                            isSelected
                                ? const Icon(Icons.check, color: Colors.white)
                                : null,
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),

            // Icon selection
            const Text(
              'Select Icon:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Icon options in a wrap - avoids GridView which can cause rendering issues
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _iconOptions.map((icon) {
                    final isSelected = _selectedIcon == icon;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIcon = icon;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? theme.primaryColor
                                  : Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                if (isEditing)
                  TextButton(
                    onPressed: () => _confirmDelete(context),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _saveCategory(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(isEditing ? 'Update' : 'Create'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Simplified confirmation delete method
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Category'),
            content: const Text(
              'Are you sure you want to delete this category?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteCategory(context);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  // Save category method
  void _saveCategory(BuildContext context) {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a category title')),
      );
      return;
    }

    try {
      final categoryViewModel = Provider.of<CategoryViewModel>(
        context,
        listen: false,
      );

      if (widget.category == null) {
        // Create new category
        final newCategory = Category(
          title: title,
          color: _selectedColor,
          icon: _selectedIcon,
        );
        categoryViewModel.addCategory(newCategory);
      } else {
        // Update existing category
        final updatedCategory = widget.category!.copyWith(
          title: title,
          color: _selectedColor,
          icon: _selectedIcon,
        );
        categoryViewModel.updateCategory(updatedCategory);
      }

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  // Delete category method
  void _deleteCategory(BuildContext context) {
    if (widget.category?.id == null) return;

    try {
      final categoryViewModel = Provider.of<CategoryViewModel>(
        context,
        listen: false,
      );
      categoryViewModel.deleteCategory(widget.category!.id!);
      Navigator.of(context).pop(); // Close the main dialog
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }
}
