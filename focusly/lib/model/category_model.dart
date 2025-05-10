import 'package:flutter/material.dart';

class Category {
  final String? id;
  final String title;
  final Color color;
  final Color textColor; // New field for text/icon color
  final IconData icon;

  Category({
    this.id,
    required this.title,
    required this.color,
    Color? textColor, // Optional parameter with default mapping in constructor
    required this.icon,
  }) : textColor = textColor ?? _getTextColorForBackground(color);

  // Static mapping between background colors and corresponding text colors
  static Color _getTextColorForBackground(Color backgroundColor) {
    // Map of predefined background colors to text colors
    final colorMap = {
      0xffFFC2D4: Color(0xffE05780), // Pink bg -> Purple text
      0xff98C9A3: Color(0xff4F772D), // Green bg -> Indigo text
      0xffB6CCFE: Color(0xff0077B6), // Light blue bg -> Orange text
      0xffFAE588: Color(0xffB69121), // Yellow bg -> Teal text
      0xffFFD19F: Color(0xffF3722C), // Peach bg -> Blue text
      0xffDF7373: Color(0xff85182A), // Red bg -> White text
      //0xFF9C27B0: Colors.amber, // Purple bg -> Amber text
    };

    // Return matched color or default to black
    return colorMap[backgroundColor.value] ?? Colors.black;
  }

  Category copyWith({
    String? id,
    String? title,
    Color? color,
    Color? textColor,
    IconData? icon,
  }) {
    return Category(
      id: id ?? this.id,
      title: title ?? this.title,
      color: color ?? this.color,
      textColor: textColor ?? this.textColor,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'colorValue': color.value,
      'textColorValue': textColor.value, // Store text color value
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    final color = Color(json['colorValue'] ?? 0xFF9C27B0);

    return Category(
      id: json['id'],
      title: json['title'] ?? 'Untitled',
      color: color,
      // Use stored text color if available, otherwise calculate based on background
      textColor:
          json['textColorValue'] != null
              ? Color(json['textColorValue'])
              : _getTextColorForBackground(color),
      icon: IconData(
        json['iconCodePoint'] ?? Icons.category.codePoint,
        fontFamily: json['iconFontFamily'] ?? Icons.category.fontFamily,
      ),
    );
  }
}
