import 'package:flutter/material.dart';

class Category {
  final String? id;
  final String title;
  final Color color;
  final IconData icon;

  Category({
    this.id,
    required this.title,
    required this.color,
    required this.icon,
  });

  Category copyWith({String? id, String? title, Color? color, IconData? icon}) {
    return Category(
      id: id ?? this.id,
      title: title ?? this.title,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'colorValue': color.value,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'] ?? 'Untitled',
      color: Color(
        json['colorValue'] ?? 0xFF9C27B0,
      ), // Default purple if missing
      icon: IconData(
        json['iconCodePoint'] ?? Icons.category.codePoint,
        fontFamily: json['iconFontFamily'] ?? Icons.category.fontFamily,
      ),
    );
  }
}
