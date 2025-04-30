import 'package:flutter/material.dart';
import 'package:event/model/evenement.dart';
import 'package:event/widgets/evenement_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEvenements();
  }

  Future<void> _loadEvenements() async {
    try {
      await Provider.of<EvenementProvider>(context, listen: false).fetchEvenements();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text('Erreur: $_error'));
    }

    final evenements = Provider.of<EvenementProvider>(context).evenements;

    return RefreshIndicator(
      onRefresh: _loadEvenements,
      child: evenements.isEmpty
          ? const Center(child: Text('Aucun événement disponible'))
          : ListView.builder(
              itemCount: evenements.length,
              itemBuilder: (context, index) {
                return EvenementCard(evenement: evenements[index]);
              },
            ),
    );


  }

}
