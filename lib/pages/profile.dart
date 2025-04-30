import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/utilisateur_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UtilisateurProvider>(
      builder: (context, utilisateurProvider, child) {
        if (utilisateurProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (utilisateurProvider.error != null) {
          return Center(child: Text('Erreur : ${utilisateurProvider.error}'));
        }

        final utilisateur = utilisateurProvider.utilisateur;

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('assets/images/profile.jpg'),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        utilisateur?.nom ?? 'Utilisateur',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        utilisateur?.email ?? 'Email non disponible',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informations personnelles',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        leading: const Icon(Icons.person, color: Colors.deepPurple),
                        title: const Text('Nom complet'),
                        subtitle: Text(utilisateur?.nom ?? 'Nom non disponible'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.email, color: Colors.deepPurple),
                        title: const Text('Email'),
                        subtitle: Text(utilisateur?.email ?? 'Email non disponible'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.phone, color: Colors.deepPurple),
                        title: const Text('Téléphone'),
                        subtitle: Text(utilisateur?.telephone ?? 'Téléphone non disponible'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.location_on, color: Colors.deepPurple),
                        title: const Text('Adresse'),
                        subtitle: Text(utilisateur?.adresse ?? 'Adresse non disponible'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
