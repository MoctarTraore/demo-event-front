import 'package:flutter/material.dart';
import '../service/categorie_service.dart';
import '../model/categorie.dart';

class CategorieProvider extends ChangeNotifier {
  final CategorieService _categorieService = CategorieService();
  List<Categorie> _categories = [];
  bool _isLoading = true;
  String? _error;

  List<Categorie> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCategories() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final categoriesStr = await _categorieService.fetchCategories();
      _categories = categoriesStr.map((str) => Categorie(str)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}