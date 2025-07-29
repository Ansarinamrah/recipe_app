import 'package:flutter/cupertino.dart';

class CategoryModel {
  final String id;
  final String name;
  final String thumb;
  final String description;

  CategoryModel({
    required this.id,
    required this.name,
    required this.thumb,
    required this.description,
  });
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['idCategory'] ?? '',
      name: map['strCategory'] ?? '',
      thumb: map['strCategoryThumb'] ?? '',
      description: map['strCategoryDescription'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_idCategory': id,
    'strCategory':name,
      'strCategoryThumb':thumb,
      'strCategoryDescription':description
    };}}
