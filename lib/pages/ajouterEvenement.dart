import 'dart:convert';
import 'dart:io';

import 'package:event/model/evenement.dart';
import 'package:event/model/utilisateur.dart';
import 'package:event/service/utilisateurService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:event/providers/categorie_provider.dart';
import 'dart:developer';


class AjouterEvenementPage extends StatefulWidget {
  const AjouterEvenementPage({super.key});

  @override
  State<AjouterEvenementPage> createState() => _AjouterEvenementPageState();
}

class _AjouterEvenementPageState extends State<AjouterEvenementPage> {
  final _formKey = GlobalKey<FormState>();
  final UtilisateurService _utilisateurService = UtilisateurService();

  SignatureController signatureController = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.white,
    exportBackgroundColor: Colors.transparent,
    exportPenColor: Colors.black,
    onDrawStart: () => log('onDrawStart called!'),
    onDrawEnd: () => log('onDrawEnd called!'),
  );

  String _nom = '';
  String _lieu = '';
  String _description = '';
  String? _categorie;
  DateTime _date = DateTime.now();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Utilisateur? _utilisateurConnecte;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _touverUtilisateurConnecte();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategorieProvider>(context, listen: false).fetchCategories();
    });
  }

  Future<void> _touverUtilisateurConnecte() async {
    try {
      final utilisateur = await _utilisateurService.getUtilisateurConnecte();
      setState(() {
        _utilisateurConnecte = utilisateur;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  Future<void> _importerImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _saveEvenement() async {
    if (_formKey.currentState!.validate() && _utilisateurConnecte != null) {
      _formKey.currentState!.save();

      final signatureBase64 = await _exporterSignature();

      final newEvenement = Evenement(
        nom: _nom,
        date: _date,
        lieu: _lieu,
        description: _description,
        categorie: _categorie!,
        imageUrl: _imageFile?.path ?? "assets/images/defaut.jpg",
        isAsset: _imageFile == null,
        utilisateur: _utilisateurConnecte!,
        signature: signatureBase64,
      );

      try {
        await Provider.of<EvenementProvider>(context, listen: false)
            .ajouterEvenement(newEvenement);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Événement ajouté avec succès !')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categorieProvider = Provider.of<CategorieProvider>(context);

    if (_isLoading || categorieProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (categorieProvider.error != null) {
      return Scaffold(
        body: Center(child: Text('Erreur : ${categorieProvider.error}')),
      );
    }

    final categories = categorieProvider.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un événement', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer un nom.' : null,
                onSaved: (value) => _nom = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Lieu'),
                validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer un lieu.' : null,
                onSaved: (value) => _lieu = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer une description.' : null,
                onSaved: (value) => _description = value!,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Catégorie'),
                value: _categorie,
                items: categories
                    .map((categorie) => DropdownMenuItem(
                          value: categorie.nom,
                          child: Text(categorie.nom),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _categorie = value),
                validator: (value) => value == null ? 'Veuillez sélectionner une catégorie.' : null,
              ),
              const SizedBox(height: 16),




              GestureDetector(
                onTap: () => _selectDate(context),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.deepPurple),
                    const SizedBox(width: 10),
                    Text(
                      "Date : ${DateFormat("dd/MM/yyyy").format(_date)}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                  ],
                ),
              ),




              const SizedBox(height: 16),
              const Text("Image de l'événement :", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _importerImage,
                child: _imageFile != null
                    ? Image.file(
                        _imageFile!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : TextButton.icon(
                        onPressed: _importerImage,
                        icon: const Icon(Icons.image),
                        label: const Text("Choisir une image"),
                      ),
              ),
              const SizedBox(height: 16),

              Signature(
                key: const Key('signature'),
                controller: signatureController,
                height: 300,
                backgroundColor: Colors.grey,
              ),

               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.undo),
                      color: Colors.black,
                      onPressed: () {
                        setState(() => signatureController.undo());
                      },
                      tooltip: 'Undo',
                    ),
                    IconButton(
                      icon: const Icon(Icons.redo),
                      color: Colors.black,
                      onPressed: () {
                        setState(() => signatureController.redo());
                      },
                      tooltip: 'Redo',
                    ),

                    IconButton(
                      key: const Key('clear'),
                      icon: const Icon(Icons.clear),
                      color: Colors.black,
                      onPressed: () {
                        setState(() => signatureController.clear());
                      },
                      tooltip: 'Clear',
                    ),

                    IconButton(
                      key: const Key('stop'),
                      icon: Icon(
                        signatureController.disabled ? Icons.pause : Icons.play_arrow,
                      ),
                      color: Colors.black,
                      onPressed: () {
                        setState(() => signatureController.disabled = !signatureController.disabled);
                      },
                      tooltip: signatureController.disabled ? 'Pause' : 'Play',
                    ),
                  ],
                ),

              ElevatedButton(
                onPressed: _saveEvenement,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                child: const Text('Enregistrer', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _exporterSignature() async {
  if (signatureController.isEmpty) {
    return null; // Pas de signature
  }

  final signature = await signatureController.toPngBytes();
  if (signature == null) {
    return null;
  }

  // Encode l'image en base64
  return base64Encode(signature);
}
}

