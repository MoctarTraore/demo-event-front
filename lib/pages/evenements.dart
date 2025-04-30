import 'package:flutter/material.dart';
import 'package:event/model/evenement.dart';
import 'package:event/widgets/evenement_card.dart';
import 'package:event/pages/ajouterEvenement.dart';
import 'package:provider/provider.dart';

class EvenementsPage extends StatefulWidget {
  const EvenementsPage({super.key});

  @override
  State<EvenementsPage> createState() => _EvenementsPageState();
}

class _EvenementsPageState extends State<EvenementsPage> {
  List<Evenement>? _evenements;
  String? _error;
  static const int userId = 2; 

  @override
  void initState() {
    super.initState();
    _loadUserEvenements();
  }

  Future<void> _loadUserEvenements() async {
    try {
      final evenements = await Provider.of<EvenementProvider>(context, listen: false)
          .getEvenementsByUserId(userId);
      setState(() => _evenements = evenements);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_evenements == null && _error == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AjouterEvenementPage()),
                );
                _loadUserEvenements();
              },
              icon: const Icon(Icons.add),
              label: const Text("Ajouter"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
        ),
        if (_error != null)
          Center(child: Text('Erreur: $_error'))
        else
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadUserEvenements,
              child: _evenements!.isEmpty
                  ? const Center(
                      child: Text(
                        "Aucun événement créé.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _evenements!.length,
                      itemBuilder: (context, index) {
                        return EvenementCard(evenement: _evenements![index]);
                      },
                    ),
            ),
          ),
      ],
    );
  }
}
