import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:focusly/model/category_model.dart';
import 'package:focusly/services/authentication_service.dart';
import 'package:focusly/viewmodel/category_viewmodel.dart';
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
        padding: const EdgeInsets.only(right: 16.0, left: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // profile picture section
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
                                // google profile pic if available
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
                                // default avatar for email/password users
                                : _buildDefaultAvatar(theme),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // username section
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

              // categories section
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your Categories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showAddCategoryDialog(context),
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: theme.primaryColor,
                      ),
                      tooltip: 'Add Category',
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 6.0, left: 6.0),
                child: const Divider(),
              ),

              const SizedBox(height: 8),
              // categories grid
              categoryViewModel.categories.isEmpty
                  ? Padding(
                    padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                    child: const Center(
                      child: Text(
                        "No categories yet. Create one by tapping the + button!",
                        style: TextStyle(fontSize: 13),
                      ),
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

              // sign out button
              ElevatedButton(
                onPressed: () async {
                  // confirmation dialog
                  bool confirmSignOut =
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Sign Out'),
                            content: const Text(
                              'Are you sure you want to sign out?',
                            ),
                            actions: [
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(true),
                                child: const Text(
                                  'Sign Out',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      ) ??
                      false;

                  if (confirmSignOut) {
                    try {
                      // Show loading indicator
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder:
                            (context) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                      );

                      final categoryViewModel = Provider.of<CategoryViewModel>(
                        context,
                        listen: false,
                      );

                      // cleanup for categories
                      await categoryViewModel.cleanupForSignOut();

                      await FirebaseAuth.instance.signOut();
    
                      if (context.mounted) {
                        Navigator.of(
                          context,
                        ).pushNamedAndRemoveUntil('/splash', (route) => false);
                      }
                    } catch (e) {
                      debugPrint('Sign out error: $e');
                      // if theres an error force navigation to splash screen
                      if (context.mounted) {
                        Navigator.of(
                          context,
                        ).pushNamedAndRemoveUntil('/splash', (route) => false);
                      }
                    }
                  }
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

  Widget _buildDefaultAvatar(ThemeData theme) {
    return Container(
      color: theme.primaryColor.withOpacity(0.2),
      child: Icon(Icons.person, size: 60, color: theme.primaryColor),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Category category) {
    return Card(
      color: category.color,
      child: InkWell(
        onTap: () {
          // to be implemented
        },
        onLongPress: () => _showEditDeleteCategoryDialog(context, category),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(category.icon, size: 32, color: category.textColor),
              const SizedBox(height: 8),
              Text(
                category.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: category.textColor,
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

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => CategoryDialog());
  }

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
  final GlobalKey _iconButtonKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  // predefined color options
  final List<Color> _colorOptions = [
    Color(0xffFFC2D4),
    Color(0xff98C9A3),
    Color(0xffB6CCFE),
    Color(0xffFAE588),
    Color(0xffFFD19F),
    Color(0xffDF7373),
  ];

  // predefined icon options
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
    _hideIconSelector();
    _titleController.dispose();
    super.dispose();
  }

  void _showIconSelector() {
    _hideIconSelector();

    final RenderBox? iconButton =
        _iconButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (iconButton == null) return;

    final RenderBox? overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (overlay == null) return;

    final buttonPosition = iconButton.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );
    final buttonSize = iconButton.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: buttonPosition.dx - 150, 
          top:
              buttonPosition.dy +
              buttonSize.height +
              8, 
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 240,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select Icon',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    constraints: BoxConstraints(maxHeight: 200),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _iconOptions.length,
                      itemBuilder: (context, index) {
                        final icon = _iconOptions[index];
                        final isSelected = _selectedIcon == icon;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIcon = icon;
                            });
                            _hideIconSelector();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              icon,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideIconSelector() {
    _overlayEntry?.remove();
    _overlayEntry = null;
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
            Text(
              isEditing ? 'Edit Category' : 'Create Category',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  key: _iconButtonKey, 
                  onTap: _showIconSelector,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(_selectedIcon, color: theme.primaryColor),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            const Text(
              'Select Color:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

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
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(12),
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
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    _hideIconSelector(); // ensure overlay is removed
                    Navigator.of(context).pop();
                  },
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

  void _confirmDelete(BuildContext context) {
    _hideIconSelector(); // Ensure overlay is removed
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

  void _saveCategory(BuildContext context) {
    _hideIconSelector(); // Ensure overlay is removed
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

      // check for duplicate title before saving
      final String? currentCategoryId = widget.category?.id;
      if (categoryViewModel.categoryTitleExists(title, currentCategoryId)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('A category with this title already exists'),
          ),
        );
        return;
      }

      if (widget.category == null) {
        // create new category
        final newCategory = Category(
          title: title,
          color: _selectedColor,
          icon: _selectedIcon,
        );
        categoryViewModel.addCategory(newCategory);

        // refresh categories to ensure they appear
        Future.delayed(Duration(milliseconds: 500), () {
          categoryViewModel.refreshCategories();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category created successfully')),
        );

      } else {
        // update existing category
        final updatedCategory = widget.category!.copyWith(
          title: title,
          color: _selectedColor,
          icon: _selectedIcon,
        );
        categoryViewModel.updateCategory(updatedCategory);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category updated successfully')),
        );
      }

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  void _deleteCategory(BuildContext context) {
    if (widget.category?.id == null) return;

    try {
      final categoryViewModel = Provider.of<CategoryViewModel>(
        context,
        listen: false,
      );
      categoryViewModel.deleteCategory(widget.category!.id!);
      Navigator.of(context).pop(); 
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }
}
