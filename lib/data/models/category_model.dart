import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String code; // e.g. "TI-301"
  final Color color;
  final IconData icon;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.code,
    required this.color,
    this.icon = Icons.book_outlined,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'colorValue': color.toARGB32(),
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map, {IconData icon = Icons.book_outlined}) {
    return CategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      color: Color(map['colorValue'] as int),
      icon: icon,
    );
  }
}

