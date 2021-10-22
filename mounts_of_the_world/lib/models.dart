//- MODELS
import 'package:flutter/material.dart';

class MountModel {
  String path;
  String name;
  String location;
  String description;
  MountModel({
    this.path = '',
    this.name = '',
    this.location = '',
    this.description = '',
  });
}

class CategoryModel {
  String category;
  IconData? icon;

  CategoryModel({this.category = '', this.icon});
}

class AppBottomBarItem {
  IconData? icon;
  bool isSelected;
  String label;

  AppBottomBarItem({
    this.icon,
    this.label = '',
    this.isSelected = false,
  });
}
