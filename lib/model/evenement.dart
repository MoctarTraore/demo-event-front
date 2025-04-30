import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'utilisateur.dart';


class Evenement {
  int? id;
  String nom;
  DateTime date;
  String lieu;
  String description;
  String categorie;
  String imageUrl;
  bool isAsset;
  bool isFavorite;
  Utilisateur utilisateur;
  String? signature;

  Evenement({
    this.id,
    required this.nom,
    required this.date,
    required this.lieu,
    required this.description,
    required this.categorie,
    required this.imageUrl,
    required this.isAsset,
    this.isFavorite = false,
    required this.utilisateur,
    this.signature,
  });

  String getFormattedDate() {
    return "${date.day}/${date.month}/${date.year}";
  }

  factory Evenement.fromJson(Map<String, dynamic> json) {
    return Evenement(
      id: json['id'],
      nom: json['nom'],
      date: DateTime.parse(json['date']),
      lieu: json['lieu'],
      description: json['description'],
      categorie: json['categorie'],
      imageUrl: json['imageUrl'],
      isAsset: json['isAsset'],
      isFavorite: json['isFavorite'] ?? false,
      utilisateur: Utilisateur.fromJson(json['utilisateur']),
      signature: json['signature'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'date': date.toIso8601String(),
      'lieu': lieu,
      'description': description,
      'categorie': categorie,
      'imageUrl': imageUrl,
      'isAsset': isAsset,
      'isFavorite': isFavorite,
      'utilisateur': utilisateur.toJson(),
      'signature': signature,
    };
  }
}

class EvenementProvider extends ChangeNotifier {
  List<Evenement> _evenements = [];
  final String Url = 'http://10.0.2.2:8080/api/evenements';

  List<Evenement> get evenements => _evenements;
  List<Evenement> get favoris => _evenements.where((e) => e.isFavorite).toList();

  Future<void> fetchEvenements() async {
    try {
      final response = await http.get(Uri.parse(Url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        _evenements = data.map((json) => Evenement.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Erreur de chargement : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur de récupération des événements : $e');
      rethrow;
    }
  }

  Future<Evenement> getEvenementById(int id) async {
    final response = await http.get(Uri.parse('$Url/$id'));
    if (response.statusCode == 200) {
      return Evenement.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    }
    throw Exception('Événement non trouvé');
  }

  Future<List<Evenement>> getEvenementsByUserId(int userId) async {
    final response = await http.get(Uri.parse('$Url/user/$userId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Evenement.fromJson(json)).toList();
    }
    throw Exception('Erreur lors de la récupération des événements de l\'utilisateur');
  }

  Future<List<Evenement>> getEvenementsByCategorie(String categorie) async {
    final response = await http.get(Uri.parse('$Url/categorie/$categorie'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Evenement.fromJson(json)).toList();
    }
    throw Exception('Erreur lors de la récupération des événements par catégorie');
  }

  Future<int> getNombreEvenementsParCategorie(String categorie) async {
    final response = await http.get(Uri.parse('$Url/categorie/$categorie'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.length;
    }
    throw Exception('Erreur lors de la récupération des événements pour la catégorie $categorie');
  }

  Future<void> ajouterEvenement(Evenement evenement) async {
    final response = await http.post(
      Uri.parse(Url),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(evenement.toJson()),
    );
    if (response.statusCode == 201) {
      final newEvenement = Evenement.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      _evenements.add(newEvenement);
      notifyListeners();
    } else {
      throw Exception('Erreur lors de la création de l\'événement');
    }
  }

  Future<void> updateEvenement(int id, Evenement evenement) async {
    final response = await http.put(
      Uri.parse('$Url/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(evenement.toJson()),
    );
    if (response.statusCode == 200) {
      final index = _evenements.indexWhere((e) => e.id == id);
      if (index != -1) {
        _evenements[index] = Evenement.fromJson(json.decode(utf8.decode(response.bodyBytes)));
        notifyListeners();
      }
    } else {
      throw Exception('Erreur lors de la mise à jour de l\'événement');
    }
  }

  Future<void> deleteEvenement(int id) async {
    final response = await http.delete(Uri.parse('$Url/$id'));
    if (response.statusCode == 204) {
      _evenements.removeWhere((e) => e.id == id);
      notifyListeners();
    } else {
      throw Exception('Erreur lors de la suppression de l\'événement');
    }
  }

  void toggleFavorite(Evenement evenement) {
    final index = _evenements.indexOf(evenement);
    if (index != -1) {
      _evenements[index].isFavorite = !_evenements[index].isFavorite;
      notifyListeners();
    }
  }

  Future<List<Evenement>> rechercherEvenementParNom(String nom) async {
    final response = await http.get(Uri.parse('$Url?nom=$nom'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Evenement.fromJson(json)).toList();
    }
    throw Exception('Erreur lors de la recherche de l\'événement');
  }
}


