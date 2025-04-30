import 'package:flutter/material.dart';
import 'package:event/model/utilisateur.dart';
import 'package:event/service/utilisateurService.dart';

class UtilisateurProvider extends ChangeNotifier {
  final UtilisateurService _utilisateurService = UtilisateurService();
  Utilisateur? _utilisateur;
  bool _isLoading = true;
  String? _error;

  Utilisateur? get utilisateur => _utilisateur;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchUtilisateurConnecte() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _utilisateur = await _utilisateurService.getUtilisateurConnecte();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}