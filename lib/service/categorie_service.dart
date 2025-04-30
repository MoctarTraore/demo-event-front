import 'dart:convert';
import 'package:http/http.dart' as http;

class CategorieService {
  final String Url = 'http://10.0.2.2:8080/api/categories';

  Future<List<String>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(Url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => item.toString()).toList();
      }
      throw Exception('Erreur de chargement des catégories: ${response.statusCode}');
    } catch (e) {
      throw Exception('Erreur de récupération des catégories : $e');
    }
  }
}