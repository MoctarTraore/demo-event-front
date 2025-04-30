import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/utilisateur.dart';

class UtilisateurService {
  final String Url = 'http://10.0.2.2:8080/api/utilisateurs';

  Future<List<Utilisateur>> getAllUtilisateurs() async {
    final response = await http.get(Uri.parse(Url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Utilisateur.fromJson(json)).toList();
    }
    throw Exception('Erreur de chargement des utilisateurs');
  }

  Future<Utilisateur> getUtilisateurById(int id) async {
    final response = await http.get(Uri.parse('$Url/$id'));
    if (response.statusCode == 200) {
      return Utilisateur.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    }
    throw Exception('Utilisateur non trouvé');
  }

  Future<Utilisateur> createUtilisateur(Utilisateur utilisateur) async {
    final response = await http.post(
      Uri.parse(Url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(utilisateur.toJson()),
    );
    if (response.statusCode == 201) {
      return Utilisateur.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    }
    throw Exception('Erreur lors de la création de l\'utilisateur');
  }

  Future<Utilisateur> updateUtilisateur(int id, Utilisateur utilisateur) async {
    final response = await http.put(
      Uri.parse('$Url/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(utilisateur.toJson()),
    );
    if (response.statusCode == 200) {
      return Utilisateur.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    }
    throw Exception('Erreur lors de la mise à jour de l\'utilisateur');
  }

  Future<void> deleteUtilisateur(int id) async {
    final response = await http.delete(Uri.parse('$Url/$id'));
    if (response.statusCode != 204) {
      throw Exception('Erreur lors de la suppression de l\'utilisateur');
    }
  }

  Future<Utilisateur> getUtilisateurConnecte() async {
    const int userId = 2;
    final response = await http.get(Uri.parse('$Url/$userId'));
    if (response.statusCode == 200) {
      return Utilisateur.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    }
    throw Exception('Erreur lors de la récupération de l\'utilisateur connecté');
  }
}
